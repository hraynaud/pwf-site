class HomeController < ApplicationController
  skip_before_filter :authenticate_parent!
  before_filter :redirect_to_profile, :only=>[:index]

  def index
  end

  private
  def redirect_to_profile
    redirect_to parent_root_path if parent_signed_in?
  end

  def index

  end
end
