class TempParent < ApplicationRecord
has_many :temp_students

def name
 "#{first_name} #{last_name}"
end

end

