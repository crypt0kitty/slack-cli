require_relative 'test_helper'
describe "workspace tests" do

  describe "initialize workspace" do
    it "can create workspace " do
      VCR.use_cassette("create_workspace") do
        workspace = Workspace.new
        workspace.must_be_instance_of Workspace
      end
    end
  end

  describe '#select_user' do
    before do
      VCR.use_cassette("create_workspace") do
        @workspace_user = Workspace.new
      end
    end
    it 'selected user should be an instance of user ' do
      @workspace_user.select_user('slackbot')
      expect(@workspace_user.selected).must_be_instance_of User
    end
  end

  describe '#select_channel' do
    before do
      VCR.use_cassette("create_workspace") do
        @workspace_channel = Workspace.new
      end
    end
    it 'selected user should be an instance of channel' do
      @workspace_channel.select_channel('general')
      expect(@workspace_channel.selected).must_be_instance_of Channel
    end
  end


  describe '#details' do
    it "will get channel details" do
      VCR.use_cassette("create_workspace") do
        workspace = Workspace.new
        workspace.select_channel("study-beats")
        details = workspace.details
        expect(details).must_be_instance_of String
      end
    end
  end

  describe "sends a valid message" do
    it "can send a message " do
      VCR.use_cassette("create_workspace") do
        workspace = Workspace.new
        workspace.select_user("Sandy Vasquez")
        final_result = workspace.send_message("Hello World!")
        expect(final_result).must_equal true
      end
    end

    it "fails to send message with invalid token " do
      VCR.use_cassette("create_workspace") do
        workspace = Workspace.new
        env_token = ENV['SLACK_TOKEN']
        ENV['SLACK_TOKEN'] = "Bad token value"
        workspace.select_user("Sandy Vasquez")
        expect{
          workspace.send_message("Hello World!")
        }.must_raise SlackAPIError
        ENV['SLACK_TOKEN'] = env_token
      end
    end

    it "can't send a message without selecting first " do
      VCR.use_cassette("create_workspace") do
        workspace = Workspace.new
        final_result = workspace.send_message("Hello World!")
        expect(final_result).must_equal false
      end
    end
  end
end
