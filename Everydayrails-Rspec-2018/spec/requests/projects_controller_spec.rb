require 'rails_helper'

# feature vs request vs controller specs
# FEATURE specs exercise the code at the highest level -
# in the same way the suer would use the app - i.e. view -> route -> controller#action
# REQUEST specs exercise the route and controller action, as apposed to the 
# CONTROLLER specs which exercise the action in isolation(unit test)

RSpec.describe 'Projects', type: :request do

  describe 'creating a project' do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end
 
      context 'with valid attributes' do
        it 'adds a project' do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          expect {
            post projects_path, params: { project: project_params }
          }.to change(@user.projects, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add a project' do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user
          expect {
            post projects_path, params: { project: project_params }
          }.to_not change(@user.projects, :count)
        end
      end
    end
    
    context 'as a guest' do
      before do
        project_params = FactoryBot.attributes_for(:project)
        post projects_path, params: { project: project_params }
      end
  
      it 'returns a 302 response' do
        expect(response).to have_http_status(302)
      end
  
      it 'redirects to the sign-in page' do
        expect(response).to redirect_to user_session_path
      end
    end
  end

end
