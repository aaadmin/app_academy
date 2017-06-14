require 'byebug'

def binarify(base_ten_num)
  base_ten_num.to_s(2)
end

# p binarify(3)

def base_tenify(base_two_num)
  base_two_num.to_i(2)
end

def binary_ones_count(base_ten_num)
  binarify(base_ten_num).count('1')
end

def factorial(n)
  (1..n).inject(:*) || 1
end

def binary_order_of_magnitude(num)
  binarify(num).chars.count - 1
end

def is_perfect_bit?(base_ten_num)
  is_perfect_square?(binary_ones_count(base_ten_num))
end

def next_perfect_bit(base_ten_num)
  return 1 if base_ten_num < 1
  Math.sqrt(base_ten_num) % 1 == 0 ? next_perfect_bit(base_ten_num + 1) : Math.sqrt(base_ten_num).ceil**2
end

def is_perfect_square?(num)
  return false if num < 1
  Math.sqrt(num) % 1 == 0
end

def next_perfect_square(num)
  return 1 if num < 1
  is_perfect_square?(num) ? next_perfect_square(num + 1) : Math.sqrt(num).ceil**2
end

def next_binary_base(base_ten_num)
  2**(binary_order_of_magnitude(base_ten_num) + 1)
end

def prev_binary_base(base_ten_num)
  2**(binary_order_of_magnitude(base_ten_num))
end

def is_binary_base?(num)
  binarify(num).count('1') == 1
end


def initial_base_ten_binary_base_in_range(num1, num2)
  return num1 if is_binary_base?(num1)
  next_base = next_binary_base(num1)
  return next_base if next_base <= num2
  nil
end

def final_base_ten_binary_base_in_range(num1, num2)
  return num2 if is_binary_base?(num2)
  prev_base = prev_binary_base(num2)
  return prev_base if prev_base >= num1
  nil
end

#how many 3-digit unique permutation sets exist with n possible nums
def uniq_permutations_count(slots_count, nums_count)
  # debugger
  uniq_perms_count = factorial(nums_count)/factorial(nums_count - slots_count)

  #uniq perm sets
  uniq_perms_count/factorial(slots_count)
end

def uniq_permutations_count_w_set_ones_and_zeroes(slots_count, ones_count, zeroes_count)
  factorial(slots_count)/(factorial(ones_count) * factorial(zeroes_count))
end

def count_perms_fully_in_noninclusive_range(num1, num2)
  min_binary_o_of_mag = binary_order_of_magnitude(initial_base_ten_binary_base_in_range(num1, num2))
  max_binary_o_of_mag = binary_order_of_magnitude(final_base_ten_binary_base_in_range(num1, num2))

  count = 0

  current_sq = 1
  current_o_of_mag = min_binary_o_of_mag

  while current_o_of_mag < max_binary_o_of_mag
    count += uniq_permutations_count((current_sq - 1), current_o_of_mag)

    next_sq = next_perfect_square(current_sq)
# debugger
    if next_sq > max_binary_o_of_mag
      current_o_of_mag += 1
      current_sq = 1
    else
      current_sq = next_sq
    end
  end
  count
end

# p '---'
# p count_perms_fully_in_noninclusive_range(2,16) == 4
# p count_perms_fully_in_noninclusive_range(2,17) == 4
# p '---'
# p count_perms_fully_in_noninclusive_range(4,16) == 3
# p count_perms_fully_in_noninclusive_range(3,17) == 3
# p count_perms_fully_in_noninclusive_range(3,31) == 3
#
# p '---'
# p count_perms_fully_in_noninclusive_range(10,67) == 16
# p count_perms_fully_in_noninclusive_range(16,64) == 16
#
# p '---'
# p count_perms_fully_in_noninclusive_range(3,70) == 19
# p count_perms_fully_in_noninclusive_range(4,64) == 19
#
# p '---'
# p count_perms_fully_in_noninclusive_range(32,64) == 11
# p count_perms_fully_in_noninclusive_range(32,65) == 11
# p '---'
# p count_perms_fully_in_noninclusive_range(32, 1152921504606846976)


def remaining_uniq_permutations_count(base_ten_num)
  base_two_num = binarify(base_ten_num)
# debugger
  # snip off initial ones
  broken_set = base_two_num.slice((base_two_num.index('0'))..base_two_num.length)

  #snip off next initial zeroes
  broken_set = broken_set.slice(1..broken_set.length)

  #snip off any remaining initial ones
  broken_set = broken_set.slice((base_two_num.index('0') + 1)..broken_set.length)# if base_two_num.index('0') && broken_set[base_two_num.index('0') + 1]

  #find all uniq perms of what remains
  broken_set_perm_count = uniq_permutations_count_w_set_ones_and_zeroes(broken_set.length, (broken_set.count('1') - 1), (broken_set.count('0') + 1))

  full_set = base_two_num.slice((base_two_num.index('0') + 1)..base_two_num.length)
  full_set_perm_count = uniq_permutations_count_w_set_ones_and_zeroes(full_set.length, (full_set.count('1') - 1), (full_set.count('0') + 1))
  broken_set_perm_count + full_set_perm_count + 1
end

p remaining_uniq_permutations_count(53) == 5
p remaining_uniq_permutations_count(43) == 9

def count_perms_in_initial_range(num1, num2)

  #jump to the first perfect bit
  num1 = is_perfect_bit?(num1) ? num1 : next_perfect_bit(num1)

  current_sq = binarify(num1).count('1')
  current_o_of_mag = binary_order_of_magnitude(num1)

  count = remaining_uniq_permutations_count(num1)
  # num1 is in the middle of a permutation set
  # num2 is the end, which should be non_inclusive

  next_sq = next_perfect_square(current_sq)
  max_binary_o_of_mag_of_initial_range = binary_order_of_magnitude(initial_base_ten_binary_base_in_range(num1, num2))

  if next_sq > max_binary_o_of_mag_of_initial_range
    current_o_of_mag += 1
    current_sq = 1
  else
    current_sq = next_sq
  end

  while current_o_of_mag < max_binary_o_of_mag_of_initial_range
    count += uniq_permutations_count((current_sq - 1), current_o_of_mag)
    next_sq = next_perfect_square(current_sq)

    if next_sq > max_binary_o_of_mag_of_initial_range
      current_o_of_mag += 1
      current_sq = 1
    else
      current_sq = next_sq
    end
  end
  count
end

p count_perms_in_initial_range(33, 130)
p count_perms_in_initial_range(10,33)
p count_perms_fully_in_noninclusive_range(10,33)

def count_perms_in_final_range(num1, num2)#with (10, 30)
  initial_num_in_final_range = final_base_ten_binary_base_in_range(num1, num2) # 32
  final_num_in_final_range = num2 # 33
  next_binary_base_beyond_range = next_binary_base(num2) # 64

  count = 0
# debugger
  #count number of perms that would exist if the range end was actually the next binary base
  count += count_perms_fully_in_noninclusive_range(initial_num_in_final_range, next_binary_base_beyond_range)
# 11
  #subtract perms in initial range of that
  count -= count_perms_in_initial_range(final_num_in_final_range, next_binary_base_beyond_range)
  #  12 s/b 10
  count
end

p count_perms_in_final_range(10,33)

def perfect_bits(num1, num2)
  count = 0

  if binary_order_of_magnitude(num1) == binary_order_of_magnitude(num2)
    prev_binary_base_before_range = prev_binary_base(num1)
    next_binary_base_beyond_range = next_binary_base(num2)

    #get count for full range
    count += count_perms_fully_in_noninclusive_range(prev_binary_base_before_range, next_binary_base_beyond_range)

    #subtract initial chunk before num1
    count -= count_perms_in_initial_range(prev_binary_base_before_range, num1)

    #subtract final chunk beyond num2
    count -= count_perms_in_final_range(num2, next_binary_base_beyond_range)
  else
    count += count_perms_in_initial_range(num1, num2)
    count += count_perms_fully_in_noninclusive_range(num1, num2)
    count += count_perms_in_final_range(num1, num2)
  end
  
  count
end

# p perfect_bits(10, 33)#==7
# p perfect_bits(200, 300)#==29
# p perfect_bits(200, 30000)#==5669
