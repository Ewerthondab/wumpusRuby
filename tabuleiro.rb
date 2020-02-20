require 'casa'
require 'posicao_2d'

class Tabuleiro
  attr_reader :casas
  attr_reader :tamanho
  attr_reader :pos_ouro
  attr_reader :pos_monstro
  attr_accessor :pos_jogador
  
  # elementos presentes no tabuleiro.
  CATINGA = Casa::CATINGA
  LUZ = Casa::LUZ
  BRISA = Casa::BRISA
  BURACO = Casa::BURACO
  
  def initialize(pos_jogador,pos_monstro,tam = 4)
    @casas = [[]] # array bidimensional.
    @tamanho = tam
    @num_buracos = tam - 1
    inicializa_casas
    @pos_monstro = pos_monstro
    get_casa(@pos_monstro).push Casa::MONSTRO
    @pos_jogador = pos_jogador
    inicializa_pos_ouro
    
    preenche_catinga
    preenche_luz
    preenche_buracos
    preenche_brisa
  end
  
  def cria_com_elementos(elementos)
    @casas = [[]] # array bidimensional.
    @tamanho = elementos.size
    @num_buracos = @tamanho - 1
    inicializa_casas
    for y in 0...elementos.size
      for x in 0...elementos.size
        elemento = elementos[y][x..x]
        if !elemento.eql?("J") && !elemento.eql?("-")
          @casas[x][y].push elemento
        end
        if elemento.eql? Casa::MONSTRO
          @pos_monstro = Posicao2D.new x,y
        elsif elemento.eql? Casa::OURO
          @pos_ouro = Posicao2D.new x,y
        elsif elemento.eql? "J"
          @pos_jogador = Posicao2D.new x,y
        elsif elemento.eql? Casa::BURACO
          @num_buracos += 1
        end
      end
    end
    preenche_catinga
    preenche_luz
    preenche_brisa
  end
  
  def get_casa_em(x,y)
    return @casas[x][y]
  end
  
  def get_casa(posicao)
    return @casas[posicao.x][posicao.y]
  end
  
  def set_casa_visitada(posicao)
    @casas[posicao.x][posicao.y].set_visitada
  end
  
  def inc_visita(posicao)
    @casas[posicao.x][posicao.y].inc_visita
  end
    
  def tem_ouro_em?(posicao)
    return get_casa(posicao).tem_ouro?
  end
  
  def remove_ouro!
    get_casa(@pos_ouro).remove_ouro!
  end
  
  def tem_buraco_em?(posicao)
    return get_casa(posicao).tem_buraco?
  end
  
  def tem_monstro_em?(posicao)
    return get_casa(posicao).tem_monstro?
  end
  
  def tem_monstro?(x,y)
    return @casas[x][y].tem_monstro?
  end
  
  private
  
  def inicializa_casas
    for k in 0...@tamanho
      @casas.push []
      for i in 0...@tamanho
        @casas[k].push Casa.new
      end
    end
  end
  
  def inicializa_pos_ouro
    ouro_x = rand * 10 % @tamanho
    ouro_y = rand * 10 % @tamanho
    @casas[ouro_x][ouro_y].push Casa::OURO
    @pos_ouro = Posicao2D.new ouro_x,ouro_y
  end
  
  def preenche_catinga
    for i in 0...@tamanho
      for j in 0...@tamanho
        preenche_ao_redor(i,j,CATINGA) if tem_monstro?(i,j)
      end
    end
  end
  
  def preenche_luz
    for i in 0...@tamanho
      for j in 0...@tamanho
        preenche_ao_redor(i,j,LUZ) if @casas[i][j].tem_ouro?
      end
    end
  end
  
  def preenche_buracos
    for i in 1..@num_buracos
      x = (rand * 10 % @tamanho).to_i
      y = (rand * 10 % @tamanho).to_i
      @casas[x][y].push BURACO
    end
  end
  
  def preenche_brisa
    for i in 0...@tamanho
      for j in 0...@tamanho
        preenche_ao_redor(i,j,BRISA) if @casas[i][j].tem_buraco?
      end
    end
  end
  
  def preenche_ao_redor(x,y,coisa)
    @casas[x][y - 1].push coisa if y > 0
    @casas[x][y + 1].push coisa if y < @tamanho - 1
    @casas[x + 1][y].push coisa if x < @tamanho - 1
    @casas[x - 1][y].push coisa if x > 0
  end
  
  public
  
  def get_ao_redor
    result = {}
    result[Posicao2D.new(@pos_jogador.x - 1,@pos_jogador.y)] = @casas[@pos_jogador.x - 1][@pos_jogador.y] if @pos_jogador.x > 0
    result[Posicao2D.new(@pos_jogador.x + 1,@pos_jogador.y)] = @casas[@pos_jogador.x + 1][@pos_jogador.y] if @pos_jogador.x < @tamanho - 1
    result[Posicao2D.new(@pos_jogador.x,@pos_jogador.y - 1)] = @casas[@pos_jogador.x][@pos_jogador.y - 1] if @pos_jogador.y > 0
    result[Posicao2D.new(@pos_jogador.x,@pos_jogador.y + 1)] = @casas[@pos_jogador.x][@pos_jogador.y + 1] if @pos_jogador.y < @tamanho - 1
    
    return result
  end
  
  def to_s(jogador,monstro)
    result = ""
    for k in 0...@tamanho
      result += "   "
      for i in 0...@tamanho
        result += "+---"
      end
      result += "+\n"
      result += sprintf("%2d",@tamanho - k - 1) + " | "
      for i in 0...@tamanho
        result += imprime_casa(i,@tamanho - k - 1,jogador,monstro) + " | "
      end
      result += "\n"
    end
    result += "   "
    for i in 0...@tamanho
      result += "+---"
    end
    result += "+\n"
    result += "    "
    for i in 0...@tamanho
      result += sprintf("%2d",i) + "  "
    end
    return result
  end
  
  private
  
  def imprime_casa(x,y,jogador,monstro)
    if get_casa(Posicao2D.new(x,y)).tem_monstro? && monstro.morreu
      return " "
    elsif @pos_jogador.y == y && @pos_jogador.x == x
      return jogador.to_s
    else
      return @casas[x][y].to_s
    end
  end
end
