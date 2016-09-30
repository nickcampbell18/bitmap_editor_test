class Grid

  WHITE_PIXEL = 'O'.freeze

  def initialize(cols, rows)
    @rows = rows.to_i.freeze
    @cols = cols.to_i.freeze
    @grid = Array.new(@rows * @cols)
    clear
  end

  def read(col, row)
    @grid[translate(col, row)]
  end
  alias_method :[], :read

  def colour(col, row, colour)
    cell = translate(col, row)
    @grid[cell] = colour
  end

  def clear
    @grid.map! { WHITE_PIXEL }
  end

  private

  def translate(col, row)
    x = col - 1
    y = row - 1
    x * @cols + y
  end
end
