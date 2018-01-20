# load sequel config and DB definition
require_relative '../config/sequel'

module ExpenseTracker
	RecordResult = Struct.new(:success?, :expense_id, :error_message)

	class Ledger

		def record(expense)
			unless expense.key?('payee')
				message = "Invalid expense: 'payee' required"
				return RecordResult.new(false, nil, message)
			end

			DB[:expenses].insert(expense)
			id = DB[:expenses].max(:id)
			RecordResult.new(true, id, nil)
		end

		def expenses_on(date)
			# use the sequel 'where' method to query the database
			DB[:expenses].where(date: date).all
		end

	end
end