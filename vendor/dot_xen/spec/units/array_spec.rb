require File.dirname(__FILE__) + '/../spec_helper'

describe XenConfigFileYouShouldntUse::AssignmentNode do
  before(:all) do
    @parser = XenConfigFile::Parser.new
  end
  it "should not be nil" do
    @parser.should_not be_nil
  end
  describe " calling .parse" do
    describe "with two number elements" do
      before(:all) do
        @result = @parser.parse("cpu_environment = [348, 349]\n")
      end
      it "should return a parse representation of the assignment" do
        @result.should_not be_nil
      end
      it "should return an assignment node you shouldn't use" do
        @result.should be_a_kind_of(XenConfigFileYouShouldntUse::ConfigFileNode)
      end
      describe " calling .eval" do
        before(:all) do
          @evaluated_result = @result.eval({})
        end
        it "should return an AST instance of the config file" do
          @evaluated_result.should be_a_kind_of(XenConfigFile::AST::ConfigFile)          
        end
        it "should return the first value of the array assignment" do
          @evaluated_result[:cpu_environment].first.should == 348
        end
        it "should return the second value of the array assignment" do
          @evaluated_result[:cpu_environment].last.should == 349
        end
      end
    end
    describe "with a single quoted string, a number, and a double quoted string" do
      before(:all) do
        @result = @parser.parse("cpu_environment = [\'ey00-s00348\',\n\n 42,\n \"James Brown\"]\n")
      end
      it "should return a parse representation of the assignment" do
        @result.should_not be_nil
      end
      it "should return an assignment node you shouldn't use" do
        @result.should be_a_kind_of(XenConfigFileYouShouldntUse::ConfigFileNode)
      end
      describe " calling .eval" do
        before(:all) do
          @evaluated_result = @result.eval({})
        end
        it "should return an AST instance of the config file" do
          @evaluated_result.should be_a_kind_of(XenConfigFile::AST::ConfigFile)          
        end
        it "should return the value of the single quoted string as the first element" do
          @evaluated_result[:cpu_environment].first.should == "ey00-s00348"
        end
        it "should return the value of the number as the second element" do
          @evaluated_result[:cpu_environment][1].should == 42
        end
        it "should return the value of the single quoted string as the first element" do
          @evaluated_result[:cpu_environment].last.should == "James Brown"
        end
      end
    end
  end
end