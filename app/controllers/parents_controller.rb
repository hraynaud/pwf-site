class ParentsController < InheritedResources::Base
  def show
  end

  def edit
    @parent = Parent.find(params[:id])
    if @parent.demographics.nil?
      @parent.build_demographics
    end
    edit!
  end

  def update
    update!{
      if @parent.valid?
        if @parent.students.count == 0
          redirect_to new_student_registration_path
        else
          respond_with @parent
        end
        return
      end
    }
  end
end

