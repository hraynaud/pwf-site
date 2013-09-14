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
end
