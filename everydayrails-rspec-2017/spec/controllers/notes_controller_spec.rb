require 'rails_helper'

RSpec.describe NotesController, type: :controller do
	before {
		@user = FactoryBot.create(:user)
		@other_user = FactoryBot.create(:user, first_name: 'Tim')
		@project = FactoryBot.create(:project, owner: @user)
		@note = @project.notes.create!(message: 'Test message', user: @user)
	}

	describe '#index' do
		context 'as an authenticated user' do
			context 'who is authorised' do
				it 'returns a http status of 200' do
					sign_in @user
					get :index, params: {project_id: @project.id, id: @note.id, term: 'message'}
					expect(response).to have_http_status 200
				end
			end

			context 'who is not authorised' do
				it 'redirects to the dashboard' do
					sign_in @other_user
					get :index, params: {project_id: @project.id, id: @note.id, term: 'message'}
					expect(response).to redirect_to root_path
				end
			end
		end

		context 'as a guest' do
			it 'redirects to the sign in page' do
				get :index, params: {project_id: @project.id, id: @note.id, term: 'message'}
				expect(response).to redirect_to '/users/sign_in'
			end
		end

	end

	describe '#show' do
		context 'as an authenticated user' do
			context 'who is authorised' do
				it 'return data in json format' do
					sign_in @user
					get :show, format: :json, params: {project_id: @project.id, id: @note.id}
					expect(response.content_type).to eq 'application/json'
				end
			end

			context 'who is not authorised' do
				it 'redirects to the dashboard' do
					sign_in @other_user
					get :show, format: :json, params: {project_id: @project.id, id: @note.id}
					expect(response).to redirect_to root_path
				end
			end
		end

		context 'as a guest' do
			it 'redirects to the sign in page' do
				get :show, params: {project_id: @project.id, id: @note.id}
				expect(response).to redirect_to '/users/sign_in'
			end
		end
	end

	describe '#new' do
		context 'as an authenticated user' do
			context 'who is authorised' do
				before {
					sign_in @user
					get :new, params: {project_id: @project.id}
				}
				it 'returns http status 200' do
					expect(response).to have_http_status 200
				end

				it 'renders new view' do
					expect(response).to render_template('new')
				end
			end

			context 'who is not authorised' do

			end
		end

		context 'as a guest' do
			it 'redirects to the sign in page' do
				get :new, params: {project_id: @project.id}
				expect(response).to redirect_to '/users/sign_in'
			end
		end
	end

	describe '#create' do
		before {
			@note_params = {message: 'New message', user: @user}
		}
		context 'as an authenticated user' do
			before {sign_in @user}

			context 'who is authorised' do
				context 'with valid data' do
					it 'adds a note' do
						expect {
							post :create, params: {project_id: @project.id, note: @note_params}
						}.to change(@project.notes, :count).by(1)
					end
				end

				context 'with invalid data' do
					it 'does not add a note' do
						invalid_params = {message: nil, user: @user}
						expect {
							post :create, params: {project_id: @project.id, note: invalid_params}
						}.to_not change(@project.notes, :count)
					end
				end
			end

			context 'who is not authorised' do
				it 'does not add a note' do
					sign_in @other_user
					note_params = {message: 'Other Users note', user: @other_user}
					expect {
						post :create, params: {project_id: @project.id, note: note_params}
					}.to_not change(@project.notes, :count)
				end

			end
		end

		context 'as a guest' do
			it 'does not create the note' do
				expect {
					post :create, params: {project_id: @project.id, note: @note_params}
				}.to_not change(@project.notes, :count)
			end

			it 'redirects to the sign in page' do
				post :create, params: {project_id: @project.id, note: @note_params}
				expect(response).to redirect_to '/users/sign_in'
			end
		end
	end

	describe '#edit' do
		context 'as an authenticated user' do
			context 'who is authorised' do
				it 'renders edit view' do
					sign_in @user
					get :edit, params: {project_id: @project.id, id: @note}
					expect(response).to render_template 'edit'
				end
			end

			context 'who is not authorised' do
				it 'redirects to the dashboard' do
					sign_in @other_user
					get :edit, params: {project_id: @project.id, id: @note.id}
					expect(response).to redirect_to root_path
				end
			end
		end

		context 'as a guest' do
			it 'redirects to sign in page' do
				get :edit, params: {project_id: @project.id, id: @note.id}
				expect(response).to redirect_to '/users/sign_in'
			end
		end
	end

end
