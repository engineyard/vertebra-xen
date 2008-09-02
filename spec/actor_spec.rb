require File.dirname(__FILE__) + '/spec_helper'
require 'actor'

class Vertebra::Actor
  def spawn(*args, &block)
    out = File.read(File.dirname(__FILE__) + "/fixtures/#{args[0]+args[1]}.txt")
    out = yield(out) if block_given?
    {:result => out}
  end
end

describe VertebraXen::Actor do
  it "should copy to backup and update original config file with a memory setting" do
    xen_root = File.dirname(__FILE__) + "/fixtures"
    options = {'memory' => 1024, 'xen_root' => xen_root, 'slice' => 'ey00-s00348'}
    @actor = VertebraXen::Actor.new(options)
    @actor.set_slice_values(options)
    File.exists?(xen_root + "/.ey00-s00348.xen.bak").should == true
    @next_actor = VertebraXen::Actor.new(options)
    conf = XenConfigFile::Parser.new.parse(File.read(File.dirname(__FILE__)+'/fixtures/ey00-s00348.xen')).eval    
    conf[:memory].value.should == 1024
    FileUtils.cp(xen_root+"/.ey00-s00348.xen.bak", xen_root+"/ey00-s00348.xen")
  end

  it "should list running slices" do
#    mock.instance_of(Xm::ListOutput).parse
  end
end