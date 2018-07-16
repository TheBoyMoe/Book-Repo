require 'rails_helper'

RSpec.describe HomeController, type: :controller do

	# ensure the controller#index responds to a browser request
	describe '#index' do
		it 'responds successfully' do
			get :index
			expect(response).to be_success
		end
	end

	# add route, action, view
	describe '#new' do
		it 'responds successfully' do
			get :new
			expect(response.status).to eq 200
		end
	end

end
