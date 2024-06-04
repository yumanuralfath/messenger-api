module RequestSpecHelper
  # Parse JSON response to Ruby hash
  def response_body
    json_response = JSON.parse(response.body, symbolize_names: true)
    if json_response.is_a?(Array)
      json_response.map(&:with_indifferent_access)
    else
      json_response.with_indifferent_access
    end
  end

  # Extract 'data' from JSON response
  def response_data
    response_body[:data] if response_body.is_a?(Hash)
  end

  # Validate response status and JSON type
  def expect_response(status, json = nil)
    begin
      expect(response).to have_http_status(status)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      e.message << "\n#{JSON.pretty_generate(response_body)}"
      raise e
    end
    expect(response_body).to be_json_type(json) if json && !response_body.empty?
  end
end
