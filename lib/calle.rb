# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "tipo_casilla"
require_relative "titulo_propiedad"
require_relative "casilla"
module ModeloQytetet
  class Calle < Casilla
    attr_accessor :titulo
    def initialize(num_c, t)
      super(num_c,t.precio_compra, TipoCasilla::CALLE)
      @titulo = t
    end
    
    def asignar_propietario(jugador)
      @titulo.propietario = jugador
      return @titulo
    end
    
    def pagar_alquiler
      coste_alquiler=@titulo.pagar_alquiler
      return coste_alquiler
    end

    def soy_edificable
      return true
    end
    
    def tengo_propietario
      @titulo.tengo_propietario
    end
    
    def to_s
      str = String.new
      str << super.to_s
      str<< "\n  Titulo: #{@titulo}"
      return str 
    end
  end
end
