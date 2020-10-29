# rubocop:disable Metrics/ModuleLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength

module Enumerable
  # my_each
  def my_each()
    return to_enum(:my_each) unless block_given?

    size.times do |i|
      yield self[i]
    end
    self
  end

  # my_each_with_index
  def my_each_with_index()
    return to_enum(:my_each_with_index) unless block_given?

    my_each do |i|
      yield i, to_a.index(i)
    end
  end

  # my_map
  def my_map()
    return to_enum(:my_map) unless block_given?

    arr = []
    my_each do |i|
      arr << yield(i)
    end
    arr
  end

  # my_select
  def my_select()
    return to_enum(:my_select) unless block_given?

    arr = []
    my_each do |i|
      if yield(i)
        arr << i if yield(i)
      end
    end
    arr
  end

  # my_any
  def my_any?(arg = nil)
    if block_given?
      my_each do |i|
        if yield(i)
          true
        end
      end
      false

    # if array empty
    elsif size.zero?
      false

    # if all elements are nil or false
    elsif size.positive? && arg.nil?
      nil_count = 0
      my_each do |i|
        if i.nil? || i == false
          nil_count += 1
        end
      end
      if nil_count == size
        false
      else
        true
      end
    # if class
    elsif arg.class == Class
      my_each do |i|
        if i.is_a?(arg)
          true
        end
      end
      false

    # Regexp
    elsif arg.class == Regexp
      my_each do |i|
        index = i =~ arg
        if index.class == Integer
          true
        end
      end
      false
    end
  end

  # my_all
  def my_all?(arg = nil)
    if block_given?
      my_each do |i|
        unless yield(i)
          false
        end
      end
      true

    # if array empty
    elsif size.zero?
      true

    # if one element is nil or false
    elsif include?(nil) || include?(false)
      false

    # if class
    elsif arg.class == Class
      my_each do |i|
        unless i.is_a?(arg)
          false
        end
      end
      true
    # if no block given
    elsif arg.nil?
      my_each do |i|
        if i == false || i.nil?
          false
        end
      end
      true

    # Regexp
    elsif arg.class == Regexp
      my_each do |i|
        index = i =~ arg
        unless index.class == Integer
          false
        end
      end
      true
    end
  end

  # my_none
  def my_none?(arg = nil)
    if block_given?
      my_each do |i|
        if yield(i)
          false
        end
      end
      true

    # if all element is nil or false  or array is empty
    elsif size >= 0 && arg.nil?
      num = 0
      my_each do |i|
        if i.nil? || i == false
          num += 1
        end
      end
      unless num == size
        false
      end
      true

    # if class
    elsif arg.class == Class
      my_each do |i|
        if i.is_a?(arg)
          false
        end
      end
      true

    # Regexp
    elsif arg.class == Regexp
      my_each do |i|
        index = i =~ arg
        if index.class == Integer
          false
        end
      end
      true
    end
  end

  # my_count
  def my_count(arg = nil)
    if block_given?
      num = 0
      my_each do |i|
        if yield(i)
          num += 1
        end
      end
      num

    # no argument given
    elsif arg.nil?
      size
    # argument given
    else
      num = 0
      my_each do |n|
        if n == arg
          num += 1
        end
      end
      num
    end
  end

  # my_inject
  def my_inject(num = nil, arg = nil)
    if block_given?

      # if no number
      if num.nil?
        start = 0
        result = to_a[start]
        while start < size - 1
          result = yield(result, to_a[start + 1])
          start += 1
        end

      # if number given
      else
        result = num
        start = 0
        while start < size
          result = yield(result, to_a[start])
          start += 1
        end
      end
      result
    elsif num.class == Symbol
      sum_sub = 0
      product_div = 1
      if num == :+
        my_each do |n|
          sum_sub += n
        end
        sum_sub

      elsif num == :-
        my_each do |n|
          sum_sub -= n
        end
        sum_sub

      elsif num == :*
        my_each do |n|
          product_div *= n
        end
        product_div

      elsif num == :/
        my_each do |n|
          product_div /= n
        end
        product_div
      end
    elsif arg.class == Symbol
      sum_sub = 0
      product_div = 1
      if arg == :+
        my_each do |n|
          sum_sub += n
        end
        sum_sub + num

      elsif arg == :-
        my_each do |n|
          sum_sub -= n
        end
        sum_sub + num

      elsif arg == :*
        my_each do |n|
          product_div *= n
        end
        product_div * num

      elsif arg == :/
        my_each do |n|
          product_div /= n
        end
        product_div / num
      end

    elsif num.class == Integer
      raise TypeError "#{num} is not a symbol nor a string"
    else
      raise LocalJumpError 'no block given'
    end
  end
end

# rubocop:enable Metrics/ModuleLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength

def multiply_els(arr)
  arr.my_inject(:*)
end

multiply_els([1, 3, 7, 9])


