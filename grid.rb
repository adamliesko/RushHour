require "./field.rb"

class Grid
  attr_accessor :grid, :fields, :lettersToUse, :width, :height, :parent, :escape_vehicle

  def initialize(width, height)
    @fields = []
    @width = width
    @height = height
    @grid = Array.new(width) { Array.new(height, "  ") }

    @lettersToUse = ('a'..'z').to_a
  end

  def eql?(other)
    self.grid.each_with_index do |row, i|
      return false if !self.grid[i].eql?(other.grid[i])
    end
    true
  end

  def hash
    hash = 0
    @grid.each_with_index { |row, i| hash += row.hash*(10*(i+1)) }
    hash
  end

  # funkcia na vygenerovanie vsetkych moznych stavov po pohyboch , ako mnozina novych krizovatiek
  def generateAllGrids
    grids = []
    @fields.each do |field|
      x, y = field.x, field.y
      case field.type
        when VERTICAL
          if self.canMove?(field, UP)
            up = self.dup
            up.move(x, y, UP)
            up.parent = self
            grids << up
          end
          if self.canMove?(field, DOWN)
            down = self.dup
            down.move(x, y, DOWN)
            down.parent = self
            grids << down
          end
        when HORIZONTAL
          if self.canMove?(field, LEFT)
            left = self.dup
            left.move(x, y, LEFT)
            left.parent = self
            grids << left
          end
          if self.canMove?(field, RIGHT)
            right = self.dup
            right.move(x, y, RIGHT)
            right.parent = self
            grids << right
          end
      end
    end
    grids
  end

  # zistujeme, ci uz sme solvli hlavolam, tj ci moze escape vehicle ujst
  def isFinish?
    x,y = @escape_vehicle.position

    return true if x+@escape_vehicle.length == @width
    (x+@escape_vehicle.length).upto(@width-1) do |z|
      return false if !@grid[z][y].eql?("  ")
    end
    true
  end

  #posun fieldu na x,y o jednu poziciu danym smerom
  def move(x,y, direction)
    # initialize field to something
    field = self.fields[0]
    self.fields.each do |b|
      field = b if b.x == x && b.y == y
    end
    letter = field.letter
    len    = field.length
    case direction
      when UP
        @grid[x][y-1] = "#{letter}#{letter}"
        @grid[x][y+len-1] = "  "
        field.y -= 1
      when DOWN
        @grid[x][y+len] = "#{letter}#{letter}"
        @grid[x][y] = "  "
        field.y += 1
      when LEFT
        @grid[x-1][y] = "#{letter}#{letter}"
        @grid[x+len-1][y] = "  "
        field.x -= 1
      when RIGHT
        @grid[x+len][y] = "#{letter}#{letter}"
        @grid[x][y] = "  "
        field.x += 1
    end
  end
  #pridanie auta na field
  def add(field)
    @fields << field
    letter = @lettersToUse.shift if !field.escape
    if field.escape
      letter = "!"
      @escape_vehicle = field
    end
    field.grid = self
    field.letter = letter

    x,y = field.position
    length = field.length

    case field.type
      when HORIZONTAL
        x.upto(x+length-1) do |w|
          @grid[w][y] = "#{letter}#{letter}"
        end
      when VERTICAL
        y.upto(y+length-1) do |z|
          @grid[x][z] = "#{letter}#{letter}"
        end
    end
  end

  #kontrola ci sa auto na x,y moze pohnut dany smerom
  def canMove?(field, direction)

    x=field.x
    y=field.y
    length=field.length

    case direction

      when UP
        return false if field.type == HORIZONTAL || y == 0
        return @grid[x][y-1].eql?("  ")
      when DOWN
        return false if field.type == HORIZONTAL || y+length == @height
        return @grid[x][y+length].eql?("  ")
      when LEFT
        return false if field.type == VERTICAL || x == 0
        return @grid[x-1][y].eql?("  ")
      when RIGHT
        return false if field.type == VERTICAL || x+length == @width
        return @grid[x+length][y].eql?("  ")
    end
  end

  # vypis krizovatky na plochu
  def print
    puts "X"+( ["XXX"]*width).join()+"X"
    @grid.each_with_index do |row, x|
      #puts "|"+row.join(" ")+" X"
      s = "X"
      row.each_with_index do |el, y|
        s+= @grid[y][x]+" "
      end
      s+="X" if x != self.escape_vehicle.y
      puts s
    end
    puts "X"+( ["XXX"]*width).join()+"X"
  end

  # funkcia na zkopcenie gridu
  def dup
    newgrid = Grid.new(self.width, self.height)
    @fields.each do |b|
      newgrid.add(Field.new(b.letter,b.type, b.length, b.x,b.y,b.escape))
    end
    newgrid.lettersToUse = self.lettersToUse
    newgrid.parent = self.parent
    newgrid
  end

end