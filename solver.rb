require "./grid.rb"
require "set"

def printGridEscape(grid)
  states = Array.new
  while grid
    states.unshift(grid)
    grid = grid.parent
  end
  puts "Initial state:"
  states.each do |grid|
    grid.printGrid
    grid.action.print if grid.action
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
      puts ("\nSolved in  #{moves} moves, explored #{explored.length} states\n")
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
      puts ("\nSolved in  #{moves} moves, explored #{explored.length} states\n")
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

grid = loadGrid('board2.txt')

#grid.printGrid
solveBFS(grid)
#solveDFS(grid)