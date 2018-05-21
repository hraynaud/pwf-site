class Mgr::GradeFormatsController < Mgr::BaseController

  def update 
    update!{
      collection_path
    }
  end

 def grade_formats_params

   params.require(:grade_format).permit(:grade_type, :name, :strategy, :grade_converters_attributes)
 end

end
