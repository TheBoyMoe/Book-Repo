require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
	# Our API class should be able to return 'success'? state, an 'expense_id' and any 'error_message'
	RecordedResult = Struct.new(:success?, :expense_id, :error_message)

	RSpec.describe API do
		include Rack::Test::Methods

		# we'll create a test double to stand in for the ledger using RSpec's 'instance_double' class
		# note: the class does not have to exist
		let(:ledger) {instance_double('ExpenseTracker::Ledger')}

		def app
			API.new(ledger: ledger)
		end


		describe "POST/expenses" do

			# tst the happy path
			context "when the expense is successfully recorded" do
				# move the 'setup' code into 'before' hook makes it clear it's not part of the
				# code you're testing - you can still add additional setup to individual specs
				let(:expense){{'some' => 'data'}}

				before {
					# the ledger test double returns a canned result - RecordResult
					allow(ledger).to receive(:record).with(expense).and_return(RecordedResult.new(true, 417, nil))
				}

				it "returns the expense id" do
					post '/expenses', JSON.generate(expense)
					parsed = JSON.parse(last_response.body)
					expect(parsed).to include('expense_id' => 417)
				end

				# sinatra returns a 200(OK) status code unless an error occurs or you explicitly set one
				it "responds with a 200(OK)" do
					post '/expenses', JSON.generate(expense)
					expect(last_response.status).to eq(200)
				end
			end

			# test the sad path
			context 'when the expense fails validation' do
				let(:expense){{'some' => 'data'}}

				before {
					allow(ledger).to receive(:record).with(expense).and_return(RecordedResult.new(false, 417, 'Expense incomplete'))
				}

				# check for an error message
				it 'returns an error message' do
					post '/expenses', JSON.generate(expense)
					parsed = JSON.parse(last_response.body)
					expect(parsed).to include('error' => 'Expense incomplete')
				end

				# check for an error code
				it 'responds with a 422(Unprocessable entity)' do
					post '/expenses', JSON.generate(expense)
					expect(last_response.status).to eq 422
				end
			end

		end
	end


end