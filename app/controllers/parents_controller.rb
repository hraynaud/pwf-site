class ParentsController < InheritedResources::Base
  def show
    @parent = current_parent
  end

  def edit
    @parent = Parent.find(params[:id])
    if @parent.current_household_profile.nil?
      @parent.demographics.build
    else
      #TODO check for current_demographics
    end
    # @parent.all_valid?
  end

  def update
    binding.pry
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

