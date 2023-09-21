# frozen_string_literal: true

LIMESURVEY_MOCK_CONTEXT = 'limesurvey_mock.context'
RSpec.shared_context LIMESURVEY_MOCK_CONTEXT do # rubocop:disable Metrics/BlockLength
  let(:current_user) { create(:user) }
  let(:lime_survey) { create(:lime_survey, lime_instance: lime_instance) }
  let(:project) { create(:project, :with_quotation_with_company) }
  def user
    current_user
  end

  def lime_instance(domain: lime_domain, username: valid_username, password: valid_password)
    return @lime_instance unless @lime_instance.nil?

    @lime_instance = create(
      :lime_instance,
      :with_creator,
      :with_lime_configuration,
      domain: domain,
      username: username,
      password: password,
      secure: false
    )
  end

  attr_writer :lime_domain

  def lime_domain
    "#{@lime_domain || 'limesurvey.example.com'}"
  end

  def lime_port
    return @lime_port unless @lime_port.nil?

    80
  end

  def lime_api_path
    "#{lime_domain}/index.php/admin/remotecontrol"
  end

  def lime_api_url
    "http://#{lime_api_path}"
  end
  # alias_method :api_url, :lime_api_url

  def valid_username
    'admin'
  end

  def valid_password
    'password'
  end

  def invalid_username
    'invalid'
  end

  def invalid_password
    'invalid'
  end

  def valid_session_key
    'valid_session_key'
  end

  def invalid_session_key
    'invalid_session_key'
  end

  def authenticate(username: valid_username, password: valid_password)
    url = URI(lime_instance.api_url)
    request = Net::HTTP::Post.new(url)
    request.body = {
      method: :get_session_key,
      params: [username, password],
      id: 'any'
    }.to_json

    http = Net::HTTP.new(url.host, url.port)

    http.request(request).read_body
  end

  def enable_limesurvey_mock
    WebMock.disable_net_connect!(allow_localhost: true, allow: lime_domain)
    stub_request(:post, lime_api_url).to_return do |request|
      { body: LimesurveyApiMock.run!(request: request) }
    end
  end
end
