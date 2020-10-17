require_relative 'test_helper'

describe 'Recipient' do
  describe '#initialize' do
    before do
      @name_test = 'Poco'
      @slack_id_test = 'U576'
      @new_recipient = Recipient.new(@name_test, @slack_id_test)
    end

    it 'should create a new instance of Recipient' do
      expect(@new_recipient).must_be_instance_of Recipient
    end

    it 'should access attributes' do
      expect(@new_recipient.name).must_equal @name_test
      expect(@new_recipient.slack_id).must_equal @slack_id_test
    end

    it 'should respond to variable names' do
      [:name, :slack_id].each do |variable_name|
        expect(@new_recipient).must_respond_to variable_name
      end
    end

    it 'should raise Argument Error if input is invalid' do
      name = ''
      slack_id = ''
      expect{Recipient.new(nil,nil)}.must_raise ArgumentError
      expect{Recipient.new(name, slack_id)}.must_raise ArgumentError
    end
  end
  describe '.get' do

    it 'should raise Error if response is bad' do
      VCR.use_cassette('users_list') do
        expect{Recipient.get('https://slack.com/api/fsjfsk')}.must_raise SlackAPIError
      end
    end

    it 'should be an instance of HTTParty' do
      url = 'https://slack.com/api/users.list'
      VCR.use_cassette('users_list') do
        response = Recipient.get(url)
        expect(response).must_be_kind_of HTTParty::Response
      end
    end
  end

  describe 'details' do
    it 'should Raise error if implemented in recipient class ' do
      recipient_new = Recipient.new('bot', 'U545')
      expect{recipient_new.details}.must_raise NotImplementedError
    end
  end
end
