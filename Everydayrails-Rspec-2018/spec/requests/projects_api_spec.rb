require 'rails_helper'

RSpec.describe 'ProjectApis', type: :request do
  describe 'GET /api/projects' do
    it 'works!' do
      get api_projects_path
      expect(response).to have_http_status(200)
    end
  end

  # only projects owned by that user are fetched
  it 'loads a project' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: 'Sample Project')
    FactoryBot.create(:project, name: 'Second Sample Project', owner: user)

    get api_projects_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }
    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.length).to eq 1
    project_id = json[0]["id"]

    get api_project_path(project_id), params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json['name']).to eq 'Second Sample Project'
    expect(json['description']).to eq 'Test project'
  end
end
