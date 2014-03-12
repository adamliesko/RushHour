require "./grid.rb"
require "set"

def showSolution(grid)
  history = []
  while grid
    history.unshift(grid)
    grid = grid.parent
  end
  history.each do |b|
    b.print
  end
end

def solveBFS(grid)
  moves=0
  explored = Set.new()
  queue = []
  queue << grid
  while !queue.empty?
    g = queue.shift
    if g.isFinish?
      backup=g
      while g.parent
        g=g.parent
        moves+=1
      end
      showSolution(backup)
      puts ("Solved in  #{moves} moves")
      exit
    end
    next if explored.include?(g)
    explored.add(g)
    grids = g.generateAllGrids
    grids.each do |child|
      queue <<  child
    end
  end
  puts "No solution found"
end

def solveDFS(grid)
  moves=0
  min_moves=99999
  explored = Set.new()
  stack = []
  stack.push(grid)

  while !stack.empty?
    g = stack.pop
    if g.isFinish?
      moves=0
      backup=g
      while g.parent
        g=g.parent
        moves+=1
      end
      if moves < min_moves
        min_moves =moves
        min_grid=backup
      end
    end
    next if explored.include?(g)
    explored.add(g)
    grids = g.generateAllGrids
    grids.each do |child|
      stack.push(child)
    end
  end
  if (min_grid)
    #showSolution(min_grid)
    puts ("Solved in  #{min_moves} moves")
    exit
  end
  puts "No solution found"
end
=begin
def loadGrid(filename)
  grid = Grid.new(6,6)

  f = File.open(filename, "r")
  f.each_line do |line|
    size = line[3].to_i
    x = line[5].to_i-1
    y = line[7].to_i-1
    letter =line[0..1]
    special=false
    special = true if letter == '!'
    (/line/ =~ 'HORIZONTAL') ?
        grid.add(Field.new(letter, HORIZONTAL, size, x, y, special)) :
        grid.add(Field.new(letter, VERTICAL, size, x, y, special))

  end
  f.close
  grid
end
=end

#grid = loadGrid('board1.txt')
#
#add veritcal
grid = Grid.new(6,6)

grid.add(Field.new('aa',VERTICAL, 3, 0,0))
grid.add(Field.new('bb',VERTICAL, 2, 3,0))
grid.add(Field.new('cc',VERTICAL, 2, 5,0))
grid.add(Field.new('dd',VERTICAL, 3, 4,2))
grid.add(Field.new('ee',VERTICAL, 2, 5,3))
grid.add(Field.new('ff',VERTICAL, 2, 2,4))

#add horizontal
grid.add(Field.new('gg',HORIZONTAL, 2, 1,1))
grid.add(Field.new('hh',HORIZONTAL, 3, 0,3))
grid.add(Field.new('ii',HORIZONTAL, 2, 0,5))
grid.add(Field.new('jj',HORIZONTAL, 2, 3,5))

grid.add(Field.new('!!',HORIZONTAL, 2, 2,2, true))


=begin
grid.add(Field.new(VERTICAL, 4, 0,1))
grid.add(Field.new(VERTICAL, 3, 3,2))
grid.add(Field.new(VERTICAL, 2, 4,0))
grid.add(Field.new(HORIZONTAL, 2, 1,2, true))
grid.add(Field.new(HORIZONTAL, 2, 2,5))
=end

grid.print
solveBFS(grid)
#solveDFS(grid)