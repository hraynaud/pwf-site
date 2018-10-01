class StudentRegistrationMailer < ActionMailer::Base
  default from: "notifications@peterwestbrook.org"

  def notify registration 
    @registration = registration
    @parent = @registration.parent
    @status_text = status_text
    mail to: "#{@parent.email}", subject: "Peter Westbrook Foundation Registration"
  end


  private

  def status_text
    @text = case @registration.status
            when StudentRegistration.statuses[:pending]
              "Please login and pay registration fee to confirm enrollment"
            when StudentRegistration.statuses[:confirmed]
              "Thank you for completing the registration process. #{@registration.student_name} is confirmed."
            when StudentRegistration.statuses[:wait_list]
              wait_list_text
            end
  end

 def wait_list_text
   <<~TEXT
    Thank you for signing up for the Peter Westbrook Foundation.
    Unfortunately we are at capacity and cannot accommodate any more students. 
    #{@registration.student_name} will be place on the wait list and we will notify should space become available.
   TEXT
 end

end
