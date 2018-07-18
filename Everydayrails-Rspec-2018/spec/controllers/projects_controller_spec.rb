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
end