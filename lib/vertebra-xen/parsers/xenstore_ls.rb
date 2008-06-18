module Xm
  class XenstoreLs
    def initialize
      @file         = nil
      @result_hash  = {}
      @hash_stack   = [ @result_hash ]
      @current_line = nil
      @next_line    = nil
      @key          = nil
      @value        = nil
    end

    def parse(filename)
      @file = File.open(filename)
      while process_current_line do end
      process_current_line until @current_line.nil?
      @result_hash
    ensure
      @file.close
    end

    def process_current_line
      if @current_line.nil? then
        move_to_next_line
      else
        @key   = nil
        @value = nil

        if @current_line =~ /(\w+) = "([^"]*)/ then
          @key   = $1
          @value = $2
        else
          raise "Didn't match key and value"
        end

        if leading_spaces < depth then
          go_up
        elsif next_line_is_deeper? then
          go_down
          move_to_next_line
        elsif leading_spaces == depth then
          stay_here
          move_to_next_line
        else
          raise "Shouldn't happen: #{@current_line}"
        end
      end

      not @next_line.nil?
    end

    def next_line_is_deeper?
      if @next_line.nil?
        false
      else
        leading_spaces < leading_spaces(@next_line)
      end
    end

    def previous_line_is_shallower?
      if @previous_line.nil?
        false
      else
        leading_spaces > leading_spaces(@previous_line)
      end
    end

    def leading_spaces(line = @current_line)
      line =~ /^( *)/
      $1.length
    end

    def go_down
      @hash_stack.last[@key] = { 'parent_value' => @value }
      @hash_stack << @hash_stack.last[@key]
    end

    def stay_here
      @hash_stack.last[@key] = @value
    end

    def go_up
      @hash_stack[depth..-1] = nil
      @hash_stack.last[@key] = @value
    end

    def depth
      @hash_stack.length - 1
    end

    def move_to_next_line
      @current_line = @next_line
      @next_line    = @file.gets
    end
  end
end