class ParentsController < InheritedResources::Base
  def show
    @parent = current_user.profileable
  end

  def edit
    @parent = Parent.find(params[:id])
    @demographic = @parent.current_household_profile || @parent.demographics.build
  end

  def update
    update!{
      if @parent.valid?
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

