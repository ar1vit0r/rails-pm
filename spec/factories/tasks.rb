FactoryBot.define do
  factory :task do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    status { "todo" }
    priority { "medium" }
    project
    user
  end
end
