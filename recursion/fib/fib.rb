def fib(n, start = 0, add = 1)
  n == 1 ? add : fib(n - 1, add, start + add)
end 

puts fib(8) #=> 21
puts fib(20) #=> 6765
