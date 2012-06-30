class TempStudent < ActiveRecord::Base
  belongs_to :temp_parent
  has_one :temp_registration
end

