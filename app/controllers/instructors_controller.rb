class InstructorsController < InheritedResources::Base
	def new
      new!{
      	@instructor.build_user
      }
	end

 def instructor_params
   
   params.require(:instructor).permit(:name)
 end
end

