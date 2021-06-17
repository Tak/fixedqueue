# This program is free software; you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation; either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
require 'monitor'

# A thread-safe queue of fixed size
module FixedQueue
  class FixedQueue
    include Enumerable
    include MonitorMixin

    attr_reader :size

    # Constructor
    # * size is the size to be used for the queue
    def initialize(size)
      @items = Array.new(size)
      @size = 0
      super()
    end # initialize

    # For enumerable
    def each()
      synchronize {
        @size.times { |i| yield self[i] }
      }
    end # each

    # For enumerable
    def <=>()
      return 0 # no sorting!
    end # <=>

    # Pushes an item onto the front of the queue,
    # and returns the popped item
    # * item is the new item to be added
    def push(item)
      synchronize {
        @size += 1
        @items << item
        result = @items.slice!(0)
        @size -= 1 if result
        result
      }
    end # push

    # Pushes nil onto the front of the queue,
    # and returns the popped item
    def pop()
      synchronize {
        result = @items[-@size]
        @items[-@size] = nil
        @size = [0, @size - 1].max
        result
      }
    end # pop

    # Returns the indexth item in the queue
    # * index is the index of the item to be returned
    def [](index)
      return @items[adjust_index(index)]
    end # []

    # Sets the indexth item in the queue
    # and returns it
    # * index is the index of the item to be set
    # * value is the value to be set
    def []=(index, value)
      return @items[adjust_index(index)] = value
    end # []=

    private

    def adjust_index(raw_index)
      if raw_index < 0
        raise IndexError if raw_index.abs > @size
        raw_index
      else
        raise IndexError if raw_index >= @size
        -@size + raw_index
      end
    end

  end # FixedQueue
end # FixedQueue
