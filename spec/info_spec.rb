# Copyright 2008, Engine Yard, Inc.
#
# This file is part of Vertebra.
#
# Vertebra is free software: you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# Vertebra is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Vertebra.  If not, see <http://www.gnu.org/licenses/>.

require File.dirname(__FILE__) + '/spec_helper'
require 'parsers/xm_info'

describe Xm::InfoOutput, "blah" do
  before(:all) do
    @parser = Xm::InfoOutput.new
  end
  
  describe "parsing a file" do
    before(:all) do
      @result = @parser.parse(File.read(File.dirname(__FILE__)+'/fixtures/info/ey00n00.xm.info.txt'))
    end
    it "should return a YAML hash" do
      @result.should be_a_kind_of(Hash)
    end
    it "should return the host name" do
      @result['host'].should eql('ey00-00')
    end
    it "should return the free memory" do
      @result['free_memory'].should eql(4773)
    end
    it "should return the total memory" do
      @result['total_memory'].should eql(16319)
    end
  end
  
end
