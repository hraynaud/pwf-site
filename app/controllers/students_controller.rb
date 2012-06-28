class StudentsController < InheritedResources::Base
  def new
    new!{
      @student.student_registrations.build
    }
  end
  def create
    create!{
      @student.student_registrations.last.season = current_season
      @student.save

      if @student.valid?
        redirect_to parent_path(current_parent)
        return
      end
    }
  end

  def begin_of_association_chain
    @current_parent = current_parent
  end

end
