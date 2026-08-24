FactoryBot.define do
  factory :team do
    name { Faker::Team.name }
    description { Faker::Lorem.sentence }
  end
end
