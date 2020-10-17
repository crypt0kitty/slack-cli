require 'httparty'
require 'dotenv/load'
require 'awesome_print'
require 'table_print'
require_relative 'recipient'


class User < Recipient
  attr_reader :real_name

  def initialize(name, slack_id, real_name)
    super(name, slack_id)
    @real_name = real_name
  end

  def self.list
    response = User.get("https://slack.com/api/users.list")

    user_info_array = response["members"].map do |member|
      username = member["name"]
      real_name = member["real_name"]
      slack_id = member["id"]
      User.new(username, slack_id, real_name)
    end

    return user_info_array
  end

  def details
    return "ID: #{@slack_id}\nName: #{@name}\nReal Name: #{@real_name}"
  end
end
