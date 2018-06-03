class Mgr::ParentsController < Mgr::BaseController
  def index
    @parents = Parent.with_current_registrations.confirmed
  end
end
