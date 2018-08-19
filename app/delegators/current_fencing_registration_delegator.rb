class CurrentFencingRegistrationDelegator

  attr_accessor :student_registrations

  def initialize student_registrations
    @student_registrations = student_registrations
  end

  def registrations_count
    student_registrations.count
  end

  def unpaid_registrations_count
    unpaid_registrations.count
  end

  def unpaid_registrations
    student_registrations.unpaid
  end

  def confirmed_registrations
    student_registrations.confirmed
  end

  def confirmed_registrations_count
    confirmed_registrations.count
  end

  def withdrawn_registrations_count
    withdrawn_registrations.count
  end

  def withdrawn_registrations
    student_registrations.withdrawn
  end

  def has_current_unpaid_fencing_registrations?
    student_registrations.unpaid != []
  end
end
