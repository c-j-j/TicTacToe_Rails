require 'rails_helper'
require 'tictactoe/game'
require 'tictactoe/board_web_presenter'
require 'tictactoe/stubs/stub_game'

RSpec.describe 'play move page' do

  let(:game) { TicTacToe::StubGame.new }
  let(:board) { TicTacToe::Board.new(3) }
  let(:board_param) { TicTacToe::Web::BoardWebPresenter.to_web_object(game.presenter.board_positions) }

  it 'play move page prints out board with 9 cells' do
    go_to_play_move_page
    expect(all('div.cell').count).to eq(board.number_of_positions)
  end

  it 'play move page has status' do
    go_to_play_move_page
    game = TicTacToe::Game.build_game(TicTacToe::Game::HVH, 3)
    expect(page).to have_content(game.presenter.status)
  end

  it 'clicked cell is displayed to screen' do
    go_to_play_move_page
    expect(find("#cell-0")).to have_content("")
    find("#cell-0").find("a").click
    expect(find("#cell-0")).to have_content("X")
  end

  it 'directs back to home page when button is clicked' do
    go_to_play_move_page
    click_link("new_game_link")
    expect(current_path).to eq("/")
  end

  def go_to_play_move_page
    visit(play_move_path({
      'game_type' => TicTacToe::Game::HVH,
      'board' => board_param
    }))
  end

end
