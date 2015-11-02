#!/usr/bin/env ruby

require 'minitest/autorun'

class Test_Help < Minitest::Test
	def test_is_command
		fname = File.basename(__FILE__).gsub("test_", "").gsub(".rb", "")
		assert_equal(true, $commands.has_key?(fname))
	end
end
