require 'rails_helper'

RSpec.describe "microposts/new", type: :view do
  before(:each) do
    assign(:micropost, Micropost.new(
      :content => "MyText",
      :user_id => 1
    ))
  end

  it "renders new micropost form" do
    render

    assert_select "form[action=?][method=?]", microposts_path, "post" do

      assert_select "textarea[name=?]", "micropost[content]"

      assert_select "input[name=?]", "micropost[user_id]"
    end
  end
end
