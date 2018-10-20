class Instructor < ApplicationRecord
  include UserBehavior
  mixin_user
  has_one :group
end
