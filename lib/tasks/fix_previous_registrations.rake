require 'active_record'
require 'pry' if Rails.env.development?
namespace :db do
  namespace :reg_data do

    desc "Fix student registrations" 
    task :fix_registrations => [:environment] do

      StudentRegistration.inactive.each do |old_reg|
        temp_reg =TempRegistration.where(:school => old_reg.school, :grade => old_reg.grade, :size_cd => old_reg.size_cd).first
        temp_student = temp_reg.temp_student
        stud = Student.where(:first_name => temp_student.first_name, :last_name => temp_student.last_name, :gender => temp_student.gender[0] ).first
        if stud
          if temp_student.temp_parent.name == stud.parent.name
            old_reg.student_id  = stud.id
            old_reg.save
          end
        else
          binding.pry
        end

      end
    end
  end
end



