class Posicao2D
  attr_accessor :x
  attr_accessor :y
  
  def initialize(x,y)
    @x = x
    @y = y
  end
  
  def to_s
    return "(#{x},#{y})"
  end
  
  def eql?(outra_posicao)
    return self.x == outra_posicao.x && self.y == outra_posicao.y
  end
  
  def eql_x_y?(x,y)
    return eql?(Posicao2D.new(x,y))
  end
end
