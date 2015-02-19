require 'rails_helper'
require 'tictactoe/board'
require 'tictactoe/board_web_presenter'
require 'tictactoe/stubs/stub_game'
require 'ostruct'

RSpec.describe TicTacToeController, :type => :controller do
  let(:game) { TicTacToe::StubGame.new }
  let(:board) { TicTacToe::Board.new(3) }
  let(:board_param) { TicTacToe::Web::BoardWebPresenter.to_web_object(board) }

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
      expect(assigns(:game_types)).to match_array(TicTacToe::Game::GAME_TYPES)
    end

    it 'loads board sizes into board_sizes' do
      get(:home)
      expect(assigns(:board_sizes)).to match_array(TicTacToe::Game::BOARD_SIZES)
    end
  end

  describe 'new_game' do
    it 'redirects to play_move with board and game type' do
      get(:new_game, {'game_type' => TicTacToe::Game::HVH, 'board_size' => '3'} )

      expect(response).to redirect_to(play_move_path(
        'game_type' => TicTacToe::Game::HVH,
        'board' => board_param ))
    end
  end

  describe 'play_move' do
    let(:controller) { TicTacToeController.new }

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
      expect(assigns(:next_turn_url)).to include('board')
      expect(assigns(:next_turn_url)).to include('game_type')
    end

    it 'plays turn on game when current player is computer' do
      game.set_current_player_to_computer(true)
      controller.process_turn(game, nil)
      expect(game.play_turn_called?).to eq(true)
    end

    it 'adds move to game when human player has sent their move' do
      game.set_current_player_to_computer(false)
      controller.process_turn(game, 'user move')
      expect(game.add_move_called?).to eq(true)
    end

    it 'returns success' do
      get(:play_move, {'position' => '1', 'board' => board_param,  'game_type' => TicTacToe::Game::HVH} )
      expect(response).to be_success
    end

    def get_play_move
      get(:play_move, {'board' => board_param, 'game_type' => TicTacToe::Game::HVH })
    end

  end
end
