(1..1000).inject { |sum, i| sum + i**i } % 10000000000
# => 9110846700