require 'httparty'
require 'dotenv/load'
require 'awesome_print'
require_relative 'recipient'

class Channel < Recipient

  attr_reader :topic, :member_count

  def initialize(name, slack_id, topic, member_count)
    super(name, slack_id)
    @topic = topic
    @member_count = member_count
  end

  def self.list
    response = Channel.get("https://slack.com/api/conversations.list")
    user_info_array = response["channels"].map do |channel|
      name = channel["name"]
      slack_id = channel["id"]
      topic = channel["purpose"]["value"]
      member_count = channel["num_members"]
      Channel.new(name, slack_id, topic, member_count )
    end
    return user_info_array
  end

  def details
    return "Name: #{@name}\nID: #{@slack_id}\nTopic: #{@topic}\nMember Count: #{@member_count}"
  end
end
