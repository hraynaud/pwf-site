class Mgr::MarkingPeriodsController < Mgr::BaseController
  def create
    create!{ |variable|  collection_path}
  end

 def marking_period_params
   params.require(:marking_period).permit(:name, :notes)
 end

end
