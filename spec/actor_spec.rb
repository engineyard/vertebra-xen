require File.dirname(__FILE__) + '/spec_helper'
require 'actor'

describe Xm::ListOutput, "parsing output" do
  it "should copy to backup and update original config file with a memory setting" do
    xen_root = File.dirname(__FILE__) + "/fixtures"
    options = {'memory' => 1024, 'xen_root' => xen_root, 'slice' => 'ey00-s00348'}
    @actor = VertebraXen::Actor::Xen.new(options)
    @actor.set_slice_values(options)
    File.exists?(xen_root + "/.ey00-s00348.xen.bak").should == true
  end

end