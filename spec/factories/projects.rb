FactoryBot.define do
  factory :project do
    name { "MyString" }
    description { "MyText" }
    team { nil }
    user { nil }
    status { "MyString" }
    deadline { "2026-08-22" }
  end
end
