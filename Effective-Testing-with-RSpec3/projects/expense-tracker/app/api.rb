require 'sinatra/base'
require 'json'

module ExpenseTracker

	class API < Sinatra::Base

		# add route that handles 'expense' requests
		post '/expenses' do
			JSON.generate('expense_id' => 10)
		end

	end
end