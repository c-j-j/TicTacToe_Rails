require 'tictactoe'

class TicTacToeController < ApplicationController

  INVALID_MOVE_MESSAGE = "Invalid Move, try again"

  def home
    @game_types = TTT::Game::GAME_TYPES
    @board_sizes = TTT::Game::BOARD_SIZES
  end

  def new_game
    board = TTT::Board.new(extract_board_size)
    redirect_to play_move_path(play_move_query_params(board))
  end

  def play_move
    game = build_game_from_params
    process_turn(game, extract_position_from_param)
    @next_turn_url =  play_move_path(play_move_query_params(game.presenter.board))
    @game_presenter = game.presenter
  end

  private

  def play_move_query_params(board)
    {'game_type' => extract_game_type_from_params, 'board' => board_param(board)}
  end

  def board_param(board)
    TTT::Web::BoardWebPresenter.to_web_object(board)
  end

  def process_turn(game, played_position)
    if game.move_valid?(played_position)
      game.play_turn(played_position)
    else
      @error_message = INVALID_MOVE_MESSAGE
    end
  end

  def build_game_from_params
    game_type = extract_game_type_from_params
    board = TTT::Web::BoardWebPresenter.to_board(params['board'])
    TTT::Game.build_game_with_board(game_type, board)
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
