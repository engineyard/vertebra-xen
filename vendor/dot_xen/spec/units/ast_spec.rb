require File.dirname(__FILE__) + '/../spec_helper'

describe XenConfigFile::AST::ConfigFile do
  before(:all) do
    @config = XenConfigFile::AST::ConfigFile.new({:variables => []})
  end
  require File.dirname(__FILE__) + '/../spec_helper'

  describe "[]=" do
    before(:all) do
      @config[:cpu_cap] = 200
    end
    it "should let me fetch the variables i set" do
      @config[:cpu_cap].should == 200
    end
  end
end

describe XenConfigFile::AST::Assignment do
  describe "initialize" do
    before(:all) do
      @ass = XenConfigFile::AST::Assignment.new(:number, 42)
    end
    it "should know its lhs" do
      @ass.lhs.should == :number
    end
    it "should know its rhs" do
      @ass.rhs.should == 42
    end
  end
end

describe XenConfigFile::AST::ArrayAssignment do
  describe "initialize" do
    before(:all) do
      @ass = XenConfigFile::AST::ArrayAssignment.new(:number, [42, 'forty-two', 666])
    end
    it "should know its lhs" do
      @ass.lhs.should == :number
    end
    it "should know its rhs" do
      @ass.rhs.should == [42, 'forty-two', 666]
    end
  end
end

describe XenConfigFile::AST::LiteralString do
  describe "initialize" do
    before(:all) do
      @str = XenConfigFile::AST::LiteralString.new('foo')
    end
  end
end

describe XenConfigFile::AST::Disk do
  describe "initialize" do
    before(:all) do
      @disk = XenConfigFile::AST::Disk.new('phy:/dev/ey00-data4/root-s00348', 'sda1', 'w')
    end
    it "should create successfully" do
      @disk.should_not be_nil
    end
    it "should assign the volume" do
      @disk.volume.should == 'phy:/dev/ey00-data4/root-s00348'
    end
    it "should assign the device" do
      @disk.device.should == 'sda1'
    end
    it "should assign the mode" do
      @disk.mode.should == 'w'
    end
  end
  
  describe "build" do
    before(:all) do
      @params = ["phy:/dev/ey00-data4/root-s00348,sda1,w", "phy:/dev/ey00-data4/swap-s00348,sda2,w", "phy:/dev/ey00-data4/gfs-00218,sdb1,w!"]
      @disks = XenConfigFile::AST::Disk.build({:variables => [XenConfigFile::AST::ArrayAssignment.new(:disk, @params)]})
    end
    it "should build successfully" do
      @disks.should_not be_nil
    end
    it "should have three elements" do
      @disks.should have(3).entries
    end
  end
end