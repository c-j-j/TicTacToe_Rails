require 'tictactoe/game'
require 'tictactoe/board_web_presenter'

class TicTacToeController < ApplicationController

  INVALID_MOVE_MESSAGE = "Invalid Move, try again"
  attr_reader :error_message

  def home
    @game_types = TicTacToe::Game::GAME_TYPES
    @board_sizes = TicTacToe::Game::BOARD_SIZES
  end

  def new_game
    board = TicTacToe::Board.new(extract_board_size)
    game_type = extract_game_type
    game = TicTacToe::Game.build_game(game_type, extract_board_size)
    redirect_to play_move_path(play_move_query_params(game.presenter.board_positions))
  end

  def play_move
    game = build_game_from_params
    process_turn(game, extract_position_from_param)
    generate_display_fields(game)
  end

  def generate_display_fields(game)
    @next_turn_url =  play_move_path(play_move_query_params(game.presenter.board_positions))
    #TODO this will go when we switch to javascript
    @computer_has_next_turn = game.current_player_is_computer?
    @game_presenter = game.presenter
  end

  def process_turn(game, played_position)
    if game.current_player_is_computer?
      game.play_turn
    else
      submit_user_move(game, played_position)
    end
  end

  def submit_user_move(game, played_position)
    if game.move_valid?(played_position)
      game.add_move(played_position)
    end
  end

  private

  def play_move_query_params(board_positions)
    {'game_type' => extract_game_type, 'board' => board_param(board_positions)}
  end

  def board_param(board_positions)
    TicTacToe::Web::BoardWebPresenter.to_web_object(board_positions)
  end

  def build_game_from_params
    board = TicTacToe::Web::BoardWebPresenter.to_board(params['board'])
    TicTacToe::Game.build_game_with_board(extract_game_type, board)
  end

  def extract_game_type
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
