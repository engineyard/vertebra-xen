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
