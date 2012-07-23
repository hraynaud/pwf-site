class ParentsController < InheritedResources::Base
  def edit
    @parent = Parent.find(params[:id])
    if @parent.current_household_profile.nil?
      @parent.demographics.build
    else
      #TODO check for current_demographics
    end
    @parent.all_valid?
  end

  def update
    update!{
      if @parent.all_valid?
        if @parent.students.count == 0
          redirect_to new_student_path
        else
          respond_with @parent
        end
        return
      end
    }
  end
end

