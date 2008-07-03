require File.dirname(__FILE__) + '/../spec_helper'

if ENV['DO_EM_ALL']
  describe XenConfigFile::Parser, " simple_parsing " do
    before(:all) { @parser = XenConfigFile::Parser.new }
    
    Dir["#{ENV['EY_FILES'] || File.expand_path(File.dirname(__FILE__)+'/../../../scrapetacular')}/xen/*/*/*.xen"].each_with_index do |input_file, idx|
      describe "#{input_file} as input" do
        before(:all) { @result = @parser.simple_parse(File.read(input_file)) }
        if(idx % 25)
          after(:all) { GC.enable }
        else
          after(:all) { GC.disable }
        end

        it "shouldn't be nil" do
          @result.should_not be_nil
        end
        it "should return an AST instance of the config file" do
          @result.should be_a_kind_of(XenConfigFile::AST::ConfigFile)          
        end

        describe "generation " do
          before(:all) do
            @visitor = XenConfigFile::AST::Visitor::PrettyPrintVisitor.new
            @reparser = @parser.simple_parse(@result.accept(@visitor))
          end
          
          it "should generate matching content" do
            @reparser.accept(@visitor).should == @result.accept(@visitor)
          end
        end
      end
    end
  end
end