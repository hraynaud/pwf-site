class TutorsController < ApplicationController

  def index
    @tutors = Tutor.all
  end

  def new
    @tutor = Tutor.new
    @tutor.build_user
  end

  def edit
    @tutor = Tutor.find(params[:id])
  end

  def update
    @tutor = Tutor.find(params[:id])
    @tutor.update_attributes(params[:tutor])
    if @tutor.valid?
      redirect_to dashboard_path(current_user), :notice => "Tutor successfully updated"
    else
      render :edit
    end
  end

  def create
    params[:tutor][:user_attributes][:password]=ENV['DEFAULT_TUTOR_PASSWORD']
    params[:tutor][:user_attributes][:password_confirmation]=ENV['DEFAULT_TUTOR_PASSWORD']
    @tutor = Tutor.create(params[:tutor])
    if @tutor.valid?
      redirect_to dashboard_path(current_user)
    else
      render :edit
    end
  end

  def destroy

  end

  def deactivate

  end

end
