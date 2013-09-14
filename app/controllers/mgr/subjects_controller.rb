class Mgr::SubjectsController < Mgr::BaseController

  def create
    create!{mgr_subjects_path}
  end
end
