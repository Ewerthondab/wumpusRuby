require 'posicao_2d'

class Jogador
  attr_reader :nome
  attr_reader :posicao
  attr_reader :orientacao
  attr_reader :limites
  attr_reader :flechas
  attr_accessor :morreu
  attr_accessor :tem_ouro
  
  # valores das orientacoes do jogador.
  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3
  
  def initialize(nome,limites)
    @nome = nome
    @posicao = Posicao2D.new 0,0
    @orientacao = UP
    @limites = limites
    @flechas = 1
    @morreu = false
  end
  
  def virar(valor)
    @orientacao = (@orientacao + valor) % 4
  end
  
  def virar_esq
    virar(-1)
  end
  
  def virar_dir
    virar 1
  end
  
  def virar_para_cima
    @orientacao = UP
  end
  
  def virar_para_baixo
    @orientacao = DOWN
  end
  
  def virar_para_esquerda
    @orientacao = LEFT
  end
  
  def virar_para_direita
    @orientacao = RIGHT
  end
  
  def andar
    if pode_andar?
      case @orientacao
      when 0
        @posicao.y += 1
      when 1
        @posicao.x += 1
      when 2
        @posicao.y -= 1
      when 3
        @posicao.x -= 1
      end
    else
      raise StandardError,"Voce nao pode andar nessa direcao."
    end
  end
  
  def tem_flecha?
    return @flechas > 0
  end
  
  def atirar
    if (@flechas == 0)
      raise StandardError,"Voce nao tem mais flechas."
    end
    @flechas -= 1
    return calcula_pos_final
  end
  
  def set_posicao(posicao)
    @posicao = posicao
  end
  
  private
  
  def pode_andar?
    if (@posicao.x == @limites[0].first && @orientacao == LEFT) ||
       (@posicao.y == @limites[1].first && @orientacao == DOWN) ||
       (@posicao.x == @limites[0].last && @orientacao == RIGHT) ||
       (@posicao.y == @limites[1].last && @orientacao == UP)
      return false
    else
      return true
    end
  end
  
  def calcula_pos_final
    result = @posicao.dup
    case @orientacao
    when UP
      result.y = 9
    when RIGHT
      result.x = 9
    when DOWN
      result.y = 0
    when LEFT
      result.x = 0
    end
    return result
  end
  
  public
  
  def to_s
    case @orientacao
    when UP
      return "^"
    when RIGHT
      return ">"
    when DOWN
      return "v"
    else
      return "<"
    end
  end
end
