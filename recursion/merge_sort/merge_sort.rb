def merge_sort(arr)
  c = arr.count - 1
  half = (c / 2)
  return arr if c == 0
  if arr.count > 1
    first = arr[0..half]
    second = arr[half+1..c]
    first = merge_sort(first)
    second = merge_sort(second)
    merged = merge(first, second)
  end
  merged
end

def merge(first, second)
  new_arr = []
  total = first.count + second.count
  while new_arr.count < total
    if first[0].nil? && !second[0].nil?
      new_arr << second.shift
    elsif second[0].nil? && !first[0].nil?
      new_arr << first.shift
    else
      first[0] < second[0] ? new_arr << first.shift : new_arr << second.shift
    end
  end
  new_arr
end

puts merge_sort([4, 3, 7, 1, 9, 2, 8, 5, 6])
