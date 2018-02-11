require 'rails_helper'

RSpec.describe TasksController, type: :controller do

	before {
		@user = FactoryBot.create(:user)
		@project = FactoryBot.create(:project, owner: @user)
		@task = @project.tasks.create!(name: 'Test task')
		@other_user = FactoryBot.create(:user, first_name: 'Sam')
	}

	describe '#index' do

		context 'as an authenticated user' do

			context 'as an authorised user' do
				it 'returns the project tasks as json data' do
					sign_in @user
					get :index, format: :json, params: {project_id: @project.id}
					expect(response.content_type).to eq 'application/json'
				end
			end

			context 'as an unauthorised user' do
				it 'redirects to the dashboard' do
					sign_in @other_user
					get :index, format: :json, params: {project_id: @project.id}
					expect(response).to redirect_to root_path
				end
			end
		end

		context 'as a guest' do
			before {
				get :index, params: {project_id: @project.id}
			}

			it 'returns a response status of 302' do
				expect(response).to have_http_status 302
			end

			it 'redirects to the sign in page' do
				expect(response).to redirect_to '/users/sign_in'
			end
		end
	end

	describe '#show' do

		context 'as an authenticated user' do
			context 'as an authorised user' do
				it 'responds with json formatted data' do
					sign_in @user
					get :show, format: :json, params: {project_id: @project.id, id: @task.id}
					expect(response.content_type).to eq 'application/json'
				end

				it 'responds with text/html formatted data' do
					sign_in @user
					get :show, params: {project_id: @project.id, id: @task.id}
					expect(response.content_type).to eq 'text/html'
				end
			end

			context 'as an unauthorised user' do
				it 'redirects to the dashboard' do
					sign_in @other_user
					get :show, params: {project_id: @project.id, id: @task.id}
					expect(response).to redirect_to root_path
				end
			end
		end

		context 'as a guest user' do
			it 'redirects to the sign in page' do
				get :show, params: {project_id: @project.id, id: @task.id}
				expect(response).to redirect_to '/users/sign_in'
			end
		end
	end

	describe '#new' do
		context 'as an authenticated user' do
			before {
				sign_in @user
				get :new, params: {project_id: @project.id}
			}
			it 'returns a http status of 200' do
				expect(response).to have_http_status 200
			end

			it 'renders the new view' do
				expect(response).to render_template('new')
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
			@new_task = {name: 'New task'}
		}

		context 'as an authenticated user' do
			before {
				sign_in @user
			}

			context 'with valid data' do
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

			context 'with invalid data' do
				before {
					@task_params = FactoryBot.attributes_for(:task, name: nil)
				}

				it 'does not add the task' do
					expect {
						post :create, params: {project_id: @project.id, task: @task_params}
					}.to_not change(@project.tasks, :count)
				end

				it 'renders the new view' do
					post :create, params: {project_id: @project.id, task: @task_params}
					expect(response).to render_template('new')
				end
			end
		end

		context 'as a guest user' do
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

	describe '#edit' do
		context 'as an authenticated user' do

			context 'who is authorised' do
				before {
					sign_in @user
					get :edit, params: {project_id: @project.id, id: @task.id}
				}

				it 'returns a htp status of 200' do
					expect(response).to have_http_status 200
				end

				it 'renders the view' do
					expect(response).to render_template('edit')
				end
			end

			context 'who is unauthorised'

		end

		context 'as a guest' do
			it 'redirects to the sign in page' do
				get :edit, params: {project_id: @project.id, id: @task.id}
				expect(response).to redirect_to '/users/sign_in'
			end
		end
	end

	describe '#update' do
		before {
			@task_params = FactoryBot.attributes_for(:task, name: 'New Task Name')
		}

		context 'as an authenticated user' do

			context 'who is authorised' do
				before {
					sign_in @user
				}

				context 'with valid data' do
					before {
						patch :update, params: {project_id: @project.id, id: @task.id, task: @task_params}
					}
					it 'it updates the task' do
						expect(@task.reload.name).to eq('New Task Name')
					end

					it 'redirect to project show' do
						expect(response).to redirect_to("/projects/#{@project.id}")
					end
				end

				context 'with invalid data' do
					before {
						invalid_params = FactoryBot.attributes_for(:task, name: nil)
						patch :update, params: {project_id: @project.id, id: @task.id, task: invalid_params}
					}

					it 'does not update the task' do
						expect(@task.reload.name).to eq('Test task')
					end

					it 'renders the edit template' do
						expect(response).to render_template('edit')
					end
				end
			end

			context 'who is not authorised' do
				before {
					sign_in @other_user
					patch :update, params: {project_id: @project.id, id: @task.id, task: @task_params}
				}
				it 'does not update the task' do
					expect(@task.reload.name).to eq('Test task')
				end

				it 'redirects to the dashboard' do
					expect(response).to redirect_to root_path
				end
			end
		end

		context 'as a guest' do
			before {
				patch :update, params: {project_id: @project.id, id: @task.id, task: @task_params}
			}
			it 'does not update the task' do
				expect(@task.reload.name).to eq('Test task')
			end

			it 'redirects to the sign in page' do
				expect(response).to redirect_to '/users/sign_in'
			end
		end
	end

end
