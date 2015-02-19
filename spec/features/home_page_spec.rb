require 'rails_helper'
require 'tictactoe/game'

RSpec.describe 'home page' do
  it 'home page has game types' do
    visit '/'
    TicTacToe::Game::GAME_TYPES.each do |game_type|
      expect(page).to have_content(game_type)
    end
  end

  it 'home page has board sizes' do
    visit '/'
    TicTacToe::Game::BOARD_SIZES.each do |board_size|
      expect(page).to have_content(board_size)
    end
  end

  it 'directs to play move page when play button is pressed' do
    visit '/'
    find("#play_game_button").click
    expect(current_path).to eq("/play_move")
  end

end
