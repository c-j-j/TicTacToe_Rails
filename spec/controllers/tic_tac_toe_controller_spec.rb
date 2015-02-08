$LOAD_PATH.unshift(File.dirname('../ttt_ruby_1/lib'))
require 'rails_helper'
require 'lib/game'

RSpec.describe TicTacToeController, :type => :controller do
  let(:game) { double ('game') }
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
    it 'stores new game in session' do
      get(:new_game, {'game_type' => 'Human Vs Human', 'board_size' => '3'} )
      expect(session[:game]).to be_kind_of(TTT::Game)
    end

    it 'redirects to play_move' do
      get(:new_game, {'game_type' => 'Human Vs Human', 'board_size' => '3'} )
      expect(response).to redirect_to('play_move')
    end
  end

  describe 'play_move' do
    it 'renders play_move template' do
      session[:game] = game
      expect(game).to receive(:play_turn)
      allow(game).to receive(:game_over?)
      get(:play_move)
      expect(response).to render_template('play_move')
    end

    it 'calls play_turn on game' do
      session[:game] = game
      expect(game).to receive(:play_turn)
      allow(game).to receive(:game_over?)
      get(:play_move)
    end

    it 'calls play_turn with position parameter' do
      session[:game] = game
      allow(game).to receive(:game_over?)
      expect(game).to receive(:play_turn).with(1)
      get(:play_move, {:position => '1'})
    end
  end
end
