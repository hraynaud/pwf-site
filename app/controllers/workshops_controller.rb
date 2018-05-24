class WorkshopsController < InheritedResources::Base
  def workshop_params
    params.require(:workshop).permit(:name, :notes, :tutor_id)
  end
end
