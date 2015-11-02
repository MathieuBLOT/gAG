#!/usr/bin/env ruby

class Subject
	attr_accessor :name
	attr_reader :coeff, :grade

	def initialize(name, coeff = 0, grade = nil)
		@name = name
		@coeff = (coeff > 0) ? coeff : 0
		@grade = (grade > 0 and grade < 20) ? grade : nil if grade
	end

	def coeff=(value)
		@coeff = (value > 0) ? value : 0
	end

	#TODO : Metaprog
	def grade=(value)
		@grade = (value > 0 and value < 20) ? value : nil
	end

	def ==(other)
		if other.instance_of? Subject
			return @name.eql? other.name
		else
			return false
		end
	end

	def eql?(other)
		return self == other
	end

	def hash
		"Subject : #{@name}".hash
	end
end
