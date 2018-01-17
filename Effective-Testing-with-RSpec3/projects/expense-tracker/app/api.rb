require 'sinatra/base'
require 'json'

module ExpenseTracker

	class API < Sinatra::Base

		# route that handles submitting 'expense'
		post '/expenses' do
			JSON.generate('expense_id' => 10)
		end

		# route that handles fetching expenses by date
		get '/expenses/:date' do
			JSON.generate([])
		end

	end
end