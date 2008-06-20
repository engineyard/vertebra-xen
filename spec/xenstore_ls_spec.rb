require File.dirname(__FILE__) + '/spec_helper'
require 'parsers/xenstore_ls'

describe Xm::XenstoreLs, "parses the output from 'xenstore-ls' on a node" do
  before(:all) do
    @parser = Xm::XenstoreLs.new
  end

  describe "parse a file" do
    before(:all) do
      @result = @parser.parse(File.dirname(__FILE__)+'/fixtures/xenstore-ls/xenstore_ls_output.txt')
    end
    it "should return a result" do
      @result.should_not be_nil
    end
    it "should return a hash representation" do
      @result.should be_a_kind_of(Hash)
    end
  end
end