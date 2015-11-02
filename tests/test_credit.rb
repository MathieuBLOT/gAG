#!/usr/bin/env ruby

require 'lib/credit.rb'
require 'minitest/autorun'

class Test_Credit < Minitest::Test
	def test_initialized_credit
		credit_name = "Credit lambda"
		s1 = Subject.new("Token 1", 1, 10)
		s2 = Subject.new("Token 2", 4, 15)
		credit = Credit.new(credit_name, [s1, s2])

		assert_equal(credit_name, credit.name)
		assert_equal(5, credit.coeff)
		assert_equal(14, credit.average)
	end

	def test_uninitialized_credit
		credit = Credit.new("Empty Credit")

		assert_equal([], credit.subjects)
		assert_equal(0, credit.coeff)
		assert_equal(nil, credit.average)
	end

	def test_add_remove_subjects
		credit = Credit.new("Empty Credit")

		s1 = Subject.new("Token 1", 1, 10)
		s2 = Subject.new("Token 2", 4, 15)
		s3 = Subject.new("Token 3", 15, 2)

		credit.add_subject(s1)
		assert_equal([s1], credit.subjects)
		assert_equal(1, credit.coeff)
		assert_equal(10, credit.average)

		credit.add_subjects(s2, s3)
		assert_equal([s1, s2, s3], credit.subjects)
		assert_equal(20, credit.coeff)
		assert_equal(5, credit.average)

		credit.rm_subject(s3)
		assert_equal([s1, s2], credit.subjects)
		assert_equal(5, credit.coeff)
		assert_equal(14.0, credit.average)

		credit.rm_subjects(*credit.subjects)
		assert_equal([], credit.subjects)
		assert_equal(0, credit.coeff)
		assert_equal(nil, credit.average)
	end

	def test_unique_subject
		credit_name = "Credit lambda"
		s1 = Subject.new("Token Id", 1, 10)
		s2 = Subject.new("Token Id", 4, 15)
		credit = Credit.new(credit_name, [s1, s2])

		assert_equal([s1], credit.subjects)
	end
end
