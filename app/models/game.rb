class Game < ApplicationRecord
  scope :available, -> { where(black_id: nil, game_over: false) }
  belongs_to :user, required: false
  belongs_to :white_player, class_name: 'User', foreign_key: 'white_id', optional: true
  belongs_to :black_player, class_name: 'User', foreign_key: 'black_id', optional: true
  has_many :pieces
  after_create :populate_board!
  after_create :set_game_defaults

  def set_game_defaults
      update_attributes(turn: 1, game_over: false)
  end
  
  def populate_board!
    # WHITE PIECES

    (1..8).each do |f|
      Pawn.create(x_pos: f, y_pos: 7, game_id: id, player_id: white_id, color: "white")
    end

    [1,8].each do |f|
    	Rook.create(x_pos: f, y_pos: 8, game_id: id, player_id: white_id, color: "white")
    end

    [2,7].each do |f|
    	Knight.create(x_pos: f, y_pos: 8, game_id: id, player_id: white_id, color: "white")
    end

    [3,6].each do |f|
    	Bishop.create(x_pos: f, y_pos: 8, game_id: id, player_id: white_id, color: "white")
    end

     Queen.create(x_pos: 4, y_pos: 8, game_id: id, player_id: white_id, color: "white")   


     King.create(x_pos: 5, y_pos: 8, game_id: id, player_id: white_id, color: "white")




    # BLACK PIECES 

    (1..8).each do |f|
      Pawn.create(x_pos: f, y_pos: 2, game_id: id, player_id: black_id, color: "black")
    end

    [1,8].each do |f|
    	Rook.create(x_pos: f, y_pos: 1, game_id: id, player_id: black_id, color: "black")
    end

    [2,7].each do |f|
    	Knight.create(x_pos: f, y_pos: 1, game_id: id, player_id: black_id, color: "black")
    end

    [3,6].each do |f|
    	Bishop.create(x_pos: f, y_pos: 1, game_id: id, player_id: black_id, color: "black")
    end

    Queen.create(x_pos: 4, y_pos: 1, game_id: id, player_id: black_id, color: "black")
  
    King.create(x_pos: 5, y_pos: 1, game_id: id, player_id: black_id, color: "black")



  end

  def stalemate(player_id)
    king = game.pieces.find_by(type: 'King', player_id: player_id)
    player_pieces = game.pieces.where(player_id: player_id)
    (1..8).each do |goal_x|
      (1..8).each do |goal_y|
        if player_pieces.invalid?(goal_x, goal_y) == false && king.check?(goal_x, goal_y) == true
          return true
        end
      end
    end
  end


  def checkmate?(player_id)
    king = game.pieces.find_by(type: 'King', player_id: player_id)
    if king.check? && stalemate?(player_id)
      return true
    end
  end

end
