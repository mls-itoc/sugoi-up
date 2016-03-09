lines = File.readlines("images/train.txt.org")

count = 0
before_label = nil
buff = ""

lines.each do |l|
  label = l.split(/\s/).last
  if label != before_label
    count = 0
  end
 
  count += 1
 
  if count < 4
    buff << l
  end

  before_label = label
end

puts buff
