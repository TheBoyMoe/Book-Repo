RSpec.configure do |config|
  # run only failures
  config.example_status_persistence_file_path = 'spec/examples.txt'

  # run focused example/group
  config.filter_run_when_matching(focus: true)
end
