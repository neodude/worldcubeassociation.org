require "rails_helper"

describe "oauth api" do
  include Capybara::DSL

  let(:user) { FactoryGirl.create :user }

  it 'can authenticate with grant_type password' do
    post oauth_token_path, grant_type: "password", username: user.email, password: user.password
    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(json['error']).to eq(nil)
    access_token = json['access_token']
    expect(access_token).to_not eq(nil)
    verify_access_token access_token
  end

  it 'can authenticate with grant_type authorization' do
    oauth_app = FactoryGirl.create :oauth_application, redirect_uri: oauth_authorization_url
    params = { client_id: oauth_app.uid, redirect_uri: oauth_app.redirect_uri, response_type: "code" }
    visit oauth_authorization_path(params)

    # Pretend we're the user:
    #  1. Log in
    fill_in "user_login", with: user.email
    fill_in "user_password", with: user.password
    click_button "Sign in"
    #  2. Authorize the application
    click_button "Authorize"

    query = Rack::Utils.parse_query(URI.parse(current_url).query)
    authorization_code = query["code"]

    # We've now received an authorization_code from the user, lets request an
    # access_token.
    post oauth_token_path, grant_type: "authorization_code", client_id: oauth_app.uid, client_secret: oauth_app.secret, code: authorization_code, redirect_uri: oauth_app.redirect_uri
    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(json['error']).to eq(nil)
    access_token = json['access_token']
    expect(access_token).to_not eq(nil)
    verify_access_token access_token
  end

  it 'can authenticate with response_type token (implicit authorizaion)' do
    oauth_app = FactoryGirl.create :oauth_application
    params = { client_id: oauth_app.uid, redirect_uri: oauth_app.redirect_uri, response_type: "token" }
    visit oauth_authorization_path(params)

    # Pretend we're the user:
    #  1. Log in
    fill_in "user_login", with: user.email
    fill_in "user_password", with: user.password
    click_button "Sign in"
    #  2. Authorize the application
    click_button "Authorize"

    query = Rack::Utils.parse_query(URI.parse(current_url).query)
    access_token = query["access_token"]
    expect(access_token).to_not eq(nil)
    verify_access_token access_token
  end

  def verify_access_token(access_token)
    integration_session.reset! # posting to oauth_token_path littered our state
    get api_v0_me_path, nil, { "Authorization" => "Bearer #{access_token}" }
    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(json['me']['email']).to eq(user.email)
  end
end
