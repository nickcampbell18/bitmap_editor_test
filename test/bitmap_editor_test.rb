require_relative './test_helper.rb'
require_relative '../lib/bitmap_editor.rb'

describe BitmapEditor do
  describe '#handle_input' do
    before do
      @editor = BitmapEditor.new
    end

    describe '?' do
      it 'should print the help message' do
        message, _ = capture_io do
          @editor.handle_input('?')
        end
        assert_match /I M N - Create a new/, message
      end
    end

    describe 'X' do
      it 'should raise a SystemExit exception' do
        assert_raises(SystemExit) do
          @editor.handle_input('X')
        end
      end
    end

    describe 'I(M,N)' do
      it 'should construct a grid instance of the given dimensions' do
        @editor.handle_input('I 5 5 ')
        assert @editor.grid

        assert @editor.grid[5, 5]
        assert_raises { @editor.grid[6, 6] }
      end

      it 'should handle bad input and return an error message without creating a grid' do
        message, _ = capture_io do
          @editor.handle_input('I 255 255')
        end
        assert_match /Error\: Grid/, message
        refute @editor.grid
      end
    end

    describe 'L(X,Y,C)' do
      it 'should colour a pixel' do
        @editor.handle_input('I 2 2')
        @editor.handle_input('L 2 2 S')
        assert_equal 'S', @editor.grid[2, 2]
      end

      it 'should raise an error if the grid has not been initialized' do
        message, _ = capture_io do
          @editor.handle_input('L 1 1 X')
        end
        assert_equal "Error: Please construct a grid first (using `I M N` syntax)\n", message
      end
    end

    describe 'C' do
      it 'should clear the grid' do
        @editor.handle_input('I 2 2')
        @editor.handle_input('L 2 2 S')
        @editor.handle_input('C')
        assert_equal 'O', @editor.grid[2, 2]
      end

      it 'should raise an error if the grid has not been initialized' do
        message, _ = capture_io do
          @editor.handle_input('C')
        end
        assert_equal "Error: Please construct a grid first (using `I M N` syntax)\n", message
      end
    end

    describe 'V' do
      it 'should draw a vertical stripe' do
        @editor.handle_input('I 3 3')
        @editor.handle_input('V 1 1 3 Y')
        assert_equal 'Y', @editor.grid[1, 1]
        assert_equal 'Y', @editor.grid[1, 3]
      end

      it 'should raise an error if the grid has not been initialized' do
        message, _ = capture_io do
          @editor.handle_input('V 1 1 3 Y')
        end
        assert_equal "Error: Please construct a grid first (using `I M N` syntax)\n", message
      end
    end

    describe 'H' do
      it 'should draw a horizontal stripe' do
        @editor.handle_input('I 3 3')
        @editor.handle_input('H 1 3 2 Y')
        assert_equal 'Y', @editor.grid[1, 2]
        assert_equal 'Y', @editor.grid[3, 2]
      end

      it 'should raise an error if the grid has not been initialized' do
        message, _ = capture_io do
          @editor.handle_input('H 1 3 2 Y')
        end
        assert_equal "Error: Please construct a grid first (using `I M N` syntax)\n", message
      end
    end

    describe 'S' do
      it 'should print the grid' do
        @editor.handle_input('I 2 2')
        @editor.handle_input('L 1 1 A')
        @editor.handle_input('L 2 2 B')

        message, _ = capture_io do
          @editor.handle_input('S')
        end
        assert_equal "AO\nOB\n", message
      end

      it 'should raise an error if the grid has not been initialized' do
        message, _ = capture_io do
          @editor.handle_input('S')
        end
        assert_equal "Error: Please construct a grid first (using `I M N` syntax)\n", message
      end
    end

    describe 'unknown commands' do
      it 'should print an error message' do
        message, _ = capture_io do
          @editor.handle_input('R')
        end
        assert_equal "Error: Unrecognised command `R`\n", message
      end
    end
  end
end
