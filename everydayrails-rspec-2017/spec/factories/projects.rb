FactoryBot.define do

  factory :project do
		# default attributes
    sequence(:name){|i| "Project #{i}"}
		description "Sample project ......."
		due_on 1.week.from_now
		association :owner

		# instances of project, with different names
		# use factory inheritance to only change those attributes that are unique
		factory :project_due_yesterday do
			due_on 1.day.ago
		end

		factory :project_due_today do
			due_on Date.current.in_time_zone
		end

		factory :project_due_tomorrow do
			due_on 1.day.from_now
		end
	end

	trait :invalid_attributes do
		name nil
	end

	# wrap callback(perform additional actions on a factory-generated object) in a 'trait'
	# add a list of 5 notes to the project after its creation
	trait :with_notes do
		after(:create){|project| create_list(:note, 5, project: project)}
	end

	# define multiple factories each with different names, representing the same class
	# factory :project_due_yesterday, class: Project do
	# 	sequence(:name){|i| "Test project #{i}"}
	# 	description "Sample project - due yesterday"
	# 	due_on 1.day.ago
	# 	association :owner
	# end
	#
	# factory :project_due_today, class: Project do
	# 	sequence(:name){|i| "Test project #{i}"}
	# 	description "Sample project - due today"
	# 	due_on Date.current.in_time_zone
	# 	association :owner
	# end
	#
	# factory :project_due_tomorrow, class: Project do
	# 	sequence(:name){|i| "Test project #{i}"}
	# 	description "Sample project - due tomorrow"
	# 	due_on 1.day.from_now
	# 	association :owner
	# end

end
