# RUBY CODE?


class MyRational

  def initialize(num, den=1)
    if den == 0
      raise "MyRational received an inappropriate argument"
    elsif den < 0
      @num = - num
      @den = - den
    else
      @num = num
      @den = den
    end
    reduce # i.e., self.reduce() but it's private
  end

  def to_s
    ans = @num.to_s
    if @den != 1
      ans += "/"
      ans += @den.to_s
    end
    ans
  end

  def add! r   # mutate self in place
    a = r.num  # works b/c of protected methods below
    b = r.den  # works b/c of protected methods below
    c = @num
    d = @den
    @num = (a * d) + (b * c)
    @den = b * d
    reduce
    self # convenient for stringing calls
  end

  def + r
    ans = MyRational.new(@num,@den)
    ans.add! r
    ans
  end
end


# Duck Typing

def mirror_update pt
  pt.x = pt.x * (-1)
end


# Natural thought: "Takes a point object and negates the x value"

# Closer: "Takes anything with getter and setter methods for @x and
# multiplies the x field by -1"

# Closer: "Takes anything with methods x= and x and calls x= with
# the result of multiplying result of x and -1"

# Duck typing: "Takes anything with method x= and x where result
# of x has a * method that can take -1. Sends result of calling x
# the * message with -1 and sends that result to x="


# Blocks

a = Array.new(5) {|i| 4*(i + 1)}
a.each {|x| puts (x * 2)}

a.any? {|x| x > 7}
a.all? {|x| x > 7}


def t(i)
  (0..i).each do |j|
    print "  " * j
    (j..i).each {|k| print k; print " "}
    print "\n"
  end
end


# Functions that take blocks

def silly a 
  if block_given?
    (yield a) + (yield 42)
  else
    a
  end
end

puts(silly(5){ |b| b*2 })
puts(silly(5))


# Subclassing

class Point
  attr_accessor :x, :y # defines methods x, y, x=, y=

  def initialize(a, b)
    @x = a
    @y = b
  end
  def distFromOrigin
    Math.sqrt(@x * @x + @y * @y) # uses instance variables
  end
  def distFromOrigin2
    Math.sqrt(x * x + y * y) # uses getter methods
  end

end

class ColorPoint < Point
  attr_accessor :color # defines color, color=

  def initialize(x, y, c="clear")
    super(x, y) # supercall
    @color = c
  end
end
