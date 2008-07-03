require File.dirname(__FILE__) + '/../spec_helper'

require File.dirname(__FILE__) + '/../../lib/xen/visitor'


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

     describe XenConfigFile::AST::Visitor::PrettyPrintVisitor do
       before(:all) do
         @visitor = XenConfigFile::AST::Visitor::PrettyPrintVisitor.new
       end
       it "should be received by the parse results" do
         @result.accept(@visitor).should == "#  -*- mode: python; -*-\nkernel = \"/boot/vmlinuz-2.6.18-xenU\"\nmemory = 712\nmaxmem = 4096\nname = \"ey00-s00348\"\nvif = [ \"bridge=xenbr0\" ]\nroot = \"/dev/sda1 ro\"\nvcpus = 1\ncpu_cap = 100\ndisk = [ \n         \"phy:/dev/ey00-data4/root-s00348,sda1,w\",\n         \"phy:/dev/ey00-data4/swap-s00348,sda2,w\",\n         \"phy:/dev/ey00-data4/gfs-00218,sdb1,w!\",\n         ]\n"
       end
     end
   end
end