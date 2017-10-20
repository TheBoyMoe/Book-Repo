require 'rails_helper'

RSpec.describe "microposts/edit", type: :view do
  before(:each) do
    @micropost = assign(:micropost, Micropost.create!(
      :content => "MyText",
      :user_id => 1
    ))
  end

  it "renders the edit micropost form" do
    render

    assert_select "form[action=?][method=?]", micropost_path(@micropost), "post" do

      assert_select "textarea[name=?]", "micropost[content]"

      assert_select "input[name=?]", "micropost[user_id]"
    end
  end
end
