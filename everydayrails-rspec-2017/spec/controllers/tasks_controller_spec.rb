require 'rails_helper'

RSpec.describe TasksController, type: :controller do

	before {
		@user = FactoryBot.create(:user)
		@project = FactoryBot.create(:project, owner: @user)
		@task = @project.tasks.create!(name: 'Test task')
	}

	describe '#show' do
		it 'responds with json formatted data' do
			sign_in @user
			get :show, format: :json, params: {id: @task.id, project_id: @project.id}
			expect(response.content_type).to eq 'application/json'
		end

		it 'responds with text/html formatted data' do
			sign_in @user
			get :show, params: {id: @task.id, project_id: @project.id}
			expect(response.content_type).to eq 'text/html'
		end
	end

	describe '#create' do
		before {
			@new_task = {name: 'New task'}
		}

		context 'as an authenticated user' do
			before {
				sign_in @user
			}

			it 'responds with JSON formatted output' do
				post :create, format: :json, params: {project_id: @project.id, task: @new_task}
				expect(response.content_type).to eq 'application/json'
			end

			it 'adds a new task to the project' do
				expect {
					post :create, format: :json, params: {project_id: @project.id, task: @new_task}
				}.to change(@project.tasks, :count).by(1)
			end
		end

		context 'as an unauthenticated user' do
			it 'does not succeed' do
				post :create, format: :json, params: {project_id: @project.id, task: @new_task}
				expect(response).to_not be_success
			end

			it 'does not create a new task' do
				expect {
					post :create, format: :json, params: {project_id: @project.id, task: @new_task}
				}.to_not change(@project.tasks, :count)
			end
		end

	end

end
