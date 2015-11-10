def fibs(n, start = 0, add = 1)
  n.times { |num| num == n - 1 ? (return add) : (start, add = add, start + add) }
end

def fibs_rec(n, start = 0, add = 1)
  n == 1 ? add : fibs_rec(n - 1, add, start + add)
end

puts fibs(8) #=> 21
puts fibs(20) #=> 6765

puts fibs_rec(8) #=> 21
puts fibs_rec(20) #=> 6765
