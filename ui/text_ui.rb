require 'ui/wumpus_interface'

class TextUI < WumpusInterface
  def initialize(jogo)
    super(jogo)
  end
  
  def put
    @jogo.mover_jogador
    @jogo.atualiza
    puts @jogo.to_s
    sleep 0.4
  end
end
