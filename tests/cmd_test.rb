#!/usr/bin/env ruby

require 'optparse'
require_relative '../lib/utils.rb'

test_dir = $GAG_TESTS

Options = Struct.new(:qty, :cov)

class Parser
	def self.parse(options)
		args = Options.new(nil, false)
		description = "Test runner utilitary for gAG"

		opt_parser = OptionParser.new do |opts|
			opts.banner = "Usage: #{File.basename(__FILE__)} [options]"
			opts.banner += "\n\n"
			opts.banner += description
			opts.banner += "\n\n\n"
			opts.banner += "Help:"

			opts.on("-a", "--all", "Run all tests") do
				args.qty = :all
			end

			opts.on("-c", "--coverage", "Run code coverage (simplecov) -- Optional with --browser") do
				args.cov = true
			end

			opts.on("-b [BROWSER]", "--browser [BROWSER]", "Run code coverage and open browser to visualize it") do |browser|
				browser ||= ENV['BROWSER']
				args.cov = browser
			end

			opts.on("-t", "--test", "Run test(s) specified as this util's arguments") do
				if ARGV.length > 0
					args.qty = ARGV.length
				else
					puts "Please specify tests scripts to use this option"
				end
			end

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
		return args
	end
end

options = Parser.parse(ARGV)

if !options.qty
	$stderr.puts("Usage: #{File.basename(__FILE__)} [options]")
	Kernel::exit(1)
end

################################################################################

tests = []

if options.qty == :all
	tests = Dir.entries(test_dir) # Find all scripts in tests/ directry
else
	tests = ARGV.collect { |argument| File.basename(argument) if File.exist?(argument) }
end

tests.delete(File.basename(__FILE__)) # Delete current file from array
tests.collect! { |file| file if file.start_with?("test_") and file.end_with?(".rb") } # Remove temporary files
tests.compact! # Remove nils
tests.uniq! # Remove duplicates

# Launch all tests
unless tests.empty?
	Process.fork do
		if options.cov
			require 'simplecov'
			SimpleCov.start
		end

		qty = tests.length
		qty = String(qty) + " " + ( qty > 1 ? "tests" : "test")
		puts " * #{qty} to run"

		tests.each { |test_script| require_relative File.join(test_dir, test_script) }

		require 'benchmark'

		Benchmark.bmbm do |b|
			b.report("Sequential testing") do
				tests.each { |test_script| require_relative File.join(test_dir, test_script) }
			end
			b.report("Threaded testing") do
				tests_threads = []
				tests.each { |test_script| tests_threads << Thread.new {require_relative File.join(test_dir, test_script)} }
				tests_threads.each { |thr| thr.join }
			end
		end
	end

	Process.wait

	if options.cov and options.cov != true
		sep = ""
		80.times { sep += '#'}
		puts sep
		puts "Opening Coverage with #{options.cov}"

		`#{options.cov} #{File.absolute_path(File.join($GAG_ROOT, "coverage", "index.html"), "/")} >#{$VOID} #{$stderr.fileno}>&#{$stdout.fileno}`
	end
end
