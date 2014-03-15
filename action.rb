require "./field.rb"
class Action
  attr_accessor :letter,:direction, :distance, :tx, :ty

  def initialize(field,direction,distance)
    @direction = direction
    @distance=distance
    @letter = field.letter
    @tx = field.x
    @ty=field.y
  end

  def print
    puts "Car #{letter} moving #{direction} #{distance} field/s onto #{tx}, #{ty}"
  end
end