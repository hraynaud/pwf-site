class Mgr::AepRegistrationsController < Mgr::BaseController
  before_filter :for_season, :only=>[:index, :new, :create]

  def index
    @aep_registrations = AepRegistration.where(season_id: @season.id)
  end

  def show
    show!{
      @workshops = @aep_registration.workshops
    }
  end

  def edit
    edit!{
      @student_registrations =[@aep_registration.student_registration]
    }
  end

  def create
    create!  do |success, failure|
      failure.html {
        @student_registrations = StudentRegistration.where(:season_id => @season.id).enrolled 
        render :new
      }
    end
  end

  def new
    new!{
      @student_registrations = StudentRegistration.where(:season_id => @season.id).enrolled
    }
  end


end
