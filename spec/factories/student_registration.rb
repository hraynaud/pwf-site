FactoryBot.define do
  factory :student_registration  do |f|
    association :student, :factory => :student
    school "Hard Knocks"
    grade 5
    size_cd 2
    season_id  {Season.current.id }

    factory :paid_registration do

    school "Paid Dues"
      after(:create) do |reg|
         reg.confirmed_paid!
         reg.save
      end
    end

    factory :old_registration do
      season_id {Season.where(:current =>false).first.id}
    end
  end
end
