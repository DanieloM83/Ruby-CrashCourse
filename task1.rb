require 'time'

class Student
	attr_accessor :name, :surname, :birth_date

	def initialize(name, surname, birth_date)
		if birth_date.utc > Time.now.utc
			raise ArgumentError, "Birth date cannot be in the future!"
		end
	
		@name = name
		@surname = surname
		@birth_date = birth_date.utc
	end

	def calculate_age(at_date = Time.now)
		age = (at_date - @birth_date.utc) / (60 * 60 * 24 * 365.25)
		age.to_i
	end
	
	def ==(other)
		return false unless other.is_a?(Student)
		@name == other.name && @surname == other.surname && @birth_date == other.birth_date
	end

	def inspect
		"<Student: #{@name} #{@surname} - #{@birth_date}>"
	end

	def to_s
		inspect
	end
end


class Group
	attr_accessor :students

	def initialize(*students)
		@students = []
		students.each { |student| add_student(student) }
	end

	def add_student(student)
		unless @students.include?(student)
			@students.append(student)
			return true
		end
		false
	end

	def remove_student(student)
		if @students.include?(student)
			@students.delete(student)
			return true
		end
		false
	end

	def get_students_by_age(age)
		@students.select { |student| student.calculate_age == age }
	end

	def get_students_by_name(name)
		@students.select { |student| student.name == name }
	end

	def inspect
		details = @students.map { |student| "   - #{student.name} #{student.surname} - #{student.birth_date}" }
		"<Group: #{@students.length} students>\n" + details.join("\n")
	end

	def to_s
		inspect
	end
end


begin
	student1 = Student.new("John", "Smith", Time.new(2006, 5, 15))
	puts student1
	student2 = Student.new("Alice", "Johnson", Time.new(2007, 1, 1))
	puts student2
	student3 = Student.new("John", "Smith", Time.new(2006, 5, 15))
	puts student3
	puts "","Trying to create student with birthdate in future..."
	student4 = Student.new("Bob", "Marley", Time.new(2025, 1, 1))
rescue ArgumentError => error
	puts error.message,""
ensure
	group1 = Group.new(student1, student2)
	puts group1
	puts "","Trying to add student with the same data..."
	puts group1.add_student(student3),""
	puts group1
	puts "","Removing John Smith from the class..."
	puts group1.remove_student(student1),""
	puts group1,""
	puts group1.get_students_by_age(student2.calculate_age)
	group1.add_student(student3)
	puts group1.get_students_by_name("John")
end
