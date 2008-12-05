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

$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib', 'vertebra-xen')
require "test/unit"
require "rubygems"
require "spec"
require "pp"

def fixture(file_name)
  File.read("#{File.dirname(__FILE__)}/fixtures/#{file_name}")
end
