require 'active_record'
require 'pry' if Rails.env.development?
namespace :db do
  desc "Map Parents to Users"
  task :remap_models_to_parent => [:environment] do
    User.all.each do |user|
      user.update_attribute(:is_parent, true)
      p = Parent.new
      p.update_attribute(:user_id, user.id)
      user.profileable = p
      user.save
      Demographic.where(:parent_id => user.id).map{|d|d.update_attribute(:parent_id,  p.id)}
      Student.where(:parent_id => user.id).map{|d|d.update_attribute(:parent_id,  p.id)}
      Payment.where(:parent_id => user.id).map{|d|d.update_attribute(:parent_id,  p.id)}
    end
  end

end

