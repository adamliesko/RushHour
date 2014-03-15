
UP    = 10
DOWN  = 20
VERTICAL = 100
HORIZONTAL = 99

LEFT  = 30
RIGHT = 40

class Field
  attr_accessor :x,:y,:grid,:direction, :length, :escape,  :letter

  def initialize(letter,direction, length,x,y, escape=false)
    @x = x
    @y = y
    @direction = direction
    @length = length
    @escape =escape
    @letter = letter
  end

  def position
    [@x, @y]
  end

  #najlavejsia horna pozicia
  def setPosition(x,y)
    @x=x
    @y=y
  end





end
