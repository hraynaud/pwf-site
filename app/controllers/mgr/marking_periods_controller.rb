class Mgr::MarkingPeriodsController < Mgr::BaseController
	def create
		create!{ |variable|  collection_path}
    end
end
