require "./field.rb"
require "./action.rb"


class Grid
  attr_accessor :grid, :fields,  :width, :height, :parent, :escape_vehicle, :action

  def initialize(width, height)
    @fields = []
    @width = width
    @height = height
    @grid = Array.new(width) { Array.new(height, ".") }
    @action = nil
  end

  def eql?(other)
    self.grid.each_with_index do |row, i|
      return false if !self.grid[i].eql?(other.grid[i])
    end
    true
  end

  # funkcia na vygenerovanie vsetkych moznych stavov po pohyboch , ako mnozina novych krizovatiek
  def generateAllGrids
    grids = []
    puts 'GENERATING'
    self.fields.each do |field|
      (1..5).each do |distance|
        x, y = field.x, field.y
        case field.direction
          when VERTICAL
            if self.canMove?(field, UP,distance)
              u = duplicateGrid(self)
              #puts 'up'
              #self.print
              u.move(field,UP,distance)
              u.parent = self
              u.action.print
              #u.print
              grids.push(u)
            end
            if self.canMove?(field, DOWN,distance)
              #puts 'down'
              #self.print
              d = duplicateGrid(self)
              d.move(field, DOWN,distance)
              d.parent = self
              d.action.print
              #d.print
              grids.push(d)
            end
          when HORIZONTAL
            if self.canMove?(field, LEFT,distance)
             # puts 'left'
              #self.print
              l = duplicateGrid(self)
              l.move(field, LEFT,distance)
              l.action.print
              #l.print
              l.parent = self
              grids.push(l)
            end
            if self.canMove?(field, RIGHT,distance)
              #puts 'right'
              #self.print
              r = duplicateGrid(self)
              r.move(field, RIGHT,distance)
              r.parent = self
              r.action.print
              #r.print
              grids.push(r)
            end
        end
      end
    end
    #puts 'GENERATING ENDS'
    grids
  end

  # zistujeme, ci uz sme solvli hlavolam, tj ci moze escape vehicle ujst
  def isFinish?
    x,y = @escape_vehicle.position
    return true if x+@escape_vehicle.length == @width
    (x+@escape_vehicle.length).upto(@width-1) do |z|
      return false if not @grid[z][y].eql?(".")
    end
    true
  end

  #posun fieldu na x,y o jednu poziciu danym smerom
  def move(orig_field ,direction,distance)
    field = Field.new(1,2,3,4,5)
    @fields.each do |f|
      if f.x == orig_field.x && orig_field.y == orig_field.y
        field = f
      end
    end

    x=field.x
    y=field.y
    letter = field.letter
    len    = field.length
    case direction
      when UP

        direction='up'
        (0..len-1).each do |i|
          @grid[x][y+i] = "."
        end
        (0..len-1).each do |i|
          @grid[x][y+i-distance] = "#{letter}"
        end
        field.y -= distance
      when DOWN
        direction='down'
        (0..len-1).each do |i|
          @grid[x][y+i] = "."
        end
        (0..len-1).each do |i|
          @grid[x][y+i+distance] = "#{letter}"
        end
        field.y += distance
      when LEFT
        direction='left'
        (0..len-1).each do |i|
          @grid[x+i][y] = "."
        end
        (0..len-1).each do |i|
          @grid[x+i-distance][y] = "#{letter}"
        end
        field.x -= distance
      when RIGHT
        direction='right'
        (0..len-1).each do |i|
          @grid[x+i][y] = "."
        end
        (0..len-1).each do |i|
          @grid[x+i+distance][y] = "#{letter}"
        end
        field.x += distance
    end
    @action=Action.new(field,direction,distance)
  end

  #pridanie auta na field pri loadingu mapy
  def add(field)
    @fields.push(field)
    if field.escape
      @escape_vehicle = field
    end
    field.grid = self

    letter =field.letter
    x,y = field.position
    length = field.length

    case field.direction
      when HORIZONTAL
        x.upto(x+length-1) do |w|
          @grid[w][y] = "#{letter}"
        end
      when VERTICAL
        y.upto(y+length-1) do |z|
          @grid[x][z] = "#{letter}"
        end
    end
  end

  # kontrola ci sa auto na x,y moze pohnut dany smerom
  # kontrolu spravit na celej drahe, nie len vysledne fieldy
  # spravit evidenciu moves
  # nie len grids, pretoze to je podstatny vystup tohto tupeho vyjebaneho programu
  def canMove?(field,direction,distance)
    x =field.x
    length = field.length
    y =field.y
    letter=field.letter


      case direction
        when UP
          if field.direction == HORIZONTAL || y-distance < 0
            return false
          end
          (y-distance..y-1).each do |i|
            unless @grid[x][i].eql?(".")
              return false
            end
          end

          return true
        when DOWN
          if field.direction == HORIZONTAL || y+length-1+distance >= @height
            return false
          end
          (y+length..y+length+distance-1).each do |i|

            unless @grid[x][i].eql?(".")
              return false
            end
          end
          return true
        when LEFT
          if field.direction == VERTICAL ||  x-distance < 0
            return false
          end
          (x-distance..x-1).each do |i|

            unless @grid[i][y].eql?(".")
              return false
            end
          end
          true
        when RIGHT
          if field.direction == VERTICAL || x+length-1+distance >= @width
            return false
          end
          (x+length..x+distance+length-1).each do |i|
            unless  @grid[i][y].eql?(".")
              return false
            end
          end
          return true
      end
  end

  # vypis krizovatky na plochu
  public
  def printGrid
    puts "\nCURRENT STATE \n"
    puts "+"+(["+"]*width).join()+"+"
    @grid.each_with_index do |row, x|
      s = "+"
      row.each_with_index do |el, y|
        s+= @grid[y][x]+''
      end
      s+="+" if x != self.escape_vehicle.y
      puts s
    end
    puts "+"+(["+"]*width).join()+"+"
  end

  # funkcia na zkopcenie gridu
  def duplicateGrid(grid)
    newgrid = Grid.new(self.width, self.height)
    grid.fields.each do |b|
      newgrid.add(Field.new(b.letter,b.direction, b.length, b.x,b.y,b.escape))
    end
    newgrid.parent = grid.parent
    newgrid
  end

end