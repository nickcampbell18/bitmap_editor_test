class Grid

  WHITE_PIXEL = 'O'.freeze
  COLOUR_RANGE = (?A..?Z).freeze
  GRID_RANGE = (1..250).freeze

  def initialize(cols, rows)
    @rows = rows.to_i.freeze
    @cols = cols.to_i.freeze
    check_dimensions(@cols, @rows)
    @grid = Array.new(@rows * @cols)
    clear
  end

  def read(col, row)
    @grid[translate(col, row)]
  end
  alias_method :[], :read

  def write(col, row, colour)
    check_colour(colour)
    cell = translate(col, row)
    @grid[cell] = colour
  end
  alias_method :[]=, :write

  def clear
    @grid.map! { WHITE_PIXEL }
  end

  def vertical_stripe(column, top_row, bottom_row, colour)
    row_range = Range.new(*[top_row, bottom_row].sort)
    row_range.each do |row|
      write(column, row, colour)
    end
  end

  def horizontal_stripe(row, left_column, right_column, colour)
    col_range = Range.new(*[left_column, right_column].sort)
    col_range.each do |col|
      write(col, row, colour)
    end
  end

  def print
    @grid
      .each_slice(@cols)
      .map { |row| row.join('') }
      .join("\n")
  end
  alias_method :to_s, :print

  private

  def translate(col, row)
    check_range(col, row)
    x = col - 1
    y = row - 1
    x * @cols + y
  end

  def check_range(col, row)
    if col > @cols || col < 1
      raise ArgumentError, "Column #{col} is out of range (#{@cols} columns available)"
    elsif row > @rows || row < 1
      raise ArgumentError, "Row #{row} is out of range (#{@rows} rows available)"
    end
  end

  def check_dimensions(given_cols, given_rows)
    if !GRID_RANGE.cover?(given_rows)
      raise ArgumentError, "Grid height must be between 1 and 250, but given #{given_rows}"
    elsif !GRID_RANGE.cover?(given_cols)
      raise ArgumentError, "Grid width must be between 1 and 250, but given #{given_cols}"
    end
  end

  def check_colour(colour)
    # Assumption: colours are ASCII upper-alpha only
    unless COLOUR_RANGE.cover?(colour)
      raise ArgumentError, "Colour #{colour} is not an uppercase A-Z character"
    end
  end
end
