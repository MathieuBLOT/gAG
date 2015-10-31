#!/usr/bin/env ruby

require 'minitest/autorun'

class Test_Gag < Minitest::Test
	def test_gag_returns
		success = Kernel::system("ruby #{$GAG}", [:out, :err]=>"#{$VOID}")
		assert_equal(false, success)
	end

	def test_empty_gag
		output = `ruby #{$GAG} #{$stderr.fileno}>&#{$stdout.fileno}`
		assert_equal("Usage: gag function [options]\n", output)
	end

	def test_help
		success = Kernel::system("ruby #{$GAG} --help", [:out, :err]=>"#{$VOID}")
		assert_equal(true, success)
	end

	# Create Usage test for each gag function
	$commands.each_key do |cmd|
		eval(%Q[def test_function_#{cmd}_no_arg
			output = `ruby #{$GAG} #{cmd} #{$stderr.fileno}>&#{$stdout.fileno}`
			assert_equal("Usage: ", output[0..6], "Tried to run #{cmd} function")
		end])
	end
end
