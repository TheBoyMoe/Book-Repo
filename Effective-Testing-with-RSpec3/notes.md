## Running RSpec command

```bash
$ rspec /spec # run all tests in spec folder

$ rspec /spec/users /spec/posts # run tests in /users and /posts folders

$ rspec /spec/views/index_spec.rb /rspec/views/show_spec.rb # test 2 or more individual files

$ rspec /spec/views /spec/controllers/posts_controller.rb # mix and match files & folders

$ rspec --example milk # runs every test with the word 'milk' in the description (use --example or -e)
    e.g. 'A cup of coffee with milk costs $1.25' - rspec searches the full description

$ rspec /spec/posts_controller.rb:25 # run specific example/group

$ rpsec --only-failures # runs only tests that failed last run
  #=> run `rspec` first to record all failing tests
  #=> run `rspec --only-failures` on subsequent runs
  #=> requires that the `config.example_status_persistence_file_path` option is set in `spec_helper`
  #=> rspec requires txt file in which it saves info about failing tests.

$ rspec --next-failure # runs the next failing test
  #=> run `rspec` first to record all failures
  #=> run `rspec --next-failure` to display the next failing test.
  #=> requires that the `config.example_status_persistence_file_path` option is set in `spec_helper`

$ rspec --fail-fast
  #=> runs all tests, stopping at the first failing test
```


NOTES:

  * use 'context' when modifying the object being tested

  * to run a 'focused' example/group, add 'f' to 'it/describe/context' -> 'fit/fdescribe/fcontext'
     => only the example/group is run

  * to mark an example/group as pending and skip execuption, add 'x' to 'it/describe/context' -> 'xit/xdescribe/xcontext'

  * you can also add the word 'pending' or 'skip' anywhere inside the method body (any code before 'pending' will still run)
    * add a description, e.g `pending 'test not yet implemented'`, `skip 'Test not yet implemented'`

  * any test with a description, but no body is marked as pending

  * tests marked with the `pending` keyword are expected to fail and are still run - appear in yellow

  * passing tests which are marked `pending` will FAIL - and appear in red.

  * any test/group marked with `x` or `skip` are NOT run - marked as pending and appear in yellow
