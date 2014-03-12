VERTICAL = 0
HORIZONTAL = 1

UP    = 0
DOWN  = 1
LEFT  = 2
RIGHT = 3

class Field
  attr_accessor :x,:y,:grid,:type, :length, :escape,  :letter

  def initialize(letter,direction, length,x,y, escape=false)

    @x = x
    @y = y
    @type = direction
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
