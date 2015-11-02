#!/usr/bin/env ruby

require 'optparse'
require_relative 'utils.rb'

def commands_path
	functions = Array.new
	search_dirs = [$GAG_LIB, $GAG_TESTS]
	search_dirs.each { |dir| functions += Dir.entries(dir).map! { |file| File.join(dir, file) } }
	functions.collect! { |file| file if File.basename(file).start_with?("cmd_") and file.end_with?(".rb") } # Remove temporary files
	functions.compact! # Remove nils
end

class Parser
	def self.parse(args)
		opt_parser = OptionParser.new do |opts|
			opts.banner = "Usage: #{File.basename(__FILE__)} function [options]\n"
			opts.banner += "\n"
			opts.banner += "gAG runner"
			opts.banner += "\n\n\n"
			opts.banner += "Help:\n"

			$commands.each do |cmd, script|
				fdesc = `#{script} --description`
				opts.banner += "\t" + 'gag ' + cmd + "\t\t" + fdesc
			end

			opts.on_tail("-h", "--help", "Print this help") do
				puts opts
				Kernel::exit
			end
		end

		if args[0][0] == '-'
			opt_parser.parse!(args)
		end

		args[0] = $commands[args[0]]
		return args.join " "
	end
end

if ARGV.length < 1
	$stderr.puts("Usage: #{File.basename(__FILE__)} function [options]")
	Kernel::exit(1)
end

command_line = Parser.parse(ARGV)

################################################################################

Kernel::exec(command_line)

$stderr.puts("An error has occured, the function was not executed")
Kernel::exit(2)
