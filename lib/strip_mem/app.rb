# frozen_string_literal: true

require 'English'
require 'eventmachine'
require 'strip_mem'

if RUBY_VERSION.match?(/^1.8/)
  module Enumerable
    def each_with_object(obj)
      each do |x|
        yield(x, obj)
      end
      obj
    end
  end
end

class StripMem::App
  def self.run!(argv)
    new(argv).run!
  end

  def initialize(argv)
    @command = argv
    @start_time = Time.now
  end

  attr_reader :command, :start_time

  def run!
    @timers = []
    EventMachine.run do
      spawn!
      channel = EM::Channel.new
      @timers = [
        EM::PeriodicTimer.new(1.0) { find_children },
        EM::PeriodicTimer.new(0.2) { ps(channel) },
        EM::PeriodicTimer.new(1.0) { wait_child },
      ]
      StripMem::WebSocket.new(channel).run!
      Thread.new do
        # This doesn't return until sinatra exits. (Sinatra handles SIGINT.)
        StripMem::Web.new(channel).run!
        kill!
        EM.stop
        exit
      end
    end
    kill!
  end

  def kill!
    unless @child_status
      Process.kill('QUIT', Integer(@child, 10))
    end
  rescue => e
    puts("kill #{@child.inspect}: #{e}")
  end

  def find_children
    children =
      `ps a -o ppid=,pid=,command=`.lines.each_with_object(Hash.new do |h, k|
        h[k] =
          []
      end) do |line, h|
        (line =~ /(\d+) +(\d+) +(.*)/) && h[::Regexp.last_match(1)].push(
          pid: ::Regexp.last_match(2),
          name: ::Regexp.last_match(3),
        )
      end
    parents = processes.keys
    while (parent = parents.shift)
      children[parent.to_s].each do |child|
        if !/^ps /.match?(child[:name])
          pid = Integer(child[:pid], 10)
          parents << pid
          processes[pid] ||= child[:name]
        end
      end
    end
  end

  def ps(channel)
    ps =
      processes.keys.each_with_object({}) do |pid, h|
        status = File.read("/proc/#{pid}/status")
        anon  = Integer(status[/^RssAnon:\s+(\d+)/, 1], 10) # kB (preferred)
        swap  = Integer(status[/^VmSwap:\s+(\d+)/, 1], 10) # kB
        h[pid] = anon + swap
      rescue Errno::ENOENT, Errno::EACCES
        # process already gone or we lack permission
      end

    offset = Time.now - start_time
    channel.push(
      offset:,
      samples: processes.map do |pid, name|
        { name: "[#{pid}] #{name}", anon_plus_swap: ps[pid] }
      end,
    )
  end

  def processes
    @processes ||= { $PROCESS_ID => '(stripmem)' }
  end

  def spawn!
    @child =
      fork do
        exec(*command)
      end
    processes[@child] = command.join(' ')
  end

  def wait_child
    if @child_status ||= Process.waitpid2(-1, Process::WNOHANG)
      @timers.each(&:cancel)
    end
  end
end
