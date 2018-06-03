class Mgr::BaseController < InheritedResources::Base
  before_action :require_mgr_user
end

