# frozen_string_literal: true

Dir[File.join(ROOT_PATH, "app", "**", "*.rb")].sort.each { |file| require(file) }

### AWS

module AwsClient
  extend self

  def dynamodb
    if ENV["LOCALSTACK_DYNAMODB_ENDPOINT"]
      Aws::DynamoDB::Client.new(endpoint: ENV["LOCALSTACK_DYNAMODB_ENDPOINT"])
    else
      Aws::DynamoDB::Client.new
    end
  end
end
