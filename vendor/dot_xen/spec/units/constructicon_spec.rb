require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../lib/xen/visitor'

describe XenConfigFile::AST::ConfigFile do
  before(:all) do
    @config = XenConfigFile::AST::ConfigFile.new({:variables => []})
  end
  
  describe "[]=" do
    before(:all) do
      @config[:kernel] = '/boot/vmlinuz-2.6.18-xenU'
      @config[:memory] = 2048
      @config[:maxmem] = 8192
      @config[:vcpus]  = 2
      @config[:cpu_cap] = 200
      @config[:cpu_weight] = 256
      @config[:name] = 'ey02-s00250'
      @config[:vif] = [
        'script=vif-eyroute,ip=10.2.64.251 10.2.192.251',
        'script=vif-bridge,bridge=clusterbr0'
      ]
      @config[:disk] = [
              'phy:/dev/ey02-dedicated02/root-s00250,sda1,w',
              'phy:/dev/ey02-dedicated02/swap-s00250,sda2,w',
              'phy:/dev/ey02-dedicated02/indexes-s00250,sda3,w',
              'phy:/dev/ey02-dedicated02/gfs-00155,sdb1,w!'
      ]
      @config[:root] = "/dev/sda1"
      @config[:extra] = "ro"
    end

    describe "generating" do
      before(:all) do
        @visitor = XenConfigFile::AST::Visitor::PrettyPrintVisitor.new
      end
      it "should generate a config" do
        @config.accept(@visitor).should == "\nkernel = \"/boot/vmlinuz-2.6.18-xenU\"\nmemory = 2048\nmaxmem = 8192\nvcpus = 2\ncpu_cap = 200\ncpu_weight = 256\nname = \"ey02-s00250\"\nvif = [ \n        \"script=vif-eyroute,ip=10.2.64.251 10.2.192.251\",\n        \"script=vif-bridge,bridge=clusterbr0\",\n        ]\ndisk = [ \n         \"phy:/dev/ey02-dedicated02/root-s00250,sda1,w\",\n         \"phy:/dev/ey02-dedicated02/swap-s00250,sda2,w\",\n         \"phy:/dev/ey02-dedicated02/indexes-s00250,sda3,w\",\n         \"phy:/dev/ey02-dedicated02/gfs-00155,sdb1,w!\",\n         ]\nroot = \"/dev/sda1\"\nextra = \"ro\"\n"
      end
    end
  end
end