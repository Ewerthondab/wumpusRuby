require 'tabuleiro'
require 'jogador'
require 'monstro'

class Wumpus
  attr_reader :tabuleiro
  attr_reader :jogador
  attr_reader :monstro
  
  GANHOU = 1
  PERDEU = 2
  NADA = 3
  
  def initialize(nome_jogador,nome_monstro = "Wumpus",tamanho = 4)
    @jogador = Jogador.new nome_jogador,[0...tamanho,0...tamanho]
    @monstro = Monstro.new nome_monstro,(rand * 10 % tamanho).to_i,(rand * 10 % tamanho).to_i
    @tabuleiro = Tabuleiro.new @jogador.posicao,@monstro.posicao,tamanho
    if $ARQUIVO != nil
      linhas = []
      File.open($ARQUIVO) do |handle|
        handle.each_line do |cada_linha|
          linhas.push cada_linha
        end
      end
      @tabuleiro.cria_com_elementos linhas
      @jogador.set_posicao @tabuleiro.pos_jogador
      @monstro.set_posicao @tabuleiro.pos_monstro
    end
    @condicao_jogo = NADA
    atualiza_estado_jogo
  end
  
  def mover_jogador
    begin
      @jogador.andar
    rescue StandardError => exc
      puts "Erro: #{exc}."
    end
  end
  
  def rodar_jogador_esquerda
    @jogador.virar_esq
  end
  
  def rodar_jogador_direita
    @jogador.virar_dir
  end
  
  def rodar_aleatorio
    x = rand * 10 % 4
    for i in 0...x
      rodar_jogador_esquerda
    end
  end
  
  def atirar_flecha
    begin
      @pos_flecha = @jogador.atirar
    rescue StandardError => exc
      puts "Erro: #{exc}."
    end
  end
  
  def atualiza
    atualiza_estado_jogo
    atualiza_condicao_jogo
  end
  
  def ganhou?
    return @condicao_jogo == GANHOU
  end
  
  def perdeu?
    return @condicao_jogo == PERDEU
  end
  
  def terminou?
    return @condicao_jogo != NADA
  end
  
  def get_casa_em(x,y)
    return @tabuleiro.get_casa_em(x,y)
  end
  
  def get_casa_jogador
    return @tabuleiro.get_casa(@jogador.posicao)
  end
  
  def get_num_visitas(posicao)
    return @tabuleiro.get_casa(posicao).num_visitas
  end
  
  def get_tamanho_tabuleiro
    return @tabuleiro.tamanho
  end
  
  private
  
  def atualiza_estado_jogo
    atualiza_estado_tabuleiro
    atualiza_estado_jogador
    atualiza_estado_monstro
  end
  
  def atualiza_estado_tabuleiro
    if @tabuleiro.pos_jogador != @jogador.posicao
      @tabuleiro.pos_jogador = @jogador.posicao
    end
    @tabuleiro.set_casa_visitada(@jogador.posicao)
    @tabuleiro.inc_visita(@jogador.posicao)
  end
  
  def atualiza_estado_jogador
    if @tabuleiro.tem_buraco_em?(@jogador.posicao) ||
       @tabuleiro.tem_monstro_em?(@jogador.posicao)
      @jogador.morreu = true
    end
    if @tabuleiro.tem_ouro_em?(@jogador.posicao)
      @jogador.tem_ouro = true
      @tabuleiro.remove_ouro!
    end
  end
  
  def atualiza_estado_monstro
    if @pos_flecha != nil
      if @pos_flecha.x == @monstro.posicao.x || @pos_flecha.y == @monstro.posicao.y
        @monstro.morreu = true
      end
    end
  end
  
  def atualiza_condicao_jogo
    if @monstro.morreu && @jogador.tem_ouro
      @condicao_jogo = GANHOU
    elsif (!@jogador.tem_flecha? && !@monstro.morreu) || @jogador.morreu
      @condicao_jogo = PERDEU
    else
      @condicao_jogo = NADA
    end
  end
  
  public
  
  def to_s
    return @tabuleiro.to_s(@jogador,@monstro)
  end
end
