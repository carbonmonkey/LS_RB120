class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
  end

  def play
    "G, 53!"
  end
end

puts Bingo.new.play