$LOAD_PATH.unshift(File.dirname('../ttt_ruby_1/lib'))
require 'rails_helper'


RSpec.describe TicTacToeController, :type => :controller do
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
      expect(assigns(:game_types)).to eq('')
    end
  end
end
