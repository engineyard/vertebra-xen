require File.dirname(__FILE__) + '/../spec_helper'

require File.dirname(__FILE__) + '/../../lib/xen/visitor'


describe XenConfigFile::Parser, "parsing" do
  before(:all) do
    @parser = XenConfigFile::Parser.new
  end
  describe "ey00-s000348.xen as input" do
     before(:all) do
       @result = @parser.parse(File.read(File.dirname(__FILE__)+'/../fixtures/ey02-s00250.xen'))
     end
     it "shouldn't be nil" do
       @result.should_not be_nil
     end
     it "should return a kind of XenConfigFileYouShouldntUse::ConfigFileNode" do
       @result.should be_a_kind_of(XenConfigFileYouShouldntUse::ConfigFileNode)
     end
     
     describe "evaluated output" do
       before(:all) do
         @evaluated_result = @result.eval
       end
       it "should return an AST instance of the config file" do
         @evaluated_result.should be_a_kind_of(XenConfigFile::AST::ConfigFile)          
       end

       describe "to_s" do
         before(:all) do
           @visitor = XenConfigFile::AST::Visitor::PrettyPrintVisitor.new
           @reparser = @parser.parse(@evaluated_result.accept(@visitor))
         end
         it "should not be nil" do
           @reparser.should_not be_nil
         end

         describe "evaluated" do
           before(:all) do
             @revaluated = @reparser.eval({})
           end
           it "should not be nil" do
             @revaluated.should_not be_nil
           end
           it "should have the same kernel" do
             @revaluated[:kernel].should == @evaluated_result[:kernel]
           end
           it "should have the same memory" do
             @revaluated[:memory].should == @evaluated_result[:memory]
           end
           it "should have the same maxmem" do
             @revaluated[:maxmem].should == @evaluated_result[:maxmem]
           end
           it "should have the same vcpus" do
             @revaluated[:vcpus].should == @evaluated_result[:vcpus]
           end
           it "should have the same cpu_cap" do
             @revaluated[:cpu_cap].should == @evaluated_result[:cpu_cap]
           end
           it "should have the same cpu_weight" do
             @revaluated[:cpu_weight].should == @evaluated_result[:cpu_weight]
           end
           it "should have the same name" do
             @revaluated[:name].should == @evaluated_result[:name]
           end
           it "should have the same root" do
             @revaluated[:root].should == @evaluated_result[:root]
           end
           it "should have the same extra" do
             @revaluated[:extra].should == @evaluated_result[:extra]
           end
         end
       end
     end
   end
end