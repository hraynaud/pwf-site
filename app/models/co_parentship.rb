class CoParentship < ApplicationRecord
  belongs_to :co_parent
  belongs_to :student
end
