# frozen_string_literal: true

require "aws-sdk-dynamodb"

class DynamoDB
  def initialize(client: nil)
    @client = client || AwsClient.dynamodb
  end

  def call
    # TODO: implement
  end

  private

  attr_reader :client
end
