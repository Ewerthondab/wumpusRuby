require 'rubygame'
require 'util/sequenciador'

class GraphicElements
  attr_reader :tile1
  attr_reader :tile2
  attr_reader :jogador
  attr_reader :monstro
  attr_reader :flecha
  attr_reader :ouro
  attr_reader :buraco
  attr_reader :brisa
  attr_reader :catinga
  attr_reader :luz
  attr_reader :desconhecido
  
  def initialize
    load_graphic_elements
  end
  
  def load_graphic_elements
    @tile1 = load("tile1.png")
    @tile2 = load("tile2.png")
    @jogador = [ load("jogadorU.png"),load("jogadorR.png"),load("jogadorD.png"),load("jogadorL.png") ]
    @monstro = load("monstro.png")
    @flecha = [ load("flechaU.png"),load("flechaR.png"),load("flechaD.png"),load("flechaL.png") ]
    @ouro = load("ouro.png")
    @buraco = load("buraco.png")
    @brisa = load("brisa1.png")
    @catinga = [ load("catinga1.png"),load("catinga2.png"),load("catinga3.png"),load("catinga4.png") ]
    @luz = load("luz.png")
    @desconhecido = load("desc.png")
    
    @seq_catinga = Sequenciador.new 4,1
  end
  
  def jogador(orientacao)
    @jogador[orientacao]
  end
  
  def flecha(orientacao)
    @flecha[orientacao]
  end
  
  def catinga
    @catinga[@seq_catinga.next]
  end
  
  private
  
  def load(filename)
    Rubygame::Image.load("graphics/" + filename)
  end
end
