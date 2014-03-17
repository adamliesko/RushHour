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
  states.each do |g|
    g.print_grid
    g.action.print if g.action
  end
end

def solve_bfs(grid)
  moves=0
  queue = []
  explored = Set.new
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
      puts ("\nSolved with BFS in  #{moves} moves, explored #{explored.length} states\n")
      exit
    end
    if explored.include?(g)
      next
    end
    explored.add(g)
    grids = g.generate_all_grids_with_moves
    grids.each do |child|
      queue << child
    end
  end
  puts 'No solution found'
  exit
end

def solve_dfs(grid)
  #definujeme si counter pohybov, hladam co najmensi objem
  moves=0
  explored = Set.new
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
      printGridEscape(backup)
      puts ("\nSolved with DFS in  #{moves} moves, explored #{explored.length} states\n")
      exit
      #ak som nasiel ciel s mensim poctom pohybov prepisem
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

  puts "No solution found"
  exit
end

#nacitanie krizovatky zo suboru
def load_grid(filename)
  grid = Grid.new(6, 6)
  cars =[]
  f = File.open(filename, "r")
  f.each_line do |line|
    orientation = line[-2]
    size = line[2].to_i
    x = line[4].to_i-1
    y = line[6].to_i-1
    letter =line[0]
    escape_vehicle = letter == '!'
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

grid = load_grid('grids/grid5')

#grid.print_grid
#solve_bfs(grid)
solve_dfs(grid)