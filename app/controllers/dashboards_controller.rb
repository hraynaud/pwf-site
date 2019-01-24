class DashboardsController < ApplicationController

  def show
    @current_registrations = current_user.student_registrations.current
  end

end
