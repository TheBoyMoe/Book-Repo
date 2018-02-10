FactoryBot.define do

  factory :project do
    sequence(:name){|i| "Project #{i}"}
		description "Dummy description ......."
		due_on 1.week.from_now
		association :owner
	end

	# define multiple factories each with different names, representing the same class
	factory :project_due_yesterday, class: Project do
		sequence(:name){|i| "Test project #{i}"}
		description "Sample project - due yesterday"
		due_on 1.day.ago
		association :owner
	end

	factory :project_due_today, class: Project do
		sequence(:name){|i| "Test project #{i}"}
		description "Sample project - due today"
		due_on Date.current.in_time_zone
		association :owner
	end

	factory :project_due_tomorrow, class: Project do
		sequence(:name){|i| "Test project #{i}"}
		description "Sample project - due tomorrow"
		due_on 1.day.from_now
		association :owner
	end

end
