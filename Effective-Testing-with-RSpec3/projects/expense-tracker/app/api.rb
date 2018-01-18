require 'sinatra/base'
require 'json'

module ExpenseTracker

	class API < Sinatra::Base

		# explicit dependency - documented in the method signature
		# def initialize(ledger:)
		# 	@ledger = ledger
		# 	super()
		# end

		# we can also use a default value so the caller does not have to pass in a ledger
		def initialize(ledger: Ledger.new)
			@ledger = ledger
			super()
		end


		# route that handles submitting 'expense'
		# parse the expense from the request body
		# record it to the Ledger(either fake-it(for testing) or to a real database)
		# return JSON obj containing the expense_id
		post '/expenses' do
			expense = JSON.parse(request.body.read)
			result = @ledger.record(expense)
			JSON.generate('expense_id' => result.expense_id)
		end

		# route that handles fetching expenses by date
		get '/expenses/:date' do
			JSON.generate([])
		end

	end

end

# calling the class
# app = API.new(ledger: Ledger.new)