module NotificationService

  class ReportCard
    class << self
      def missing 
        StudentRegistration.missing_first_session_report_cards.limit(2).each do |student|
          ReportCardMailer.missing(student).deliver
        end
      end
    end
  end

end
