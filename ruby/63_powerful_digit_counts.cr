# TODO: fix. Takes way too much time. Solution is too naive

def count(limit)
  count = 0
  (1..limit).each do |i|
    (1..limit).each do |j|
      if i**j.to_s.size == j
        count+=1
      end
    end
  end
  count
end

puts count(387420489)