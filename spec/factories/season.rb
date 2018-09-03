FactoryBot.define do

  factory :season  do |f|
    fall_registration_open '2013-06-01'
    spring_registration_open '2013-12-01'
    beg_date '2013-09-22'
    end_date '2014-06-06'
    fencing_fee 50.00
    aep_fee 25.00
    current true
    status "Open"
    enrollment_limit 100
    open_enrollment_date 2.days.ago.to_date

    factory :prev_season do
      fall_registration_open '2012-06-22'
      spring_registration_open '2012-12-22'
      beg_date '2012-09-22'
      end_date '2013-06-06'
      status "Closed"
      current false
    end
  end
end
