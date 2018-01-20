require_relative '../../../app/ledger'
require_relative '../../../config/sequel'
require_relative '../../support/db'

module ExpenseTracker

	# :aggragate_failures - continue testing even after a failure
	# all examples within the group inherit any metadata properties passed to the group
	RSpec.describe Ledger, :aggregate_failures do

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

	end
end