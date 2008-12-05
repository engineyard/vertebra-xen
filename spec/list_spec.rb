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
require 'parsers/xm_list'

describe Xm::ListOutput, "parsing output" do
  before(:all) do
    @parser = Xm::ListOutput.new
  end
  describe "parsing a file" do
    before(:all) do
      @result = @parser.parse(File.read(File.dirname(__FILE__)+'/fixtures/list/ey00n00.xm.list.txt'))
    end
    it "should return an array of entries" do
      @result.should be_a_kind_of(Array)
    end
    it "should have entries that are hashes" do
      @result.each do |line|
        line.should be_a_kind_of(Hash)
      end
    end
    it "should have an element for each xen instance" do
      @result.should have(17).entries
    end
  end
end
