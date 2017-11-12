# Project Euler Problem 61 - Cyclical figurate numbers
# Triangle, square, pentagonal, hexagonal, heptagonal, and octagonal
# numbers are all figurate (polygonal) numbers and are generated by
# the following formulae:

# Triangle	 	P3,n=n(n+1)/2	 	1, 3, 6, 10, 15, ...
# Square	 	  P4,n=n2	 	1, 4, 9, 16, 25, ...
# Pentagonal	P5,n=n(3n−1)/2	 	1, 5, 12, 22, 35, ...
# Hexagonal	 	P6,n=n(2n−1)	 	1, 6, 15, 28, 45, ...
# Heptagonal	P7,n=n(5n−3)/2	 	1, 7, 18, 34, 55, ...
# Octagonal	 	P8,n=n(3n−2)	 	1, 8, 21, 40, 65, ...

# The ordered set of three 4-digit numbers: 8128, 2882, 8281, has three
# interesting properties.

# 1. The set is cyclic, in that the last two digits of each number is the first
# two digits of the next number (including the last number with the first).

# 2. Each polygonal type: triangle (P3,127=8128), square (P4,91=8281), and
# pentagonal (P5,44=2882), is represented by a different number in the set.

# 3. This is the only set of 4-digit numbers with this property.

# Find the sum of the only ordered set of six cyclic 4-digit numbers for which
# each polygonal type: triangle, square, pentagonal, hexagonal, heptagonal, and
# octagonal, is represented by a different number in the set.

# I *think* I've implemented a Depth-first search here? First, create a master list
# containing all 4 digit "special" numbers of the various types. Remove duplicates and
# all numbers with a 3rd digit zero. For each number, explore a tree down to the 6th
# number in a cycle. If the last 2 digits of the 6th number == the first two of the 
# root number, then verify the 6 numbers have one number of every "special" type. 
# Otherwise, go back up one number, and down again for the next possibility, etc.

# user     system      total        real
# 28684
# 13.390000   0.020000  13.410000 ( 13.426716)

# 28684
# 13.257978 seconds

# Methods which check if a number is of the eponymous type
def triangle?(t)
  a = ->(k) { Math.sqrt((k * 2) - 1).floor }
  tn = ->(l) { a[l] * (a[l] + 1) / 2 }
  tn[t] == t
end

def pentagon?(p)
  b = ->(k) { Math.sqrt((2 * k + 1) / 3).ceil }
  pn = ->(l) { b[l] * (3 * b[l] - 1) / 2 }
  pn[p] == p
end

def hexagon?(h)
  c = ->(k) { Math.sqrt((k + 1) / 2).ceil }
  hn = ->(l) { c[l] * (2 * c[l] - 1) }
  hn[h] == h
end

def square?(n)
  Math.sqrt(n).floor**2 == n
end

def heptagon?(o)
  d = ->(k) { Math.sqrt((2 * k + 3) / 5).ceil }
  on = ->(l) { d[l] * (5 * d[l] - 3) / 2 }
  on[o] == o
end

def octagon?(h)
  e = ->(k) { Math.sqrt((k + 2) / 3).ceil }
  gn = ->(l) { e[l] * (3 * e[l] - 2) }
  gn[h] == h
end

time = Time.now
at_exit { puts (Time.now - time).to_s + ' seconds' }

# Builds a master array of all 4 digit special numbers, then removes
# duplicates and any number with a 0 in the third digit
master =
  [
    (1000..9999).select { |x| hexagon?(x) },
    (1000..9999).select { |x| triangle?(x) },
    (1000..9999).select { |x| pentagon?(x) },
    (1000..9999).select { |x| square?(x) },
    (1000..9999).select { |x| heptagon?(x) },
    (1000..9999).select { |x| octagon?(x) }
  ].flatten.uniq.delete_if { |x| x.to_s[2] == '0' }

# Duplicate an array. If array contains a special number,
# delete that number, then move on to the next special number.
# If duplicate array is empty at the end, then the array contains
# all six special numbers
def verify_answer(array)
  d = array.dup
  d.any? { |t| d.delete(t) if hexagon?(t) }
  d.any? { |t| d.delete(t) if pentagon?(t) }
  d.any? { |t| d.delete(t) if triangle?(t) }
  d.any? { |t| d.delete(t) if heptagon?(t) }
  d.any? { |t| d.delete(t) if square?(t) }
  d.any? { |t| d.delete(t) if octagon?(t) }
  return true if d.empty?
  false
end

# Main search algorithm
f_all = ->(digs) { master.find_all { |x| x.to_s.split(//).shift(2).join.to_i == digs } }
master.each do |first|
  k = first.to_s.split(//).shift(2).join.to_i
  temp = f_all[first % 100]
  temp.each do |second|
    stemp = f_all[second % 100]
    stemp.each do |third|
      ttemp = f_all[third % 100]
      ttemp.each do |fourth|
        otemp = f_all[fourth % 100]
        otemp.each do |fifth|
          ltemp = f_all[fifth % 100]
          ltemp.each do
            f_all[fifth % 100].each do |candidate|
              if candidate % 100 == k
                temp = [first, second, third, fourth, fifth, candidate]
                temp.uniq!
                if verify_answer(temp) && temp.size > 5
                  puts [first, second, third, fourth, fifth, candidate].sum
                  exit
                end
              end
            end
          end
        end
      end
    end
  end
end
