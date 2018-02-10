require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

	before {
		@user = FactoryBot.create(:user)
	}

	describe '#index' do

		context 'as an authenticated user' do

			before {
				# simulate user login, access '#index' as an authenticated user
				sign_in @user
				get :index
			}

			it 'responds successfully' do
				expect(response).to be_success
			end

			it 'returns a 200 response' do
				expect(response).to have_http_status 200
			end
		end

		context 'as a guest' do
			before {
				get :index
			}
			it 'returns a 302 response' do
				expect(response).to have_http_status 302
			end

			it 'redirects the user to the sign-in page' do
				expect(response).to redirect_to	'/users/sign_in'
			end
		end
	end
end
