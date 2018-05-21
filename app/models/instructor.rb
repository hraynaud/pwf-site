class Instructor < ActiveRecord::Base
  include UserBehavior
  mixin_user
  has_one :group
end
