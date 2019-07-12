FactoryBot.define do

  factory :season  do |f|
    fall_registration_open { "#{Date.today.year}-06-01" }
    waitlist_registration_date {"#{Date.today.year}-06-08"}
    open_enrollment_date {"#{Date.today.year}-06-15" }
    
    spring_registration_open { "#{Date.today.year}-12-01" }
    beg_date {  "#{Date.today.year}-09-22" }
    end_date { "#{Date.today.year+1}-06-06" }
    fencing_fee { 50.00 }
    aep_fee { 25.00 }
    current { true }
    status { "Open" }
    enrollment_limit { 100 }

    factory :prev_season do
      fall_registration_open { "#{Date.today.year-1}-06-22" }
      spring_registration_open { "#{Date.today.year-1}-12-22" }
      beg_date { "#{Date.today.year-1}-09-22" }
      end_date { "#{Date.today.year}-06-06" }
      status { "Closed" }
      current { false }
    end
  end
end
