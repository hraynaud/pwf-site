class Manager < ActiveRecord::Base
  include UserBehavior
  mixin_user
end
