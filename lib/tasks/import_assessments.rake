# Provide tasks to load and delete sample user data.
require 'active_record'
require 'csv'
require 'pry' if Rails.env.development?
namespace :db do
  DATA_DIRECTORY = "#{Rails.root}/lib/tasks/data"
  namespace :assessments do
    task :load => [:environment] do
      file = File.join(DATA_DIRECTORY,'assessments-2013.csv')
      CSV.foreach(file, {:headers => true, :return_headers => false}) do |row|
        stud_ass = StudentAssessment.new
        stud_ass.aep_registration_id = row[0]
        stud_ass.pre_test_id=row[1]
        stud_ass.pre_test_math_score =row[2]
        stud_ass.pre_test_reading_score =row[4]
        stud_ass.pre_test_writing_score=row[6]
        stud_ass.save
      end
    end
  end

end
