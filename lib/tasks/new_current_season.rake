require 'active_record'
require 'pry' if Rails.env.development?
namespace :db do
  desc "Creates new current Season"
  task :new_current_season,  [:fall_reg_open,:open_enrollment,:beg_date,:end_date] => :environment do |task, args|
    old_cur = Season.current
    if old_cur
      old_cur.current = false;
      old_cur.save
    end
    Season.create(:fall_registration_open => args.fall_reg_open, 
                  :open_enrollment_date => args.open_enrollment,
                  :beg_date => args.beg_date, 
                  :end_date => args.end_date, 
                  :current => true)
  end
end
