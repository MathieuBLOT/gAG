#!/usr/bin/env ruby

require 'lib/subject.rb'
require 'minitest/autorun'

class Test_Subject < Minitest::Test
	def test_initialized_subject
		subject_name = "Subject lambda"
		subject = Subject.new(subject_name, 1, 10)

		assert_equal(subject_name, subject.name)
		assert_equal(1, subject.coeff)
		assert_equal(10, subject.grade)
	end

	def test_uninitialized_subject
		subject_name = "Subject lambda"
		subject = Subject.new("Subject lambda")

		assert_equal(subject_name, subject.name)
		assert_equal(0, subject.coeff)
		assert_equal(nil, subject.grade)

		subject.coeff = -1
		subject.grade = 100
		assert_equal(0, subject.coeff)
		assert_equal(nil, subject.grade)

		subject.coeff = 1
		subject.grade = 10
		assert_equal(1, subject.coeff)
		assert_equal(10, subject.grade)
	end

	def test_wrong_parameters
		wrong1 = Subject.new("Wrong n°1", -1)
		wrong2 = Subject.new("Wrong n°2", 0, -5)

		assert_equal(0, wrong1.coeff)
		assert_equal(nil, wrong2.grade)
	end

	def test_equality
		subject_name = "Identical subject"
		id_subj1 = Subject.new(subject_name)
		id_subj2 = Subject.new(subject_name)

		assert_equal(id_subj2, id_subj1)
		assert(id_subj1.eql?(id_subj2), "id_subj1.eql? id_subj2 expected")
	end

	def test_inequality
		id_subj1 = Subject.new("Identical subject")
		int = 1

		refute_equal(int, id_subj1)
		assert(!id_subj1.eql?(int), "not id_subj1.eql? id_subj2 expected")
	end
end
