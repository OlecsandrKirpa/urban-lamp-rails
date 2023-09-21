# frozen_string_literal: true

class LimesurveyApiMock < ActiveInteraction::Base
  object :request, class: ::WebMock::RequestSignature

  def execute
    body = request.body.is_a?(String) && request.body.valid_json? ? JSON.parse(request.body).with_indifferent_access : request.body
    method = body['method']
    params = body['params']
    id = body['id']
    # TODO
    # limeSurvey does not return { 'error  => 'No method found' } when method is not found.
    unless self.class.respond_to?(method)
      raise <<-ERROR.strip_heredoc

        LimesurveyApiMock
        Method not found: #{method}
        Available methods: #{self.class.methods(false).join(', ')}

      ERROR
    end

    result = self.class.send(method, params)

    { id: id }.merge(result).to_json
  end

  # ROUTES DEFINITION
  class << self
    def get_session_key(params)
      username = params[0]
      password = params[1]

      return { 'result' => 'valid_session_key' } if username == 'admin' && password == 'password'

      { 'error' => 'Invalid user name or password.' }
    end

    # Returns a csv file encoded in base64
    # with the export in format vvv of the responses of the survey.
    def export_responses_vvv(params)
      { 'result' => 'Y2lhbztjb21lO3ZhOwowOzE7Mg==\n' }
    end

    def get_response_stats(params)
      {"total"=>168, "firstId"=>64, "lastId"=>3194, "idsInterval"=>[64, 3194], "metadata"=>{"perPage"=>1000}}
    end
  end
end
