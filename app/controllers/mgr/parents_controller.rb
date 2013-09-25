class Mgr::ParentsController < Mgr::BaseController
  def index
    @parents = Parent.with_current_registrations.enrolled
  end
end
