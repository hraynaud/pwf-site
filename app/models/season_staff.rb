class SeasonStaff < ApplicationRecord
  belongs_to :staff
  belongs_to :season
end
