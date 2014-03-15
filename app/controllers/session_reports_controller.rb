class SessionReportsController < TutorReportsController
  def index
     @session_reports = SessionReport.all
  end
end
