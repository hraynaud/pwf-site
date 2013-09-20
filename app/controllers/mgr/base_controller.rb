class Mgr::BaseController < InheritedResources::Base
  before_filter :require_mgr_user
end

