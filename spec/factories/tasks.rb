FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    project { nil }
    user { nil }
    status { "MyString" }
    priority { 1 }
    due_date { "2026-08-22" }
  end
end
