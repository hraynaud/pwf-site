class Mgr::TutorsController < Mgr::BaseController
  
  def new
    new!{@tutor.build_user}
  end


  def create
    params[:tutor][:user_attributes][:password]=ENV['DEFAULT_TUTOR_PASSWORD']
    params[:tutor][:user_attributes][:password_confirmation]=ENV['DEFAULT_TUTOR_PASSWORD']
    params[:tutor][:user_attributes][:is_tutor]=true
    @tutor = Tutor.create(params[:tutor])
    if @tutor.valid?
      redirect_to dashboard_path(current_user), :notice => "Tutor successfully created"
    else
      render :edit
    end
  end
end
