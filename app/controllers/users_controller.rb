class UsersController < InheritedResources::Base
  def show
    @user = current_user
  end

  def edit
    @user = user.find(params[:id])
    if @user.current_household_profile.nil?
      @user.demographics.build
    else
      #TODO check for current_demographics
    end
    # @user.all_valid?
  end

  def update
    update!{
      if @user.all_valid?
        if @user.students.count == 0
          redirect_to new_student_path
        else
          respond_with @user
        end
        return
      end
    }
  end
end

