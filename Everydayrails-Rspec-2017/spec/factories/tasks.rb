FactoryBot.define do
  factory :task do
    sequence(:name) {|i| "Task #{i}"}
		association :project
  end
end
