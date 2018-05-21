class Mgr::GradeConvertersController < InheritedResources::Base


 def create
   create!{
    collection_path
   }
 end 
 def update
   update!{
    collection_path
   }
 end

 def grade_converter_params
   params.require(:grade_converter).permit(:custom, :letter, :max, :min, :scale, :strategy)
 end

end
