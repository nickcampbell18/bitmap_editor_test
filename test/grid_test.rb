require_relative './test_helper.rb'
require_relative '../lib/grid.rb'

describe Grid do

  INVALID_COLOURS = [0, nil, 'a', 'Ś'].freeze

  describe '#initialize' do
    it 'should construct a 2x2 grid full of WHITE' do
      grid = Grid.new(2, 2)
      assert_equal 'O', grid[1, 1]
      assert_equal 'O', grid[1, 2]
      assert_equal 'O', grid[2, 1]
      assert_equal 'O', grid[2, 2]
    end

    it 'should raise an ArgumentError if the row number is not between 1 and 250' do
      [-1, 0, 251].each do |bad_row|
        assert_raises(ArgumentError) { Grid.new(5, bad_row) }
      end
    end

    it 'should raise an ArgumentError if the column number is not between 1 and 250' do
      [-1, 0, 251].each do |bad_col|
        assert_raises(ArgumentError) { Grid.new(bad_col, 4) }
      end
    end
  end

  describe '#[] (read)' do
    it 'should not overflow if given column is out of range' do
      grid = Grid.new(3, 3)
      err = assert_raises(ArgumentError) do
        grid[4, 3]
      end
      assert_equal 'Column 4 is out of range (3 columns available)', err.message
    end

    it 'should not overflow if given row is out of range' do
      grid = Grid.new(3, 3)
      err = assert_raises(ArgumentError) do
        grid[3, 0]
      end
      assert_equal 'Row 0 is out of range (3 rows available)', err.message
    end

    it 'should not overflow on negative rows' do
      grid = Grid.new(2, 2)
      assert_raises(ArgumentError) do
        grid[2, -1]
      end
    end
  end

  describe '#write' do
    before do
      @grid = Grid.new(3, 3)
    end

    it 'should colour the first cell' do
      @grid.write(1, 1, 'F')
      assert_equal 'F', @grid[1, 1]
    end

    it 'should colour the middle cell' do
      @grid.write(2, 2, 'G')
      assert_equal 'G', @grid[2, 2]
    end

    it 'should not colour other cells' do
      @grid.write(3, 3, 'X')
      white_cells = [[1, 1], [1, 2], [1, 3], [2, 1], [2, 2], [2, 3], [3, 1], [3, 2]]
      white_cells.each do |(col, row)|
        assert_equal 'O', @grid[col, row]
      end
    end

    it 'also accepts the shorthand []=' do
      @grid[1, 1] = 'X'
      assert_equal 'X', @grid[1, 1]
    end

    it 'should raise an error if given an invalid colour' do
      INVALID_COLOURS.each do |bad_colour|
        assert_raises(ArgumentError) { @grid.write(1, 1, bad_colour) }
      end
    end
  end

  describe '#vertical_stripe' do
    before do
      @grid = Grid.new(5, 5)
    end

    it 'should paint the central cell' do
      @grid.vertical_stripe(3, 3, 3, 'R')
      assert_equal 'R', @grid[3, 3]
      # None of the surrounding cells
      assert_equal 'O', @grid[3, 2]
      assert_equal 'O', @grid[3, 4]
      assert_equal 'O', @grid[2, 3]
      assert_equal 'O', @grid[2, 4]
    end

    it 'should paint a stripe along the whole height' do
      @grid.vertical_stripe(2, 1, 5, 'T')
      [[2, 1], [2, 2], [2, 3], [2, 4], [2, 5]].each do |(col, row)|
        assert_equal 'T', @grid[col, row]
      end
    end

    it 'should raise an error if given an invalid colour' do
      INVALID_COLOURS.each do |bad_colour|
        assert_raises(ArgumentError) { @grid.vertical_stripe(1, 1, 1, bad_colour) }
      end
    end
  end

  describe '#horizontal_stripe' do
    before do
      @grid = Grid.new(5, 5)
    end

    it 'should paint the central cell' do
      @grid.horizontal_stripe(3, 3, 3, 'R')
      assert_equal 'R', @grid[3, 3]
      # None of the surrounding cells
      assert_equal 'O', @grid[3, 2]
      assert_equal 'O', @grid[3, 4]
      assert_equal 'O', @grid[2, 3]
      assert_equal 'O', @grid[2, 4]
    end

    it 'should paint a stripe along the whole width' do
      @grid.horizontal_stripe(1, 1, 5, 'T')
      [[1, 1], [2, 1], [3, 1], [4, 1], [5, 1]].each do |(col, row)|
        assert_equal 'T', @grid[col, row]
      end
    end

    it 'should be able to paint backwards' do
      @grid.horizontal_stripe(5, 4, 2, 'W')
      [[2, 5], [3, 5], [4, 5]].each do |(col, row)|
        assert_equal 'W', @grid[col, row]
      end
    end

    it 'should raise an error if given an invalid colour' do
      INVALID_COLOURS.each do |bad_colour|
        assert_raises(ArgumentError) { @grid.horizontal_stripe(1, 1, 1, bad_colour) }
      end
    end
  end

  describe '#clear' do
    it 'should reset the colour state to WHITE' do
      grid = Grid.new(2, 2)
      grid.write(1, 1, 'X')
      grid.clear
      assert_equal 'O', grid[1, 1]
    end
  end

  describe '#print' do
    it 'should print a simple grid' do
      grid = Grid.new(2, 2)
      assert_equal "OO\nOO", grid.print
    end

    it 'should print a complex grid' do
      grid = Grid.new(3, 3)
      grid[1, 3] = 'D'
      grid[2, 2] = 'R'
      grid[3, 3] = 'E'
      assert_equal "OOD\nORO\nOOE", grid.print
    end

    it 'also accepts the shorthand #to_s' do
      grid = Grid.new(1, 1)
      assert_equal 'O', grid.to_s
    end
  end

end
