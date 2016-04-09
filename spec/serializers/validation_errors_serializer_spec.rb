require "rails_helper"

describe ValidationErrorsSerializer do
  describe  ".serialize" do
    it "can serialize ActiveModel::Errors" do
      user = User.new
      user.errors.add(:name, "cannot be nil")
      user.errors.add(:first_name, "cannot be longer than 20 characters")

      result = ValidationErrorsSerializer.new(user).serialize
      expect(result[:errors]).not_to be_nil
      expect(result[:errors].length).to eq 2

      first_error = result[:errors].first
      expect(first_error[:id]).to eq "VALIDATION_ERROR"
      expect(first_error[:source][:pointer]).to eq "data/attributes/name"
      expect(first_error[:detail]).to eq "cannot be nil"
      expect(first_error[:status]).to eq 422

      second_error = result[:errors].last
      expect(second_error[:id]).to eq "VALIDATION_ERROR"
      expect(second_error[:source][:pointer]).to eq "data/attributes/first_name"
      expect(second_error[:detail]).to eq "cannot be longer than 20 characters"
      expect(second_error[:status]).to eq 422
    end
  end
end
