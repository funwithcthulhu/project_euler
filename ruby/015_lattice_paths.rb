# Project Euler Problem 15
# Starting in the top left corner of a 2×2 grid, and only
# being able to move to the right and down, there are exactly
# 6 routes to the bottom right corner.
# 
# https://projecteuler.net/project/images/p015.gif
# 
# How many such routes are there through a 20×20 grid?
#
# Ruby, using a multiplicative formula to compute the
# value of a binomial coefficient


def find_path(grid_size)
  paths = 1
  grid_size.times do |i|
    paths *= (2 * grid_size) - i
    paths /= i + 1
  end
  paths
end

# irb(main):018:0> findpaths(20)
# => 137846528820