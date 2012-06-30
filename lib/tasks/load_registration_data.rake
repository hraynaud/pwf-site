# Provide tasks to load and delete sample user data.
require 'active_record'
require 'csv'

namespace :db do
  DATA_DIRECTORY = "#{RAILS_ROOT}/lib/tasks/data"
  namespace :reg_data do

    desc "loaded student and parents" 
    task :load_all=>[:environment,:load_parents,:load_students] do
    end

    desc "Activates users loaded through load task"
    task :load_parents=>[:environment] do

      #First load and setup parent data
      #ActiveRecord::Base.transaction do

      reader =CSV.open(File.join(DATA_DIRECTORY,'parents_2011-2012.csv'), 'r', ?,, ?\r)  #was 'rb'
      reader.shift #get rid of header row

      reader.each do |row|
        temp_parent = TempParent.new
        temp_parent.email = row[0]
        temp_parent.temp_parent_id =row[1]
        temp_parent.crypted_password =row[2]
        temp_parent.salt=row[3]
        temp_parent.first_name=row[4]
        temp_parent.last_name=row[5]
        temp_parent.address1=row[6]
        temp_parent.address2=row[7]
        temp_parent.city=row[8]
        temp_parent.state=row[9]
        temp_parent.zip=row[10]
        temp_parent.phone1=row[11]
        temp_parent.save(false)
      end
    end



    #desc "Activates students" 
    task :load_students=>[:environment] do

      #Load Student Data
      reader =CSV.open(File.join(DATA_DIRECTORY,'students_2011-2012.csv'), 'r', ?,, ?\r)
      reader.shift #get rid of header row
      reader.each do |row|

        temp_student = TempStudent.new
        temp_student.parent_id=row[0]
        temp_student.first_name=row[1]
        temp_student.last_name=row[2]
        temp_student.gender=row[3]
        temp_student.birthdate=row[4]
        temp_student.save(false)

        reg = StudentRegistration.new()
        reg.temp_student_id=temp_student.id
        reg.season_id=OLD_SEASON
        reg.grade=row[5]
        reg.school=row[6]
        reg.size=row[7]
        reg.save(true)
      end
    end

    desc "Remove sample data"
    task :delete => :environment do |t|
      Registration.delete_all
      Spec.delete_all
      User.delete_all
      Student.delete_all
      ContactDetail.delete_all
      Permission.delete_all
    end
  end
end
