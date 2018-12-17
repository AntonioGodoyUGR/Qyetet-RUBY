# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module ModeloQytetet
  class Sorpresa
    attr_accessor :texto, :tipo, :valor
    def initialize(t, v, type)
      @texto = t
      @tipo = type
      @valor = v
    end
    
    def get_texto
      @texto
    end
    
    def get_tipo
      @tipo
    end
    
    def get_valor
      @valor
    end
    
    def to_s
      "Sorpresa{
      Texto: #{@texto}
      Valor: #{@valor}
      Tipo: #{@tipo}
      }"
    end
  end
end
