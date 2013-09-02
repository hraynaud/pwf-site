class Tutor < ActiveRecord::Base
  include UserBehavior
  mixin_user

  has_many :tutoring_assignments
end
