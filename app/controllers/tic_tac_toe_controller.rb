require 'tictactoe'

class TicTacToeController < ApplicationController
  def home
    @game_types = TTT::Game::GAME_TYPES
    @board_sizes = TTT::Game::BOARD_SIZES
  end

  def new_game
    game_type = params[:game_type]
    game = TTT::Game.build_game(TTT::AsyncInterface.new, game_type, extract_board_size)
    redirect_to play_move_path('game_type' => game_type, 'board' => game.board_positions.to_json)
  end

  def play_move
    game = build_game_from_params
    process_turn(game, extract_position_from_param)
    @next_turn_url =  play_move_path('game_type' => extract_game_type_from_params, 'board' => game.board_positions.to_json)
    @game_presenter = game.presenter
  end

  private

  def process_turn(game, played_position)
    if game.move_valid?(played_position)
      game.play_turn(played_position)
    else
      @error_message = TTT::UI::INVALID_MOVE_MESSAGE
    end
  end

  def build_game_from_params
    game_type = extract_game_type_from_params
    board = TTT::Board.new_board_with_positions(JSON.parse(params['board']))
    TTT::Game.build_game_with_board(TTT::AsyncInterface.new, game_type, board)
  end

  def extract_game_type_from_params
    params['game_type']
  end

  def extract_board_size
    params[:board_size].to_i
  end

  def extract_position_from_param
    position = params['position']
    position.to_i unless position.nil?
  end
end
