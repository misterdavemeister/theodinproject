def merge_sort(arr)
  c = arr.count
  return arr if c == 1
  half = ((c - 1) / 2)
  first = merge_sort(arr[0..half])
  second = merge_sort(arr[half+1..c-1])
  merged = []
  total = first.count + second.count
  while merged.count < total
    if first[0].nil? && !second[0].nil?
      merged << second.shift
    elsif second[0].nil? && !first[0].nil?
      merged << first.shift
    else
      merged << ( first[0] < second[0] ?  first.shift : second.shift )
    end
  end
  merged
end

puts merge_sort([6, 4, 3, 7, 1, 9, 2, 8, 5, 0, -99, -2005])
