class Sequenciador
  attr_reader :index,:lim
  
  PADRAO = 0
  VAI_E_VOLTA = 1
  
  def initialize(lim,tipo = nil)
    @lim = lim
    @tipo = tipo != nil ? tipo : PADRAO
    @index = @tipo == VAI_E_VOLTA ? 1 : -1
    @fator = @tipo == VAI_E_VOLTA ? -1 : 1
  end
  
  def next
    case(@tipo)
    when VAI_E_VOLTA
      @fator *= -1 unless (1...(@lim - 1)).include? @index
      @index += @fator
    else
      @index += 1
      @index %= @lim
    end
    return @index
  end
end
