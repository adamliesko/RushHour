require "./grid.rb"
require "set"

#funkcia na vypis nasej vyslednej cesty
def printGridEscape(grid)
  states = Array.new
  #musim si vytvorit nove pole stavov, idem odzadu
  #pridavam pohyby a krizovatky do pola
  while grid
    states.unshift(grid)
    grid = grid.parent
  end
  puts "Initial state:"
  #vypisem pole
  states.each do |grid|
    grid.print_grid
    grid.action.print if grid.action
  end
end

def solveBFS(grid)
  moves=0
  #FIFO queue pre nove krizovatky
  queue = []
  #mnozina navstivenych krizovatie
  explored = Set.new()
  queue << grid

  while !queue.empty?
    g = queue.shift
    #ak som uz nasiel ciel, viem, ze pri BFS je to na minimum tahov
    if g.isFinish?
      puts 'Solution found'
      backup=g
      #zratam si pocty
      while g.parent
        g=g.parent
        moves+=1
      end
      printGridEscape(backup)
      puts ("\nSolved with BFS in  #{moves} moves, explored #{explored.length} states\n")
      exit
    end
    if explored.include?(g)
      next
    end
    explored.add(g)
    grids = g.generate_all_grids_with_moves
    grids.each do |child|
      queue <<  child
    end
  end
  puts "No solution found"
  exit
end

def solveDFS(grid)

  #definujeme si counter pohybov, hladam co najmensi objem

  moves=0
  min_moves=999
  explored = Set.new()
  #zasobnik pre nove krizovatky
  stack = []
  stack.push(grid)
  while !stack.empty?
    moves=0
    g = stack.pop
    if g.isFinish?
      backup=g
      while g.parent
        g=g.parent
        moves+=1
      end

      #ak som nasiel ciel s mensim poctom pohybov prepisem
      if moves < min_moves
        min_moves =moves
        min_grid=backup
      end
    end
    if explored.include?(g)
      next
    end
    explored.add(g)
    grids = g.generate_all_grids_with_moves
    grids.each do |child|
      stack.push(child)
    end
  end
  if min_grid
    printGridEscape(backup)
    puts ("\nSolved with DFS in  #{min_moves} moves, explored #{explored.length} states\n")
    exit
  end
  puts "No solution found"
  exit
end

#nacitanie krizovatky zo suboru
def load_grid(filename)
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

grid = load_grid('grids/grid3')

grid.print_grid
solveBFS(grid)
#solveDFS(grid)