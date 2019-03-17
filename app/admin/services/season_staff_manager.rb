class SeasonStaffManager

  def initialize season, updated_staff_ids
    @season = season
    @staff_ids = updated_staff_ids.map(&:to_i)
  end

   def update
     current_ids = @season.season_staffs.map(&:staff_id)
     deleted_staff_ids = current_ids - @staff_ids 
     new_staff_ids = @staff_ids - current_ids

     @season.season_staffs.where(staff_id: deleted_staff_ids).map(&:destroy)
     new_staff_ids.each do |id|
       @season.season_staffs.create(staff_id: id)
     end
   end

end
