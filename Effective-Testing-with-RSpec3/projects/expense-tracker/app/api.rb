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
			# status 404 - checks that the 2nd spec will catch an error code
			expense = JSON.parse(request.body.read)
			result = @ledger.record(expense)

			if result.success? # sinatra defaults to status 200 unless an error is thrown
				JSON.generate('expense_id' => result.expense_id)
			else
				status 422
				JSON.generate('error' => result.error_message)
			end
		end

		# route that handles fetching expenses by date
		get '/expenses/:date' do
			JSON.generate([])
		end

	end

end

# calling the class
# app = API.new(ledger: Ledger.new)