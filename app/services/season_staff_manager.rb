class SeasonStaffManager
  attr_reader :season

  def initialize season
     @season = season
  end

  def update ids

    remove_deleted_ids(ids)

    ids_to_add(ids).each do |id|
      season.season_staffs.create(staff_id: id)
    end
  end

  private

  def current_ids
    @current_ids ||= season.season_staffs.map(&:staff_id)
  end

  def remove_deleted_ids ids
    season.season_staffs.where(staff_id: ids_to_delete(ids)).map(&:destroy)
  end

  def ids_to_delete ids
    current_ids - updated_ids(ids)
  end

  def ids_to_add ids
    updated_ids(ids) - current_ids
  end


  def updated_ids ids
    @ids ||= ids.delete_if { |x|
      x.blank?
    }.map(&:to_i)
  end

end
