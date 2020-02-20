require 'rubygame'
require 'ui/wumpus_interface'
require 'ui/graphic_elements'
require 'casa'

class GUI < WumpusInterface
  TAM_TILE = 32
  
  def initialize(jogo)
    super(jogo)
    Rubygame.init
    @tamanho = @jogo.get_tamanho_tabuleiro
    init_screen
    @event_queue = Rubygame::Queue.instance
    @elements = GraphicElements.new
  end
  
  def put
    checa_eventos
    update
    sleep 0.1
  end
  
  private
  
  def init_screen
    @screen = Rubygame::Screen.set_mode get_coords(@tamanho)
    @screen.set_caption "Wumpus world"
  end
  
  def get_coords(x,y = nil)
    return [x * TAM_TILE,(y != nil ? y : x) * TAM_TILE]
  end
  
  def checa_eventos
    @event_queue.get.each do |event|
	   	case(event)
		  when Rubygame::QuitEvent
		    exit
  		when Rubygame::MouseDownEvent
  	    @jogo.mover_jogador
        @jogo.atualiza
  		end
  	end
  end
  
  def update
    draw_tabuleiro
    draw_elementos
    @screen.update
  end
  
  def draw_tabuleiro
    for x in 0...@tamanho
      for y in 0...@tamanho
        if (x + y) % 2 == 0
          @elements.tile1.blit @screen,get_coords(x,y)
        else
          @elements.tile2.blit @screen,get_coords(x,y)
        end
      end
    end
  end
  
  def draw_elementos
    for x in 0...@tamanho
      for y in 0...@tamanho
        if @jogo.jogador.posicao.eql_x_y?(x,@tamanho - y - 1)
          draw @elements.jogador(@jogo.jogador.orientacao),x,y
        else
          case(@jogo.get_casa_em(x,@tamanho - y - 1).to_s)
          when Casa::MONSTRO
            draw @elements.monstro,x,y unless @jogo.monstro.morreu
          when Casa::OURO
            draw @elements.ouro,x,y
          when Casa::BURACO
            draw @elements.buraco,x,y
          when Casa::BRISA
            draw @elements.brisa,x,y
          when Casa::CATINGA
            draw @elements.catinga,x,y
          when Casa::LUZ
            draw @elements.luz,x,y
          when Casa::DESCONHECIDO
            draw @elements.desconhecido,x,y
          end
        end
      end
    end
  end
  
  def draw(elemento,x,y)
    x_pos = x*TAM_TILE - (elemento.width - TAM_TILE).abs
    y_pos = y*TAM_TILE - (elemento.height - TAM_TILE).abs
    elemento.blit @screen,[x_pos,y_pos]
  end
end
