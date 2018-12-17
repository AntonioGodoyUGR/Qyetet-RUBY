# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "jugador.rb"

module ModeloQytetet
  class Especulador < Jugador
    attr_accessor :fianza
    
    def self.copia(unJugador, f)
      e = super(unJugador)
      e.fianza = f
      return e      
    end

    def pagar_fianza
      puedo_pagar = false
      
      puedo_pagar = tengo_saldo(@fianza)
      if puedo_pagar
        modificar_saldo(-@fianza)
      end
      
      return puedo_pagar
    end
    
    def pagar_impuesto()
      modificar_saldo(-@casilla_actual.coste)
    end
    
    def convertirme(f)
      @fianza = f
      return self
    end
    
    def debo_ir_a_carcel
      if super.tengo_carta_libertad && !pagar_fianza
        return true
      else
        return false
      end
    end
    
    def puedo_edificar_casa(titulo)
      puedo_edificar = false
      num_casas = titulo.num_casas
      coste_edificar_casa = titulo.precio_edificar
      tengo_saldo = tengo_saldo(coste_edificar_casa)
      
      if num_casas < 8 && tengo_saldo
        puedo_edificar = true
      end
      
      return puedo_edificar
    end
    
    def puedo_edificar_hotel(titulo)
      puedo_edificar = false
      num_casas = titulo.num_casas
      num_hoteles = titulo.num_hoteles
      coste_edificar_hotel = titulo.precio_edificar
      tengo_saldo = tengo_saldo(coste_edificar_hotel)
      
      if num_hoteles < 8 && num_casas >= 4 && tengo_saldo
        puedo_edificar = true
      end
      
      return puedo_edificar
    end
    
    def to_s
      return super + "\n  Fianza #{@fianza}"
    end
    
    
  
  end
end
