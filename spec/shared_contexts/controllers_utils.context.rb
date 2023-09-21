# frozen_string_literal: true

RSpec.shared_context 'controllers utils' do
  def parsed_response_body
    json = response.body.to_s.valid_json? ? JSON.parse(response.body) : {}
    json.is_a?(Hash) ? json.with_indifferent_access : json
  end

  # @param errors [Array<Hash>] => array of errors
  # @param field [String] => field name
  # @return [Array<Hash>] => filtered errors
  def find_error(params = {})
    errors = params.delete(:errors) || parsed_response_body[:errors]
    field = params.delete(:field)

    return errors if !errors.is_a?(Array) || !errors.all? { |e| e.is_a?(Hash) }

    errors.select do |e|
      good = true
      good &= e.slice(*params.keys) == params if params.present? && params.is_a?(Hash)
      good &= e[:attribute].to_s == field.to_s if field.present? && (field.is_a?(String) || field.is_a?(Symbol))
      good
    end
  end

  alias find_errors find_error

  # Errors after a failed Http request.
  # Usually the http status code is 422 (Unprocessable Entity), and the response body is formatted as:
  # ```json`
  # {
  #   "message": ["Name can't be blank", "Email can't be blank"],
  #   "errors": [
  #     {
  #       "field": "name",
  #       "message": "can't be blank"
  #     },
  #     {
  #       "field": "email",
  #       "message": "can't be blank"
  #     }
  #   ]
  # }
  # ```
  def errors(field = nil, params = {})
    errors = parsed_response_body[:details]
    if field.nil? || field.blank? || (errors.is_a?(Array) && errors.empty?) || errors.nil?
      return errors.is_a?(Array) ? errors : []
    end

    find_error((params || {}).merge(errors: errors, field: field))
  end

  def are_sequnces_increasing(array)
    raise ArgumentError, "Array expected, got #{array.class}" unless array.is_a?(Array)
    return true if array.size < 2

    array.each_cons(2).all? { |a, b| a < b }
  end
end
