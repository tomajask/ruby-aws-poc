# frozen_string_literal: true

require "aws-sdk-dynamodb"
require 'forwardable'

class DynamoDB
  extend Forwardable
  attr_reader :client

  def initialize(client: nil)
    @client = client || AwsClient.dynamodb
  end

  def_delegators :client,
                 :create_table, :put_item, :get_item, :query, :scan, :update_item, :delete_item
end
