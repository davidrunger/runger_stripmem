# Runger Stripmem

Show a live chart of your process's memory usage.

![example](https://f.cloud.github.com/assets/20158/812189/e4b87038-eeeb-11e2-9ead-f4c4e6b5b589.png)

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
