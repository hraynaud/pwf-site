class Mgr::GradeFormatsController < Mgr::BaseController

  def update 
    update!{
      collection_path
    }
  end

end
