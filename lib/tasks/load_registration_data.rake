# Provide tasks to load and delete sample user data.
require 'active_record'
require 'csv'
require 'pry'
namespace :db do
  DATA_DIRECTORY = "#{Rails.root}/lib/tasks/data"
  namespace :reg_data do

    desc "loaded student and parents" 
    task :load_all=>[:environment,:load_parents,:load_students] do
    end

    desc "Activates users loaded through load task"
    task :load_parents=>[:environment] do

      #First load and setup parent data
      #ActiveRecord::Base.transaction do
      Season.create(:fall_registration_open => "2011-06-25", :beg_date => "2011-09-22", :end_date => "2012-06-08")

      file = File.join(DATA_DIRECTORY,'parents_2011-2012.csv')
      CSV.foreach(file, {:headers => true, :return_headers => false}) do |row|
        temp_parent = TempParent.new
        temp_parent.email = row[0]
        temp_parent.pwf_parent_id =row[1]
        temp_parent.encrypted_password =row[2]
        temp_parent.salt=row[3]
        temp_parent.first_name=row[4]
        temp_parent.last_name=row[5]
        temp_parent.address1=row[6]
        temp_parent.address2=row[7]
        temp_parent.city=row[8]
        temp_parent.state=row[9]
        temp_parent.zip=row[10]
        temp_parent.primary_phone=row[11]

        temp_parent.save
      end
    end



    #desc "Activates students" 
    task :load_students=>[:environment] do

      #Load Student Data
      file = File.join(DATA_DIRECTORY,'students_2011-2012.csv')
      CSV.foreach(file, {:headers => true, :return_headers => false}) do |row|
        temp_student = TempStudent.new
        temp_student.pwf_parent_id=row[0]
        temp_student.first_name=row[1]
        temp_student.last_name=row[2]
        temp_student.gender=row[3]
        temp_student.dob=row[4]
        temp_parent = TempParent.find_by_pwf_parent_id(row[0])
        if temp_parent.nil?
          puts "Student #{row[1]} #{row[0]} with invalid pwf_parent_id #{row[0]}"
        else
          temp_student.temp_parent_id=temp_parent.id
        end
        temp_student.save

        reg = TempRegistration.new()
        reg.temp_student_id=temp_student.id
        reg.season_id=4
        reg.grade=row[5]
        reg.school=row[6]
        reg.size_cd=row[7]

        reg.save
      end
    end


    desc "Migrate Data"
    task :copy => :environment do |t|
      TempParent.all.each do |temp_parent|
        parent = Parent.new
        parent.email = temp_parent.email
        parent.encrypted_password = temp_parent.encrypted_password
        parent.first_name = temp_parent.first_name
        parent.last_name = temp_parent.last_name
        parent.address1 = temp_parent.address1
        parent.address2 = temp_parent.address2
        parent.city = temp_parent.city
        parent.state = temp_parent.state
        parent.zip = temp_parent.zip
        parent.primary_phone = temp_parent.primary_phone
        parent.save
        temp_parent.temp_students.each do |temp_student|
          parent.students.build do |student|
            student.first_name = temp_student.first_name
            student.last_name = temp_student.last_name
            student.dob = temp_student.dob
            student.gender = temp_student.gender[0]
            student.student_registrations.build do |reg|
              student.save
              temp_reg = temp_student.temp_registration
              reg.season_id = temp_reg.season_id
              reg.grade =  temp_reg.grade
              reg.school = temp_reg.school
              reg.size_cd = temp_reg.size_cd
              reg.save
            end #reg
          end # student
        end # parent
      end #temp_parent
    end #task

    desc "Remove sample data"
    task :destroy => :environment do |t|
      TempRegistration.destroy_all
      TempParent.destroy_all
      TempStudent.destroy_all
    end
  end
end
