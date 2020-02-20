class Monstro
  attr_reader :posicao
  attr_reader :nome
  attr_accessor :morreu
  
  def initialize(nome,x,y)
    @nome = nome
    @posicao = Posicao2D.new x,y
    @morreu = false
  end
  
  def set_posicao(posicao)
    @posicao = posicao
  end
  
  def to_s
    return "M"
  end
end
