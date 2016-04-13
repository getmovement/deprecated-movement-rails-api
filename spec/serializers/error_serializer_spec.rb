require "rails_helper"

describe ErrorSerializer do
  describe  ".serialize" do
    it "can serialize ActiveRecord::RecordNotFound error" do
      record_not_found_error = ActiveRecord::RecordNotFound.new("A message")
      result = described_class.new(record_not_found_error).serialize

      expect(result[:errors]).not_to be_nil
      expect(result[:errors].length).to eq 1

      serialized_error = result[:errors].first
      expect(serialized_error[:id]).to eq "RECORD_NOT_FOUND"
      expect(serialized_error[:title]).to eq "Record not found"
      expect(serialized_error[:detail]).to eq "A message"
      expect(serialized_error[:status]).to eq 404
    end

    it "can serialize Doorkeeper::OAuth::InvalidTokenResponse" do
      error = Doorkeeper::OAuth::InvalidTokenResponse.new
      result = described_class.new(error).serialize

      expect(result[:errors]).not_to be_nil
      expect(result[:errors].length).to eq 1

      serialized_error = result[:errors].first
      expect(serialized_error[:id]).to eq "NOT_AUTHORIZED"
      expect(serialized_error[:title]).to eq "Not authorized"
      expect(serialized_error[:detail]).to eq "The access token is invalid"
      expect(serialized_error[:status]).to eq 401
    end

    it "can serialize ActionController::ParameterMissing" do
      error = ActionController::ParameterMissing.new(:test_parameter)
      result = described_class.new(error).serialize

      expect(result[:errors]).not_to be_nil
      expect(result[:errors].length).to eq 1

      serialized_error = result[:errors].first
      expect(serialized_error[:id]).to eq "PARAMETER_MISSING"
      expect(serialized_error[:title]).to eq "Parameter is missing"
      expect(serialized_error[:detail]).to eq error.message
      expect(serialized_error[:status]).to eq 400
    end

    it "can serialize Doorkeeper::OAuth::ErrorResponse" do
      error = Doorkeeper::OAuth::ErrorResponse.new name: "invalid_grant"
      result = ErrorSerializer.new(error).serialize

      expect(result[:errors]).not_to be_nil
      expect(result[:errors].length).to eq 1

      error = result[:errors].first
      expect(error[:id]).to eq "INVALID_GRANT"
      expect(error[:title]).to eq "Invalid grant"
      expect(error[:detail]).to eq "The provided authorization grant is invalid, "\
                                   "expired, revoked, does not match the redirection URI used in "\
                                   "the authorization request, or was issued to another client."
      expect(error[:status]).to eq 401
    end

    it "can serialize Koala::Facebook::AuthenticationError" do
      facebook_authentication_error = Koala::Facebook::AuthenticationError.new(
        400, nil, "message" => "A message")
      result = ErrorSerializer.new(facebook_authentication_error).serialize

      expect(result[:errors]).not_to be_nil
      expect(result[:errors].length).to eq 1

      error = result[:errors].first
      expect(error[:id]).to eq "FACEBOOK_AUTHENTICATION_ERROR"
      expect(error[:title]).to eq "Facebook authentication error"
      expect(error[:detail]).to eq "A message"
      expect(error[:status]).to eq 400
    end
  end
end
