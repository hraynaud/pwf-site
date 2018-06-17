class TempStudent < ApplicationRecord
  belongs_to :temp_parent
  has_one :temp_registration
end

