#    X  Y  Z
# A  0  1 -1
# B -1  0  1
# C  1 -1  0


# A -> Rock
# B -> Paper
# C -> Scissors

# X -> lose
# Y -> draw
# Z -> win

# 0 if loss, 3 if draw, 6 if win
SCORES = { A: 1, B: 2, C: 3, X: 1, Y: 2, Z: 3 }
MOVES = [
  [0, 1, -1],
  [-1, 0, 1],
  [1, -1, 0]
]

RES_PT2 = { X: 0, Y: 1, Z: 2 }

# lose, draw, win
MOVES_PT2 = [
  %w[C A B],
  %w[A B C],
  %w[B C A]
]

# if you lose, chose the losing from the matrix
#   if win, chose winning from matrix

def rock_paper_scissors
  score_total_pt1 = 0
  score_total_pt2 = 0

  games = File.readlines('inputs/day2.txt')

  games.each do |game|
    moves = game.chomp.split(' ')
    score_total_pt1 += calc_score_pt1(moves[0].to_sym, moves[1].to_sym)
    score_total_pt2 += calc_score_pt2(moves[0].to_sym, moves[1].to_sym)
  end

  [score_total_pt1, score_total_pt2]
end

def calc_score_pt1(opp, yours)
  their_move = SCORES[opp]
  your_move = SCORES[yours]

  # win/loss/draw
  result = MOVES[their_move - 1][your_move - 1]

  if result == 0 # draw
    your_score = 3 + your_move
  elsif result == 1 # you win
    your_score = 6 + your_move
  else # they win
    your_score = 0 + your_move
  end

  your_score
end

def calc_score_pt2(opp, yours)
  result = RES_PT2[yours]
  opp_idx = SCORES[opp] - 1
  move_letter = MOVES_PT2[opp_idx][RES_PT2[yours]]
  your_move = SCORES[move_letter.to_sym]

  if result == 0 # lose
    your_score = 0 + your_move
  elsif result == 1 # draw
    your_score = 3 + your_move
  else
    your_score = 6 + your_move
  end

  your_score
end

p rock_paper_scissors