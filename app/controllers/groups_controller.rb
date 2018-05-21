class GroupsController < InheritedResources::Base


  def groups_params
    params.require(:group).permit(:name, :instructor_id)
  end
end
