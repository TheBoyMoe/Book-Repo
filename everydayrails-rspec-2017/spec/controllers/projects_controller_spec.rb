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

	describe '#new' do
		context 'as an authenticated user' do
			before{
				@user = FactoryBot.create(:user)
				sign_in @user
				get :new
			}

			it 'responds with a 200 status' do
				expect(response).to have_http_status(200)
			end

			it 'renders the new template' do
				expect(response).to render_template('new')
			end

		end

		context 'as a guest' do
			before { get :new }

			it 'responds with a 302 status' do
				expect(response).to have_http_status(302)
			end

			it 'redirects to the sign in page' do
				expect(response).to redirect_to '/users/sign_in'
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

			context 'with valid attributes' do
				it 'add a project' do
					sign_in @user
					expect {
						post :create, params: {project: @project_params}
					}.to change(@user.projects, :count).by(1)
				end
			end

			context 'with invalid attributes' do
				it 'does not add a project' do
					project_params = FactoryBot.attributes_for(:project, :invalid_attributes)
					sign_in @user
					expect {
						post :create, params: {project: project_params}
					}.to_not change(@user.projects, :count)
				end
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

	describe '#edit' do
		before {
			@user = FactoryBot.create(:user)
			@project = FactoryBot.create(:project, owner: @user)
		}

		context 'as an authenticated user' do
			context 'as an authorised user'do
				before {
					sign_in @user
					get :edit, params: {id: @project.id}
				}
				it 'return a response status of 200' do
					expect(response).to have_http_status(200)
				end

				it 'render the edit view' do
					expect(response).to render_template('edit')
				end
			end

			context 'as an unauthorised user' do
				before {
					other_user = FactoryBot.create(:user)
					sign_in other_user
					get :edit, params: {id: @project.id}
				}

				it 'returns a response status of 302' do
					expect(response).to have_http_status(302)
				end

				it 'redirects to the dashboard' do
					expect(response).to redirect_to root_path
				end
			end
		end

		context 'as a guest' do
			before {
				get :edit, params: {id: @project.id}
			}

			it 'responds with a 302 status' do
				expect(response).to have_http_status(302)
			end

			it 'redirects to the sign in page' do
				expect(response).to redirect_to '/users/sign_in'
			end
		end

	end

	describe '#update' do

		# can edit their own
		context 'as an authorised user' do
			before {
				# create the user and assign the project to that user
				@user = FactoryBot.create(:user)
				@project = FactoryBot.create(:project, owner: @user, name: 'Old Project Name')
			}

			context 'with valid attributes' do
				it 'updates a project' do
					# update the project name
					project_params = FactoryBot.attributes_for(:project, name: 'New Project Name')
					sign_in @user
					patch :update, params: {id: @project.id, project: project_params}
					# refresh the value in memory with that in the database before checking
					expect(@project.reload.name).to eq 'New Project Name'
				end
			end

			context 'with invalid attributes' do
				it 'does not update the project' do
					project_params = FactoryBot.attributes_for(:project, :invalid_attributes)
					sign_in @user
					patch :update, params: {id: @project.id, project: project_params}
					expect(@project.reload.name).to eq 'Old Project Name'
				end
			end
		end

		# can not edit other users projects
		context 'as an unauthorised user' do
			before {
				user = FactoryBot.create(:user)
				other_user = FactoryBot.create(:user)
				@project = FactoryBot.create(:project, name: 'Other Users Project', owner: other_user)
				sign_in user
				project_params = FactoryBot.attributes_for(:project, name: 'New Project Name')
				patch :update, params: {id: @project.id, project: project_params}
			}

			it 'does not update the project' do
				expect(@project.reload.name).to eq 'Other Users Project'
			end

			it 'redirects to the dashboard' do
				expect(response).to redirect_to root_path
			end
		end

		# prevented from update
		context 'as a guest' do
			before {
				project = FactoryBot.create(:project)
				project_params = FactoryBot.attributes_for(:project, name: 'My Own Project Name')
				patch :update, params: {id: project.id, params: project_params}
			}

			it 'returns a 302 response' do
				expect(response).to have_http_status 302
			end

			it 'redirects to the sign in page' do
				expect(response).to redirect_to '/users/sign_in'
			end

		end

	end

	describe '#destroy' do
		context 'as an authorised user' do
			before {
				@user = FactoryBot.create(:user)
				@project = FactoryBot.create(:project, owner: @user)
			}

			it 'deletes a project' do
				sign_in @user
				expect {
					delete :destroy, params: {id: @project.id}
				}.to change(@user.projects, :count).by(-1)
			end
		end

		context 'as an unauthorised user' do
			before {
				user = FactoryBot.create(:user)
				other_user = FactoryBot.create(:user)
				@project = FactoryBot.create(:project, owner: other_user)
				sign_in user
			}

			it 'does not delete the project' do
				expect {
					delete :destroy, params: {id: @project.id}
				}.to_not change(Project, :count)
			end

			it 'redirects to the dashboard' do
				delete :destroy, params: {id: @project.id}
				expect(response).to redirect_to root_path
			end

		end

		context 'as a guest' do
			before {
				@project = FactoryBot.create(:project)
			}

			it 'does not delete the project' do
				expect {
					delete :destroy, params: {id: @project.id}
				}.to_not change(Project, :count)
			end

			it 'returns a 302 response' do
				delete :destroy, params: {id: @project.id}
				expect(response).to have_http_status 302
			end

			it 'redirects to the sign in page ' do
				delete :destroy, params: {id: @project.id}
				expect(response).to redirect_to '/users/sign_in'
			end
		end
	end



end
