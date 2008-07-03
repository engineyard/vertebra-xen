require File.dirname(__FILE__) + '/../spec_helper'

describe XenConfigFileYouShouldntUse::AssignmentNode do
  before(:all) do
    @parser = XenConfigFile::Parser.new
  end
  it "should not be nil" do
    @parser.should_not be_nil
  end
  describe " calling .parse" do
    describe "with a variable assigned to a number" do
      before(:all) do
        @result = @parser.parse("cpu_number = 348\n")
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
        
        it "should return the value of the assignment" do
          @evaluated_result[:cpu_number].should == 348
        end
      end
    end
  end
end