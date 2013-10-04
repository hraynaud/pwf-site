module ReportsHelper 


	def assignments_for_select assignments 
		assignments.map{|a| [a.student_name, a.id]}
	end

end