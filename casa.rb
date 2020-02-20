class Casa
  attr_reader :visitada
  attr_reader :num_visitas
  
  # elementos presentes em uma casa.
  BURACO = "B"
  OURO = "O"
  MONSTRO = "M"
  CATINGA = "c"
  LUZ = "l"
  BRISA = "b"
  DESCONHECIDO = "?"
  
  def initialize
    @coisas = [" "]
    @visitada = false
    @num_visitas = 0
  end
  
  def push(coisa)
    if coisa.eql?(BURACO)
      if !@coisas.include?(OURO) && !@coisas.include?(MONSTRO)
        @coisas.push coisa
      end
    elsif coisa.eql?(MONSTRO)
      if !@coisas.include?(OURO) && !@coisas.include?(BURACO)
        @coisas.push coisa
      end
    elsif coisa.eql?(OURO)
      if !@coisas.include?(MONSTRO) && !@coisas.include?(BURACO)
        @coisas.push coisa
      end
    else
      @coisas.push coisa
    end
  end
  
  def inc_visita
    @num_visitas += 1
  end
  
  def set_visitada
    @visitada = true
  end
  
  def tem_buraco?
    return @coisas.include?(BURACO)
  end
  
  def tem_ouro?
    return @coisas.include?(OURO)
  end
  
  def remove_ouro!
    @coisas.delete(OURO)
  end
  
  def tem_monstro?
    @coisas.include?(MONSTRO)
  end
  
  def tem_brisa?
    return @coisas.include?(BRISA)
  end
  
  def tem_catinga?
    return @coisas.include?(CATINGA)
  end
  
  def tem_luz?
    return @coisas.include?(LUZ)
  end
  
  def vazia?
    return @coisas.size == 1
  end
  
  def to_s
    if !visitada && !$DEBUG
      return DESCONHECIDO
    elsif tem_buraco?
      return BURACO
    elsif tem_ouro?
      return OURO
    elsif tem_monstro?
      return MONSTRO
    else
      return @coisas.last
    end
  end
end
