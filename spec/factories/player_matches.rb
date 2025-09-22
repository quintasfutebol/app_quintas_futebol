FactoryBot.define do
  factory :player_match do
    match { nil }
    player { nil }
    team { nil }
    goals_scored { 1 }
    is_goalkeeper { false }
  end
end
