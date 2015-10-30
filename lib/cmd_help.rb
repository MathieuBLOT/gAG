#!/usr/bin/env ruby

require 'optparse'
require_relative 'utils.rb'

class Parser
	def self.parse(options)
		description = "Help utilitary for gAG"

		opt_parser = OptionParser.new do |opts|
			opts.banner = "Usage: #{File.basename(__FILE__)} command\n"
			opts.banner += "\n"
			opts.banner += description
			opts.banner += "\n\n\n"
			opts.banner += "Help:"

			opts.on_tail("--description", "Print a description of the file") do
				puts description
				Kernel::exit
			end

			opts.on_tail("-h", "--help", "Print this help") do
				puts opts
				Kernel::exit
			end
		end

		opt_parser.parse!(options)
	end
end

Parser.parse(ARGV)

if ARGV.length < 1
	$stderr.puts("Usage: #{File.basename(__FILE__)} command")
	Kernel::exit(1)
end

help = ARGV[0]

if $commands[help]
	Kernel::exec($commands[help], "--help")
else
	$stderr.puts("The gAG command #{help} does not exist")
	Kernel::exit(1)
end
