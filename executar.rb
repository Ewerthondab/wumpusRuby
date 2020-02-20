require 'thread'
require 'wumpus_ia'
require 'sound'

$ARQUIVO = "jogo.txt"
$DEBUG = true
Win32::Sound.play "lost.wav"
jogo_inteligente = WumpusIA.new "despomba","Wumpus",5
begin
  require 'ui/gui'
  interface = GUI.new jogo_inteligente
rescue StandardError => exc
  puts "Erro: #{exc}. Iniciando jogo em modo texto."
  require 'ui/text_ui'
  interface = TextUI.new jogo_inteligente
rescue LoadError => exc
  puts "Erro: #{exc}. Iniciando jogo em modo texto."
  require 'ui/text_ui'
  interface = TextUI.new jogo_inteligente
end
jogo_thread = Thread.new do
  # -------------- loop principal -------------------
  while !jogo_inteligente.terminou?
    interface.put
  end
  interface.put
  # -------------------------------------------------
end
jogo_thread.join

if jogo_thread.stop?
  if jogo_inteligente.ganhou?
    puts "ganhou!!!"
    Win32::Sound.play "palmas.mid"
  end
  if jogo_inteligente.perdeu?
    puts "perdeu!!!"
    Win32::Sound.play "marcha.wav"
  end
end

