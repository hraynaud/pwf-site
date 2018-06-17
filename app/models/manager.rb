class Manager < ApplicationRecord
  include UserBehavior
  mixin_user
end
