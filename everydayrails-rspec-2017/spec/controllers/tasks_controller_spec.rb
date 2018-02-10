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



end
