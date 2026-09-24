# Runger Stripmem

Show a live chart of your process's memory usage.

![example](https://f.cloud.github.com/assets/20158/812189/e4b87038-eeeb-11e2-9ead-f4c4e6b5b589.png)

## ⚠️ Linux only ⚠️

`runger_stripmem` reads process memory information directly from `/proc/<pid>/status` (specifically the `RssAnon` and `VmSwap` fields). These interfaces and fields are provided by the Linux kernel and do not exist on other operating systems (macOS, Windows, BSD, etc.). Because the gem depends on this Linux-specific memory accounting, `runger_stripmem` only works on Linux.

## Installation

To use `runger_stripmem` standalone, install it:

```
gem install runger_stripmem
```

To use `runger_stripmem` in an existing application, add it to your `Gemfile`:

```rb
gem 'runger_stripmem', require: false
```

## Usage

Note: although the gem is named `runger_stripmem`, the executable is just `stripmem`.

You can run this as a monitor of a new process and all processes spawned from it.

```
$ stripmem tar cfv /dev/null ~
```

If you installed it in your Gemfile, you can monitor your rails server process, too:

```
$ bundle exec stripmem rails server
```

Charts will automatically be opened at http://localhost:9999/.
