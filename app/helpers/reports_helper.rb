module ReportsHelper 


	def assignments_for_select assignments
		assignments.map{|a| [a.student_name, a.id]}
	end

	def mgr_assignments_for_select assignments
		assignments.map{|a| [a.name, a.id]}
	end
end
