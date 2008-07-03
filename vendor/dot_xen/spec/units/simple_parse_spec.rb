require File.dirname(__FILE__) + '/../spec_helper'

describe XenConfigFile::Parser, "simple parsing" do
  before(:all) do
    @parser = XenConfigFile::Parser.new
  end
  describe "ey00-s000348.xen as input" do
     before(:all) do
       @result = @parser.simple_parse(File.read(File.dirname(__FILE__)+'/../fixtures/ey00-s00348.xen'))
     end
     it "shouldn't be nil" do
       @result.should_not be_nil
     end
     
     it "should return an AST instance of the config file" do
       @result.should be_a_kind_of(XenConfigFile::AST::ConfigFile)          
     end
   end
end