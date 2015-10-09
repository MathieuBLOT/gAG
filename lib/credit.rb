#!/usr/bin/env ruby

require 'set'

require_relative 'subject.rb'

class Credit
	attr_accessor :name
	attr_reader :coeff, :average

	def initialize(name, subjects = [])
		@name = name
		@subjects = Set.new(subjects)
		@coeff = subjects.inject(0) { |sum, subject| sum + subject.coeff}
		compute_average
	end

	def subjects
		return @subjects.to_a
	end

	def add_subject(subject)
		if @subjects.add?(subject)
			@average ||= 0
			avg = @average*@coeff
			@coeff += subject.coeff
			if subject.grade
				@average = (avg + subject.grade*subject.coeff)/(@coeff.to_f)
			end
		end
	end

	def add_subjects(*subjects)
		subjects.each { |subject| self.add_subject(subject) }
	end

	def rm_subject(subject)
		if @subjects.delete?(subject)
			@average ||= 0
			avg = @average*@coeff
			@coeff -= subject.coeff
			if @subjects.empty?
				@average = nil
			elsif subject.grade
				@average = (avg - subject.grade*subject.coeff)/(@coeff.to_f)
			end
		end
	end

	def rm_subjects(*subjects)
		subjects.each { |subject| self.rm_subject(subject) }
	end

	private

	def compute_average
		if @subjects.empty?
			@average = nil
		else
			avg = @subjects.inject(0) {|sum, subject| sum + subject.coeff*subject.grade}
			@average = avg/(@coeff.to_f)
		end
	end
end
