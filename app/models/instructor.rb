class Instructor < ActiveRecord::Base
	include UserBehavior
	mixin_user
	attr_accessible :name
	has_one :group
end
