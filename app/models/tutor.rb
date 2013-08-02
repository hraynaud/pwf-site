class Tutor < ActiveRecord::Base
  include UserBehavior
  mixin_user
end
