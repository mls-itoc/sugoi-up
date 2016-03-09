
lines = File.open("./images/train.txt").readlines
types = lines.map{|l| l.split(/\//)[7]}.uniq
puts types.count



