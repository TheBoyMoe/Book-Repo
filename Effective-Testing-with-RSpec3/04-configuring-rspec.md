## Configuring RSpec

There are two basic ways:

1. `RSpec.config` block 
	- provides access to all configuration options
	- typically put `RSpec.config` block in the `spec/spec_helper.rb` file, which is loaded automatically by adding `require 'spec_helper'` to your `.spec` file.


2. command-line
	- you have access to some configuration options. 
	- affects the specific spec being run.
	- you can set command line defaults in the `.rspec` file. These are global.
	- you can define 'local' options for the project in `.rspec-local` file, also found in the '/spec' folder and override those options set in the `.rspec` file.
	- list available options with `-help`
		--only-failures - run the examples that failed last time
		--next-failure
		--tag [tag_name] - run only the examples tagged with the specific metadata tag
		--format [type]- set the format, e.g documentation/html/json
		--out - write to an output file, instread of $stdout
		--backtrace - see the entire stack trace
		--fail-fast - stop at the first failure