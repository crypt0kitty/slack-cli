require 'httparty'
require 'dotenv/load'

class SlackAPIError < StandardError
end

class Recipient
  attr_reader :name, :slack_id

  def initialize(name, slack_id)
    @name = name
    @slack_id = slack_id
    raise ArgumentError, 'Input cannot be nil' if name.nil? || slack_id.nil?
    raise ArgumentError, 'Input cannot be blank' if name.empty? || slack_id.empty?
  end

  def details
    raise NotImplementedError, 'Implement me in a child class!'
  end

  def self.get(url)
    query_paramaters = {
        token: ENV['SLACK_TOKEN']
    }
    response = HTTParty.get(url, query: query_paramaters)
    sleep(1)

    unless response['ok'] && response.code == 200
      raise SlackAPIError, "Error: #{response['error']}, #{response.code}, #{response.message}"
    end
    return response
  end
end
