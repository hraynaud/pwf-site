class DashboardsController < ApplicationController

  def show
    user = current_user.profileable
    type = user.class.name.downcase
    self.instance_variable_set("@#{type}", user)
    render "#{type}"
  end
end
