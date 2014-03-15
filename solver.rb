require "./grid.rb"
require "set"

def printGridEscape(grid)
  states = Array.new
  while grid
    states.unshift(grid)
    grid = grid.parent
  end
  states[0].printGrid
  states.each do |grid|
    grid.action.print if grid.action
    grid.printGrid
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
      puts 'Solution found'
      backup=g
      while g.parent
        g=g.parent
        moves+=1
      end
      printGridEscape(backup)
      puts ("Solved in  #{moves} moves")
      exit
    end
    if explored.include?(g)
      puts 'was here'
      next
    end
    explored.add(g)
    grids = g.generateAllGrids
    grids.each do |child|
      queue <<  child
    end
  end
  puts "No solution found"
  exit
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
    #printGridEscape(min_grid)
    puts ("Solved in  #{min_moves} moves")
    exit
  end
  puts "No solution found"
end

def loadGrid(filename)
  grid = Grid.new(6,6)
  cars =[]

  f = File.open(filename, "r")
  f.each_line do |line|
    orientation = line[-2]
    size = line[2].to_i
    x = line[4].to_i-1
    y = line[6].to_i-1
    letter =line[0]
    escape_vehicle =  letter == '!'
    if orientation == 'h'
      cars.push(Field.new(letter, HORIZONTAL, size, x, y, escape_vehicle))
    else
      cars.push(Field.new(letter, VERTICAL, size, x, y, escape_vehicle))
    end
  end
  f.close
  cars.each do |car|
    grid.add(car)
  end
  grid
end

grid = loadGrid('board1.txt')

grid.printGrid
solveBFS(grid)
#solveDFS(grid)