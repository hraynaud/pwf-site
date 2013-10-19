class InstructorsController < InheritedResources::Base
	def new
      new!{
      	@instructor.build_user
      }
	end
end

