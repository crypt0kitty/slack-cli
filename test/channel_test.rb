require_relative 'test_helper'

#class methods are prefixed with a dot (".add"), and instance methods with a dash ("#add").
describe 'Channel' do
  describe "#initialize" do
    before do
      @name_channel = 'general'
      @slack_id_channel = 'UG9588'
      @topic = 'talking'
      @member_count = 150
      @test_channel = Channel.new(@name_channel,@slack_id_channel, @topic, @member_count)
    end

    it "can create new instance of Channel" do
      expect(@test_channel).must_be_instance_of Channel
    end

    it "given a new Channel instance, should return accurate Channel info" do
      expect(@test_channel.name).must_equal 'general'
      expect(@test_channel.slack_id).must_equal 'UG9588'
      expect(@test_channel.topic).must_equal 'talking'
      expect(@test_channel.member_count).must_equal 150

    end

    it "user instance variables, should be an instance of string, member count an integer" do
      expect(@test_channel.name).must_be_instance_of String
      expect(@test_channel.slack_id).must_be_instance_of String
      expect(@test_channel.topic).must_be_instance_of String
      expect(@test_channel.member_count).must_be_instance_of Integer
    end

    it 'should access attributes' do
      expect(@test_channel.name).must_equal @name_channel
      expect(@test_channel.slack_id).must_equal @slack_id_channel
      expect(@test_channel.topic).must_equal @topic
      expect(@test_channel.member_count).must_equal @member_count
    end

    it 'should respond to variable names ' do
      [:name, :slack_id, :topic, :member_count].each do |variable_name|
        expect(@test_channel).must_respond_to variable_name
      end
    end

  end

  describe '.self.list' do
    before do
      VCR.use_cassette("channels_list") do
        @test_channel_array = Channel.list
      end
    end

    it "should return array of channels" do
      expect(@test_channel_array).must_be_instance_of Array
    end

    it "each channel in array should be an instance of Channel" do
      @test_channel_array.each do |channel|
        expect(channel).must_be_instance_of Channel
      end
    end

    it 'array length should be greater than 0' do
      expect(@test_channel_array.length).must_be:>,0
    end

  end

  describe '#details' do
    before do
      @new_channel = Channel.new('general','UG9588', 'talking',150)
    end

    it 'should return a string' do
      expect(@new_channel.details).must_be_instance_of String
    end

    it 'should return accurate details in String' do
      expect(@new_channel.details).must_equal "Name: general\nID: UG9588\nTopic: talking\nMember Count: 150"
    end
  end
end
