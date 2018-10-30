FactoryBot.define do
  factory :demographic do
    season_id {Season.current.id}
    income_range_cd { 2 }
    education_level_cd { 1 }
    home_ownership_cd { 1 }
    num_minors { 1 }
    num_adults { 2 }
    association :parent

    factory :no_season_demographics do
      season_id {Season.previous_season_id}
    end

    factory :invalid_demographics do
      num_minors { nil }
    end
  end
end
