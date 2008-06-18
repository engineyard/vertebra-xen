module Xm
  class ListOutput
    attr_reader :filename

    def parse(text)
      @results = [ ]
      text.each_line do |line|
        next if line =~ /^Name/
        name, sliceid, mem, vcpus, state, times = line.split(/\s+/)
        @results << {:name => name, :id => sliceid.to_i, :mem => mem.to_i, :vcpus => vcpus.to_i, :state => state, :times => times}
      end
      @results
    end
  end
end