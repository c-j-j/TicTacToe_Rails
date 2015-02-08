$LOAD_PATH.unshift(File.dirname('../ttt_ruby_1/lib'))

require 'lib/game'
require 'lib/async_interface'

class TicTacToeController < ApplicationController
  def home
    @game_types = TTT::Game::GAME_TYPES
    @board_sizes = TTT::Game::BOARD_SIZES
  end

  def new_game
    game_type = params[:game_type]
    board_size = params[:board_size].to_i

    session[:game] = TTT::Game.build_game(TTT::AsyncInterface.new, game_type, board_size)
    redirect_to 'play_move'
  end

  def play_move
    game = session[:game]
    @game_response = game.play_turn(extract_position_from_param)
    #TODO carry on from here
    #@refresh_page = true if !game.game_over? && @game_response[:current_player_is_computer]
  end

  def reset
  end

  private

  def extract_position_from_param
    position = params['position']
    position.to_i unless position.nil?
  end
end
