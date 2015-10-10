#!/usr/bin/env ruby

module Enumerable
  def my_each
    for i in (0...self.length)
      yield(self[i])
    end
    self
  end
  
  def my_each_with_index
    for i in (0...self.length)
      yield(self[i], i)
    end
    self
  end
  
  def my_select
    new_arr = Array.new
    self.my_each { |n| new_arr << n if yield(n) }
    new_arr
  end
  
  def my_all?
    self.my_each do |n| 
      answer = yield(n)
      return false if answer == false
    end
    true
  end
  
  def my_any?
    self.my_each do |n|
      answer = yield(n)
      return true if answer == true
    end
    false
  end
  
  def my_none?
    self.my_each do |n|
      answer = yield(n)
      return false if answer == true
    end
    return true
  end
  
  def my_count
    count = 0
    self.my_each {count += 1}
    count
  end
  
  def my_map(code=nil, &block)
    new_arr = Array.new
    if block_given? && code == nil
      self.my_each { |n| puts "Block given"; new_arr << block.call(n) }
    elsif block_given? && code != nil
      self.my_each { |n| puts "Block AND proc given"; new_arr << block.call(n)}
    else
      self.my_each { |n| puts "Proc given"; new_arr << code.call(n) }
    end
    new_arr
  end
  
  def my_inject(start=nil)
    if start
      self.my_each { |n| start = yield(start, n)}
    else
      self.my_each_with_index do |n, i| 
        if i == 0
          start = self[i]
          next
        end
        start = yield(start, n) 
      end
    end
    start
  end
  
end

def multiply_els(arr)
  arr.my_inject {|start, n| start * n}
end


# TESTS #

puts "^ Results of my_each. My_each returns =                            #{[1,2,3].my_each { |n| puts n + 1 }}"
puts "^ Results of Ruby each. Ruby each returns =                        #{[1,2,3].each { |n| puts n + 1 }}"
puts "--------------------------------------------------------------------------------------\n\n"

# MY_EACH_WITH_INDEX #
puts "^ Results of my_each_with_index. My_each_with_index returns =      #{
[1,2,3].my_each_with_index do |n, i| 
  puts "#{n} is at index #{i}" 
end}\n"
puts "^ Results of Ruby each_with_index. Ruby each_with_index returns =  #{
[1,2,3].each_with_index do |n, i| 
  puts "#{n} is at index #{i}" 
end}\n"
puts "--------------------------------------------------------------------------------------\n\n"

# MY_SELECT #
puts "^ Results of my_select. My_select returns =                        #{[1,2,3,4,5,6,7,8,9].my_select { |n| n % 2 == 1 }}"
puts "^ Results of Ruby select. Ruby select returns =                    #{[1,2,3,4,5,6,7,8,9].select { |n| n % 2 == 1 }}"
puts "--------------------------------------------------------------------------------------\n\n"

# MY_ALL? #
puts "^ Results of my_all?. My_all? returns =                            #{[1,2,3].my_all? { |n| n > 0 }}"
puts "^ Results of Ruby all?. Ruby all? returns =                        #{[1,2,3].all? { |n| n > 0 }}"
puts "--------------------------------------------------------------------------------------\n\n"

# MY_ANY? #
puts "^ Results of my_any?. My_any? returns =                            #{[1,2,3].my_any? { |n| n > 3 }}"
puts "^ Results of Ruby any?. Ruby any? returns =                        #{[1,2,3].any? { |n| n > 3 }}"
puts "--------------------------------------------------------------------------------------\n\n"

# MY_NONE? #
puts "^ Results of my_none?. My_none? returns =                          #{[1,2,3].my_none? { |n| n > 0 }}"
puts "^ Results of Ruby none?. Ruby none? returns =                      #{[1,2,3].none? { |n| n > 0 }}"
puts "--------------------------------------------------------------------------------------\n\n"

# MY_COUNT #
puts "^ Results of my_count. My_count returns =                          #{[1,2,3].my_count}"
puts "^ Results of Ruby count. Ruby count returns =                      #{[1,2,3].count}"
puts "--------------------------------------------------------------------------------------\n\n"

# MY_MAP #
=begin 
Modify your #my_map method to take a proc instead.
Modify your #my_map method to take either a proc or a block, executing the block only if both are supplied (in which case it would execute both the block AND the proc).
=end
puts "^ Results of my_map. My_map returns =                              #{[1,2,3].my_map { |n| n + 1 }}"
puts "^ Results of Ruby map. Ruby map returns =                          #{[1,2,3].map { |n| n + 1 }}"
proc = Proc.new { |n| n + 1 }
puts "***WITH PROC***^ Results of my_map. My_map returns =               #{[1,2,3].my_map(proc)}"
puts "^ Results of Ruby map. Ruby map returns =                          #{[1,2,3].map { |n| n + 1 }}"
puts "***WITH PROC AND BLOCK***^ Results of my_map. My_map returns =     #{[1,2,3].my_map(proc) {|n| n + 1}}"
puts "^ Results of Ruby map. Ruby map returns =                          #{[1,2,3].map { |n| n + 1 }}"
puts "--------------------------------------------------------------------------------------\n\n"


# MY_INJECT #
=begin
Test your #my_inject by creating a method called #multiply_els which multiplies all the elements of the array together by using #my_inject, e.g. multiply_els([2,4,5]) #=> 40
=end

puts "^ Results of my_inject. My_inject returns =                        #{[1,2,3,4,5,6].my_inject(0) { |n, n2| n + n2 }}"
puts "^ Results of Ruby inject. Ruby inject returns =                    #{[1,2,3,4,5,6].inject(0) { |n, n2| n + n2 }}"
puts "multiply_els([2,4,5]) returns =                                    #{multiply_els([2,4,5])}"
puts "--------------------------------------------------------------------------------------\n\n"

