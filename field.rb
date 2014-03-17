#konstanty na smery
UP = 10
LEFT = 30
DOWN = 20
VERTICAL = 100
HORIZONTAL = 99
RIGHT = 40

#trieda ktora modeluje auto na krizovatke, ma svoj smer, dlzku, pismeno, poziciu a poznamku ci je escape vehicle
class Field
  attr_accessor :x, :y, :direction, :length, :escape, :letter

  def initialize(letter, direction, length, x, y, escape=false)
  @x = x
    @y = y
    @direction = direction
    @length = length
    @escape =escape
    @letter = letter
  end

end
