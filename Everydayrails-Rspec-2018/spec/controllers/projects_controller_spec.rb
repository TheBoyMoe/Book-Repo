require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe '#index' do
    context 'as an authenticated user' do
      before do
        # create user and simulate sign-in
        user = FactoryBot.create(:user)
        sign_in(user)
      end
      
      it 'responds successfully' do
        get :index
        expect(response).to be_success
      end
  
      it 'returns a 200 response' do
        get :index
        expect(response).to have_http_status '200'
      end
    end
    
    # check that the controller intercepts unauthenticated requests and
    # redirects the user to the sign-in page
    context 'as a guest' do
      it 'returns a 302 response' do
        get :index
        expect(response).to have_http_status '302'
      end
      
      it 'redirects to the sign-in page' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#show' do
    context 'as an authorised user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it 'responds successfully' do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to be_success
      end
    end

    # project owners/authorised can list all projects, or create new projects
    # you need to be authenticated to CRUD projects
    context 'as an unauthorised user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
        
        sign_in @user
        get :show, params: { id: @project.id }
      end

      it 'returns a 302 response' do
        expect(response).to have_http_status '302'
      end

      it 'redirects to the dashboard' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
        @project_params = FactoryBot.attributes_for(:project)
      end

      it 'adds a project' do
        sign_in @user
        expect {
          post :create, params: { project: @project_params }
        }.to change(@user.projects, :count).by(1)
      end
    end

    context 'as a guest' do
      before do
        post :create, params: { project: @project_params }
      end

      it 'returns a 302 response' do
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it 'updates the project' do
        project_params = FactoryBot.attributes_for(:project, name: 'New Project Name')
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq 'New Project Name'
      end
    end

    # try and update the project of another user
    context 'as an unauthorized user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user, name: 'Same Old Name')
 
        project_params = FactoryBot.attributes_for(:project, name: 'New Project Name')
        sign_in @user # you need to be authenticated
        patch :update, params: { id: @project.id, project: project_params }
      end

      it 'does not update the project' do
        expect(@project.reload.name).to eq 'Same Old Name'
      end

      it 'redirect to the dashboard' do
        expect(response).to redirect_to root_path
      end
    end

    # unauthenticated user
    context 'as a guest' do
      before do
        project = FactoryBot.create(:project)
        project_params = FactoryBot.attributes_for(:project, name: 'New Project Name')
        patch :update, params: { id: project.id, project: project_params }
      end
      
      it 'returns a 302 response' do
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end
      
      it 'deletes a project' do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to change(@user.projects, :count).by(-1)
      end
    end

    context 'as an unauthorised user' do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end
      
      it 'does not delete the project' do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)
      end

      it 'redirects to the dashboard' do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to root_path 
      end
    end

    context 'as a guest' do
      before do
        @project = FactoryBot.create(:project)
      end

      it 'returns a 302 response' do
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status '302'
      end

      it 'redirects to the sign-in page' do
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to '/users/sign_in'
      end

      it 'does not delete the project' do
        expect {
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)
      end
    end
  end
end