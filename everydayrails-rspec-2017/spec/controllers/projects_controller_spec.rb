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

	describe '#show' do
		# as a logged in user, I can view my own projects
		context 'as an authorised user' do
			before {
				@user = FactoryBot.create(:user)
				@project = FactoryBot.create(:project, owner: @user)
			}

			it 'responds successfully' do
				sign_in @user
				get :show, params: {id: @project.id}

				expect(response).to be_success
			end
		end

		# as a logged in user, I cannot view other users projects
		context 'as an unauthorised user' do
			before {
				@user = FactoryBot.create(:user)
				other_user = FactoryBot.create(:user)
				@project = FactoryBot.create(:project, owner: other_user)
			}

			it 'redirects to the dashboard' do
				sign_in @user
				get :show, params: {id: @project.id}

				expect(response).to redirect_to root_path
			end
		end
	end

	describe '#create' do
		before {
			# generate a params hash of project key/value pairs
			@project_params = FactoryBot.attributes_for(:project)
		}

		context 'as an authenticated user' do
			before {
				@user = FactoryBot.create(:user)
			}

			it 'add a project' do
				sign_in @user
				expect {
					post :create, params: {project: @project_params}
				}.to change(@user.projects, :count).by(1)
			end
		end

		context 'as a guest' do
			before {
				post :create, params: {project: @project_params}
			}

			it 'returns a 302 response' do
				expect(response).to have_http_status 302
			end

			it 'redirects to the sign in page' do
				expect(response).to redirect_to '/users/sign_in'
			end
		end

	end

end
