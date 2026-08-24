FactoryBot.define do
  factory :membership do
    role { "member" }
    user
    team
  end
end
