require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
	# Our API class should be able to return 'success'? state, an 'expense_id' and any 'error_message'
	RecordedResult = Struct.new(:success?, :expense_id, :error_message)

	RSpec.describe API do
		include Rack::Test::Methods

		def app
			API.new(ledger: ledger)
		end

		# we'll create a test double to stand in for the ledger using RSpec's 'instance_double' class
		# note: the class does not have to exist
		let(:ledger) {instance_double('ExpenseTracker::Ledger')}

		describe "POST/expenses" do

			context "when the expense is successfully recorded" do
				it "returns the expense id" do
					expense = {'some' => 'data'}
					# the ledger test double returns a canned result - RecordResult
					allow(ledger).to receive(:record).with(expense).and_return(RecordedResult.new(true, 417, nil))
					post '/expenses', JSON.generate(expense)

					parsed = JSON.parse(last_response.body)
					expect(parsed).to include('expense_id' => 417)
				end

				it "responds with a 200(OK)"

			end

			context 'when the expense fails validation' do
				it 'returns an error message'

				it 'responds with a 422(Unprocessable entity)'
			end

		end
	end


end