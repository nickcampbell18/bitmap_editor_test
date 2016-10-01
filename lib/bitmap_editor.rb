require_relative './grid.rb'

class BitmapEditor

  HELP_MESSAGE = <<-HELP
? - Help
I M N - Create a new M x N image with all pixels coloured white (O).
C - Clears the table, setting all pixels to white (O).
L X Y C - Colours the pixel (X,Y) with colour C.
V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
S - Show the contents of the current image
X - Terminate the session"
HELP

  attr_reader :grid

  def initialize
    @grid   = nil
  end

  def run
    @running = true
    puts 'type ? for help'
    while @running
      print '> '
      handle_input(gets)
    end
  rescue SystemExit, Interrupt
    exit_console
  end

  def handle_input(string)
    method, *args = *string.split(' ').map(&:strip)
    case method
    when '?'
      puts HELP_MESSAGE
    when 'X'
      raise SystemExit
    when 'I'
      @grid = Grid.new(*args)
    when 'L'
      requires_grid
      col, row, colour = *args
      @grid.write(col.to_i, row.to_i, colour)
    when 'V'
      requires_grid
      col, top_row, bottom_row, colour = *args
      @grid.vertical_stripe(col.to_i, top_row.to_i, bottom_row.to_i, colour)
    when 'H'
      requires_grid
      left_col, right_col, row, colour = *args
      @grid.horizontal_stripe(row.to_i, left_col.to_i, right_col.to_i, colour)
    when 'C'
      requires_grid
      @grid.clear
    when 'S'
      requires_grid
      puts @grid.print
    else
      raise ArgumentError, "Unrecognised command `#{method}`"
    end
  rescue ArgumentError => e
    puts "Error: " << e.message
  end

  private

  def exit_console
    puts 'goodbye!'
    @running = false
  end

  def requires_grid
    return if @grid
    raise ArgumentError, 'Please construct a grid first (using `I M N` syntax)'
  end
end
