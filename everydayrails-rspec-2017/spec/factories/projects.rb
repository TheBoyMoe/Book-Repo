FactoryBot.define do
  factory :project do
    sequence(:name) {|i| "Project #{i}"}
		description "Dummy description ......."
		due_on 1.week.from_now
		association :owner
  end
end
