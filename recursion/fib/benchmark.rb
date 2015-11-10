require 'benchmark'
#=> BENCHMARK RESULTS:
=begin
      Mine: 0.16728460000013 seconds
    Theirs: 253.66067249698972 seconds
Difference: Mine is 250.80000000000004 seconds faster
Theirs is 1516.3420452139203 times slower than mine

###### SUMMARY ######
       FIB #: 21
   MY RESULT: 10946
THEIR RESULT: 10946
=end

def fib(n, start = 0, add = 1)
  ### MINE ###
  n == 1 ? add : fib(n - 1, add, start + add)
end

def fib2(n)
  ### THEIRS ###
  if n == 0
    0
  elsif n == 1
    1
  else
    fib2(n-1) + fib2(n-2)
  end
end

TEST_NUM = 21 #fib

print "      Mine: "
mine = Benchmark.measure { 100_000.times { $mine = fib(TEST_NUM)} }
puts "#{mine.real} seconds"

print "    Theirs: "
theirs = Benchmark.measure { 100_000.times {$theirs = fib2(TEST_NUM)} }
puts "#{theirs.real} seconds"

print "Difference: "
diff = theirs.total - mine.total
puts "Mine is #{diff.abs} seconds #{diff > 0 ? "faster" : "slower"}"

if diff > 0
  # mine is faster
  mult = theirs.real / mine.real
  puts "Theirs is #{mult} times slower than mine"
else
  # mine is slower
  mult = mine.real / theirs.real
  puts "Theirs is #{mult} times faster than mine"
end
puts
puts "###### SUMMARY ######"
puts "        FIB #: #{TEST_NUM}"
puts "    MY RESULT: #{$mine}"
puts " THEIR RESULT: #{$theirs}"
