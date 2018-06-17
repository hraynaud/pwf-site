class DashboardsController < ApplicationController

  def show
    self.instance_variable_set("@#{user_type}", current_user)
    render "#{user_type}"
  end

  def user_type
    @type ||= current_user.class.name.downcase
  end

end
