#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../lib/dates'

$dates = nil

SUB_COMMANDS = %w(list choose)
VERSION_STR = "dates 1.0.0-beta, max & daphne."
global_opts = Trollop::options do
  version VERSION_STR
  banner <<-EOS
#{VERSION_STR}
Usage: dates.rb [command] [options] <ideas-file>

To see help for a specific command, use the --help switch on that command.

Commands:
  choose  Choose a good date idea for right now! [default command]
  list    Parse and list the contents of the date ideas file.

Global options:
EOS

  stop_on SUB_COMMANDS
end

cmd = ARGV.shift if ARGV.length > 1

cmd_opts = case cmd
  when "list"
    Trollop::options do
      version VERSION_STR
      banner "#{VERSION_STR}\nOptions for `list` command:"
      opt :incomplete, "Only the incomplete dates", :short => :i
      opt :complete, "Only the completed dates (with feedback)", :short => :c
    end
  else # `choose` is default command: can be called without explicit specification
    Trollop::options do
      version VERSION_STR
      banner "#{VERSION_STR}\nOptions for `choose` command:"
      opt :weather, "Current weather score [0-9]", :short => :w, :default => 5.0
      opt :time, "Time commitment score [0-9]", :short => :t, :default => 5.0
    end
  end

if ARGV.length < 1
  Trollop::die "Ideas file required"
  exit 1
end

require ARGV.last

if nil == $dates
  Trollop::die "Invalid ideas file"
  exit 1
end

if "list" == cmd
  if cmd_opts[:complete] and cmd_opts[:incomplete]
    Trollop::die "-i and -c are mutually exclusive options for `list`"
  else
    puts $dates.list(cmd_opts)
  end
elsif "choose" == cmd
  puts $dates.choose(cmd_opts[:weather], cmd_opts[:time])
else
  puts $dates.choose(cmd_opts[:weather], cmd_opts[:time])
end