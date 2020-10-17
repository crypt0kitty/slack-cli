require_relative 'test_helper'

#class methods are prefixed with a dot (".add"), and instance methods with a dash ("#add").
describe 'User' do
  describe "#initialize" do
    before do
      @name_test = 'Ariel'
      @slack_id_test = 'UH1234'
      @real_name_test = 'Ariel Jones'
      @test_case = User.new(@name_test, @slack_id_test, @real_name_test)
    end

      it "given a new User instance, should return accurate user info" do
        expect(@test_case).must_be_instance_of User
        expect(@test_case.name).must_equal 'Ariel'
        expect(@test_case.slack_id).must_equal 'UH1234'
        expect(@test_case.real_name).must_equal 'Ariel Jones'
      end


      it "user instance variables, should be an instance of string" do
        expect(@test_case.name).must_be_instance_of String
        expect(@test_case.slack_id).must_be_instance_of String
        expect(@test_case.real_name).must_be_instance_of String
      end

    it 'should access attributes' do
      expect(@test_case.name).must_equal @name_test
      expect(@test_case.slack_id).must_equal @slack_id_test
      expect(@test_case.real_name).must_equal @real_name_test
    end

    it 'should respond to variable names ' do
      [:name, :slack_id, :real_name].each do |variable_name|
        expect(@test_case).must_respond_to variable_name
      end
    end
  end


  describe '.self.list' do
    before do
      VCR.use_cassette("users_list") do
        @test_array = User.list
       end
    end

    it "should return array of users/members" do
      expect(@test_array).must_be_instance_of Array
    end

    it "each user/member in array should be an instance of User" do
      @test_array.each do |member|
        expect(member).must_be_instance_of User
      end
    end

    it 'array length should be greater than 0' do
      expect(@test_array.length).must_be:>,0
    end
  end

  describe '#details' do
    before do
      @new_user = User.new('Ariel','UH1234', 'Ariel Jones')
    end

    it 'should return a string' do
      expect(@new_user.details).must_be_instance_of String
    end

    it 'should return accurate details in String' do
      expect(@new_user.details).must_equal "ID: UH1234\nName: Ariel\nReal Name: Ariel Jones"
    end
  end
end
