require "./field.rb"
require "./action.rb"


class Grid
  attr_accessor :grid, :fields, :width, :height, :parent, :escape_vehicle, :action

  def initialize(width, height)
    @fields = [] #pole automobilov
    @width = width
    @action = nil #akcia zatial nulova
    @height = height
    @grid = Array.new(@width) { Array.new(@height, ".") } #krizovatka pre automobily
  end

  # funkcia na zistienia , ci su 2 krizovatky rovnake
  def eql?(other)
    self.grid.each_with_index do |row, i|
      unless self.grid[i].eql?(other.grid[i])
        return false
      end
    end
    true
  end

  # funkcia na vygenerovanie vsetkych moznych stavov po pohyboch , ako mnozina novych krizovatiek
  # vzdialenosti 1 -5 pri krizovatke 6x6

  def generate_all_grids_with_moves
    grids = []
    #pre kazde autor z krizovatky
    self.fields.each do |field|
      #pre jednotlive vzdialenosti
      (1..@width-1).each do |distance|
        #zistujem ktorym smerom sa mozem vydat
        case field.direction
          when VERTICAL
            if self.can_move?(field, UP, distance)
              u = self.duplicate_grid
              u.move(field, UP, distance)
              u.parent = self
              grids.push(u)
            end
            if self.can_move?(field, DOWN, distance)
              d = self.duplicate_grid
              d.move(field, DOWN, distance)
              d.parent = self
              grids.push(d)
            end
          when HORIZONTAL
            if self.can_move?(field, LEFT, distance)
              l = self.duplicate_grid
              l.move(field, LEFT, distance)
              l.parent = self
              grids.push(l)
            end
            if self.can_move?(field, RIGHT, distance)
              r = self.duplicate_grid
              r.move(field, RIGHT, distance)
              r.parent = self
              grids.push(r)
            end
        end
      end
    end
    grids
  end

  # zistujeme, ci uz sme solvli hlavolam, tj ci moze escape vehicle ujst
  def isFinish?
    x=@escape_vehicle.x
    y=@escape_vehicle.y

    # kontrolujem ci su miesta volne
    (x+@escape_vehicle.length).upto(@width-1) do |z|
      unless @grid[z][y].eql?(".")
        return false
      end
    end
    true
  end

  #posun fieldu na x,y o jednu poziciu danym smerom
  def move(orig_field, direction, distance)
    field = Field.new(1, 2, 3, 4, 5)
    # najdeme si ktory field ideme posuvat
    @fields.each do |f|
      if f.x == orig_field.x and orig_field.y == f.y
        field = f
      end
    end
    # skratenie premennych ;))
    x=field.x
    y=field.y
    letter = field.letter
    len = field.length

    #vzdy zmazem povodne pozicie a vytvorime nove

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
    #vytvorime akciu pohybu
    @action=Action.new(field, direction, distance)
  end

  #pridanie auta na field pri loadingu mapy
  def add(field)
    @fields.push(field)
    if field.escape
      @escape_vehicle = field
    end
    letter =field.letter
    x= field.x
    y=field.y
    length = field.length
    # pisem pismena do pola rozdielne vzhladom na ich orientaciu
    case field.direction
      when HORIZONTAL
        (x..x+length-1).each do |i|
          @grid[i][y] = "#{letter}"
        end
      when VERTICAL
        (y..y+length-1).each do |i|
          @grid[x][i] = "#{letter}"
        end
    end
  end

  # kontrola ci sa auto na x,y moze pohnut dany smerom
  # kontrolu treba spravit na celej drahe, nie len vysledne fieldy

  def can_move?(field, direction, distance)
    x =field.x
    length = field.length
    y =field.y
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
        if field.direction == VERTICAL || x-distance < 0
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
  # ohranicenie policok je +, v mieste uniku --3 riadok je medzera
  public
  def print_grid
    puts "\nGRID"
    puts "+"+(["+"]*@width).join+"+"
    @grid.each_with_index do |row, x|
      s = "+"
      row.each_with_index do |el, y|
        s+= @grid[y][x]+''
      end
      s+="+" if x != self.escape_vehicle.y
      puts s
    end
    puts "+"+(["+"]*@width).join+"+"
  end

  # funkcia na zkopcenie gridu, pricom kopirujem aj jednotlive vozidla na mape, rodica
  def duplicate_grid
    newgrid = Grid.new(self.width, self.height)
    @fields.each do |b|
      newgrid.add(Field.new(b.letter, b.direction, b.length, b.x, b.y, b.escape))
    end
    newgrid.parent = self.parent
    newgrid
  end

  #interna funkcia aby ju mohol set vyuzivat pri zistovani ci uz niekedy v takom stave bol
  def hash
    result = 0
    @grid.each_with_index do |row, i|
      result += row.hash*((i+1))
    end
    result
  end


end