require 'rails_helper'
require 'tictactoe'
require 'ostruct'

RSpec.describe TicTacToeController, :type => :controller do
  let(:board) { TTT::Board.new(3) }
  let(:board_param) { TTT::Web::BoardWebPresenter.to_web_object(board) }

  describe 'home' do
    it 'responds successfully with 200 status code' do
      get(:home)
      expect(response).to be_success
    end

    it 'renders index template' do
      get(:home)
      expect(response).to render_template('home')
    end

    it 'loads game options into game_types' do
      get(:home)
      expect(assigns(:game_types)).to match_array(TTT::Game::GAME_TYPES)
    end

    it 'loads board sizes into board_sizes' do
      get(:home)
      expect(assigns(:board_sizes)).to match_array(TTT::Game::BOARD_SIZES)
    end
  end

  describe 'new_game' do
    it 'redirects to play_move with board and game type' do
      get(:new_game, {'game_type' => TTT::Game::HVH, 'board_size' => '3'} )

      expect(response).to redirect_to(play_move_path(
        'game_type' => TTT::Game::HVH,
        'board' => board_param ))
    end
  end

  describe 'play_move' do
    it 'renders play_move template' do
      get_play_move
      expect(response).to render_template('play_move')
    end

    it 'plays game and assigns output to game_presenter' do
      get_play_move
      expect(assigns(:game_presenter)).to_not be(nil)
    end

    it 'builds url for next turn' do
      get_play_move
      expect(assigns(:next_turn_url)).to eq(play_move_path(
        'game_type' => TTT::Game::HVH,
        'board' => board_param ))
    end

    it 'sets error message when invalid move given' do
      get(:play_move, {'board' => board_param, 'game_type' => TTT::Game::HVH,
      'position' => '-1'})
      expect(assigns(:error_message)).to eq(TicTacToeController::INVALID_MOVE_MESSAGE)
    end

    def get_play_move
      get(:play_move, {'board' => board_param, 'game_type' => TTT::Game::HVH })
    end

  end
end
