require 'wumpus'

class WumpusIA < Wumpus
  def initialize(nome_jogador,nome_monstro = "Wumpus",tamanho = 4)
    super(nome_jogador,nome_monstro,tamanho)
    @pos_monstro_d = @monstro.posicao
    @pos_buracos_d = []
    @contador_catinga = 0
    @contador_brisa = 0
  end
  
  def mover_jogador
    @casas_possiveis = get_possiveis
    
    if (get_casa_jogador.tem_brisa? || get_casa_jogador.tem_catinga?) &&
       get_casa_jogador.num_visitas <= 1
      rodar_jogador_esquerda
      rodar_jogador_esquerda
      super
      return
    end
    
    if @pos_monstro_d != nil
      if (@pos_monstro_d.x == @jogador.posicao.x || @pos_monstro_d.y == @jogador.posicao.y) && !@monstro.morreu
        virar_para_monstro
        atirar_flecha
        return
      end
    end
    
    @casas_possiveis.each do |key,value|
      if value.tem_catinga? && get_num_visitas(key) > 1
        @contador_catinga += 1
        @casas_possiveis.delete(key)
      elsif value.tem_brisa? && get_num_visitas(key) > 1
        @contador_brisa += 1
        @casas_possiveis.delete(key)
      elsif get_num_visitas(key) > 30
        @casas_possiveis.delete(key)
      end
    end
    
    if @casas_possiveis.size == 0
      rodar_aleatorio
      super
    else
      virar_para_as_possiveis
      super
    end
    
    if @contador_brisa >= 3
      brisas = []
      for x in 0...@tabuleiro.tamanho
        for y in 0...@tabuleiro.tamanho
          posicao = Posicao2D.new(x,y)
          brisas.push posicao if(@tabuleiro.get_casa(posicao).tem_brisa? && brisas.size < 3 && get_num_visitas(posicao) <= 1)
        end
      end
      posicao_buraco = get_posicao_elemento(brisas)
      if posicao_buraco != nil && !inclue?(@pos_buracos_d,posicao_buraco)
        @pos_buracos_d.push posicao_buraco
      end
      @contador_brisa = 0
    end
    
    if @contador_catinga >= 3
      catingas = []
      for x in 0...@tabuleiro.tamanho
        for y in 0...@tabuleiro.tamanho
          posicao = Posicao2D.new(x,y)
          catingas.push posicao if(@tabuleiro.get_casa(posicao).tem_catinga? && catingas.size < 3 && get_num_visitas(posicao) <= 1)
        end
      end
      posicao_monstro = get_posicao_elemento(catingas)
      if posicao_monstro != nil
        @pos_monstro_d = posicao_monstro
      end
    end
  end
  
  private
  
  def get_possiveis
    @tabuleiro.get_ao_redor
  end
  
  def get_posicao_elemento(coisas)
    x_elemento = -1;
    y_elemento = -1;
    unless (coisas[0].x == coisas[1].x && coisas[1].x == coisas[2].x) ||
           (coisas[0].y == coisas[1].y && coisas[1].y == coisas[2].y)
      if coisas[0].x == coisas[1].x
        x_elemento = coisas[0].x
      elsif coisas[0].x == coisas[2].x
        x_elemento = coisas[0].x
      elsif coisas[1].x == coisas[2].x
        x_elemento = coisas[1].x
      elsif coisas[0].y == coisas[1].y
        y_elemento = coisas[0].y
      elsif coisas[0].y == coisas[2].y
        y_elemento = coisas[0].y
      elsif coisas[1].y == coisas[2].y
        y_elemento = coisas[1].y
      end
      if x_elemento == -1
        x_elemento = (coisas[0].x + coisas[1].x + coisas[2].x) / 3
      elsif y_elemento == -1
        y_elemento = (coisas[0].y + coisas[1].y + coisas[2].y) / 3
      end
    end
    if x_elemento != -1 && y_elemento != -1
      return Posicao2D.new(x_elemento,y_elemento)
    else
      return nil
    end
  end
  
  def virar_para_as_possiveis
    pos_aleatoria = rand * 10 % @casas_possiveis.size
    posicao_escolhida = @casas_possiveis.keys[pos_aleatoria]
    virar_para_o_lado_certo(posicao_escolhida)
  end
  
  def virar_para_monstro
    virar_para_o_lado_certo(@pos_monstro_d)
  end
  
  def virar_para_o_lado_certo(destino)
    if destino.y < @jogador.posicao.y
      @jogador.virar_para_baixo
    elsif destino.x < @jogador.posicao.x
      @jogador.virar_para_esquerda
    elsif destino.y > @jogador.posicao.y
      @jogador.virar_para_cima
    else
      @jogador.virar_para_direita
    end
  end
  
  def inclue?(colecao,elemento)
    colecao.each do |cada|
      return true if cada.eql? elemento
    end
    return false
  end
end
