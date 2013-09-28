class Mgr::AepRegistrationsController < Mgr::BaseController

  def show
    show!{
      @workshops = @aep_registration.workshops
    }
  end

end
