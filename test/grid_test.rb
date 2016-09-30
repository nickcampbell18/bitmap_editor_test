require_relative './test_helper.rb'
require_relative '../lib/grid.rb'

describe Grid do

  describe '#initialize' do
    it 'should construct a 2x2 grid full of WHITE' do
      grid = Grid.new(2, 2)
      assert_equal 'O', grid[1, 1]
      assert_equal 'O', grid[1, 2]
      assert_equal 'O', grid[2, 1]
      assert_equal 'O', grid[2, 2]
    end
  end

  describe '#colour' do
    before do
      @grid = Grid.new(3, 3)
    end

    it 'should colour the first cell' do
      @grid.colour(1, 1, 'F')
      assert_equal 'F', @grid[1, 1]
    end

    it 'should colour the middle cell' do
      @grid.colour(2, 2, 'G')
      assert_equal 'G', @grid[2, 2]
    end
  end

  describe '#clear' do
    it 'should reset the colour state to WHITE' do
      grid = Grid.new(2, 2)
      grid.colour(1, 1, 'X')
      grid.clear
      assert_equal 'O', grid[1, 1]
    end
  end

end
