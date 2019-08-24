FactoryBot.define do

  factory :season  do |f|
    fall_registration_open { "#{current_year}-07-01" }
    waitlist_registration_date {"#{current_year}-07-15"}
    open_enrollment_date {"#{current_year}-06-15" }

    beg_date {  "#{current_year}-09-22" }
    end_date { "#{current_year+1}-06-06" }

    fencing_fee { 50.00 }
    aep_fee { 25.00 }
    current { true }
    status { :open }
    enrollment_limit { 100 }

    factory :prev_season do
      fall_registration_open { "#{current_year-1}-06-22" }
      beg_date { "#{current_year-1}-09-22" }
      end_date { "#{current_year}-06-06" }

      status { :closed }
      current { false }
    end
  end
end
