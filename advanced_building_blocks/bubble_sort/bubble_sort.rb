#!/usr/bin/env ruby

def bubble_sort(arr)
    unsorted = true; count = 0; 
    while unsorted
        unsorted = false
        sorted = arr.length - count;
        arr.each_with_index do |n, i|
            if i != arr.length - 1 && i != sorted
                if arr[i] > arr[i+1] 
                    arr[i], arr[i+1] = arr[i+1], arr[i]
                    unsorted = true
                end
            end
        end
        count += 1
    end
    arr
end

bubble_sort([4,3,78,2,0,2]) #=> [0, 2, 2, 3, 4, 78]