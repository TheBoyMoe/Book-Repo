require_relative '../../../app/ledger'
require_relative '../../../config/sequel'



=begin

	Run you specs in random order by adding `config.order = :random` to spec_helper
	in order to uncover 'order dependencies' - specs whose behaviour depends on which
	spec is run first - the first state leaves some state behind.

	Because integration tests will often interact with external services, e.g
	databse, file system, networks, which are shared, we have to take care to
	restore those services to a clean state between runs.

	If these tests are run in random order, the results will vary, sometimes
	one failure, sometimes two.

	In order to debug pass a 'random seed' sp as to give you a repeatable test order -
		- run the test in random order, causing the failure, make a note of the randomised
			seed and then repeat the test with the `--seed` option, e.g.

		$ bundle exec rspec spec/model_spec.rb --seed 32043

		to repeat the failing tests in the same order

		By using the `--bisect` option, e.g.

		$ bundle exec rspec spec/model_spec.rb --bisect --seed 32043

		With the --bisect option, RSpec will systematically run different portions of your
		suite until it finds the smallest set that triggers a failure, RSpec will give
		us a minimal set of specs we can run any time to see the failure

		This particular issue is due to the database not being cleared between runs.
		To solve it, we’ll wrap each spec in a database transaction, after each run
		RSpec will roll back the transaction, cancelling any writes and leaving
		a clean database. RSpec provides the `around` hook
			 - add the code to the spec/support/db.rb file

		We also need to load the support/db.rb file and add the `:db` tag to the example group, e.g.

		require_relative '../support/db'

		describe '.........', :db do
			# .....
		end

		Alternatively, RSpec will automatically load the support file for any examples
		that have the `:db` tag if we add the following to the `spec_helper` file

		RSpec.configure ​do​ |config|
			config.when_first_matching_example_defined(​:db​) ​do
				require_relative ​'support/db'
     ​ end
		end​


=end

module ExpenseTracker

	# :aggragate_failures - continue testing even after a failure
	# all examples within the group inherit any metadata properties passed to the group
	RSpec.describe Ledger, :aggregate_failures, :db do

		let(:ledger) {Ledger.new}
		let(:expense) {{'payee' => 'Starbucks',	'amount' => 5.75,	'date' => '2017-06-10'}}

		# we want to save the data to the ledger, then read
		# it back to mack sure it actually got saved
		describe "#record" do

			# test the 'happy path'
			context 'with a valid expense' do
				it 'successfully saves the expense in the DB' do
					# save the expense to the database
					result = ledger.record(expense)

					expect(result).to be_success # checks that result.success? is true (RSpec matcher)
					# expects the app to return an array with a hash matching the one provided from the database
					expect(DB[:expenses].all).to match [a_hash_including(
						 id: result.expense_id,
						 payee: 'Starbucks',
						 amount: 5.75,
						 date: Date.iso8601('2017-06-10')
				  )]
				end
			end

			# test the 'sad path'
			context "with an invalid expense" do
				it 'rejects the expense as invalid' do
					# attempt to save a record without a 'payee' property
					expense.delete('payee')
					result = ledger.record(expense)

					# expect the ledger instance to return a failure status and no record should have been inserted
					expect(result).not_to be_success
					expect(result.expense_id).to eq(nil)
					expect(DB[:expenses].count).to eq(0)
				end
			end

		end


		describe '#expenses_on' do
			it 'returns all expenses for the provided date' do
				result_1 = ledger.record(expense.merge('date' => '2017-06-10'))
				result_2 = ledger.record(expense.merge('date' => '2017-06-10'))
				result_3 = ledger.record(expense.merge('date' => '2017-06-11'))

				expect(ledger.expenses_on('2017-06-10')).to contain_exactly(
					 a_hash_including(id: result_1.expense_id),
					 a_hash_including(id: result_2.expense_id)
				)
			end

			it 'returns a blank array when there are no matching expenses' do
				expect(ledger.expenses_on('2017-06-10')).to eq []
			end
		end

	end
end