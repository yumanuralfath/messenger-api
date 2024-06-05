RSpec::Matchers.define :match_json_structure do |expected_structure|
  match do |actual_json|
    def match_structure(expected, actual)
      expected.all? do |key, value|
        case value
        when Hash
          actual[key].is_a?(Hash) && match_structure(value, actual[key])
        when Array
          actual[key].is_a?(Array) &&
            actual[key].all? { |item| match_structure(value.first, item) }
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
