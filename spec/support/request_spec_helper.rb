module RequestSpecHelper
  # Parse JSON response to Ruby hash
  def response_body
    JSON.parse(response.body, symbolize_names: true)
  end

  # Validate response status and JSON structure
  def expect_response(status, expected_json = nil)
    begin
      expect(response).to have_http_status(status)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      e.message << "\n#{JSON.pretty_generate(response_body)}"
      raise e
    end

    if expected_json && !response_body.empty?
      expect(response_body).to match_json_structure(expected_json)
    end
  end
end

RSpec.configure do |config|
  config.include RequestSpecHelper, type: :request
end

# Custom matcher for JSON structure
RSpec::Matchers.define :match_json_structure do |expected_structure|
  match do |actual_json|
    def match_structure(expected, actual)
      expected.all? do |key, value|
        case value
        when Hash
          actual[key].is_a?(Hash) && match_structure(value, actual[key])
        when Array
          actual[key].is_a?(Array) && actual[key].all? { |item| match_structure(value.first, item) }
        else
          actual[key].is_a?(value)
        end
      end
    end

    match_structure(expected_structure, actual_json)
  end

  failure_message do |actual|
    "expected #{actual} to match structure #{expected_structure}"
  end
end
