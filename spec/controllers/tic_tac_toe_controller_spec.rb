require 'rails_helper'
require 'tictactoe'
require 'ostruct'

RSpec.describe TicTacToeController, :type => :controller do
  let(:game) { TTT::Game.build_game(TTT::AsyncInterface.new, TTT::Game::HVH, 3) }
  let(:board_param) { game.board_positions.to_json }

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
      get(:play_move, {'board' => board_param, 'game_type' => TTT::Game::HVH })
      expect(response).to render_template('play_move')
    end

    it 'builds game from parameters' do
      get(:play_move, {'board' => board_param, 'game_type' => TTT::Game::HVH })
      expect(assigns(:game_presenter)).to_not be(nil)
    end

    it 'builds url for next turn' do
      get(:play_move, {'board' => board_param, 'game_type' => TTT::Game::HVH })
      expect(assigns(:next_turn_url)).to eq(play_move_path(
        'game_type' => TTT::Game::HVH,
        'board' => board_param ))
    end

    it 'sets error message when invalid move given' do
      get(:play_move, {'board' => board_param, 'game_type' => TTT::Game::HVH,
      'position' => '-1'})
      expect(assigns(:error_message)).to eq(TTT::UI::INVALID_MOVE_MESSAGE)
    end
  end
end
