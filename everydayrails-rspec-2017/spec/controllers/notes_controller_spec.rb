require 'rails_helper'

RSpec.describe NotesController, type: :controller do
	before {
		@user = FactoryBot.create(:user)
		@other_user = FactoryBot.create(:user, first_name: 'Tim')
		@project = FactoryBot.create(:project, owner: @user)
		@note = @project.notes.create(message: 'Test message')
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
end
