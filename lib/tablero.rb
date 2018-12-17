# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "casilla"
require_relative "titulo_propiedad"
require_relative "tipo_casilla"
require_relative "calle"

module ModeloQytetet
  class Tablero
    attr_accessor :casillas, :carcel
    def initialize()
      @casillas = Array.new
      @carcel = Casilla.new(10, 0, TipoCasilla::CARCEL)
      
    end
    
    def inicializar
      @casillas.clear
      @casillas << Casilla.new(0, 0, TipoCasilla::SALIDA)
      @casillas << Calle.new(1, TituloPropiedad.new("Calle Uno", 500, 50, 10, 250,30))
      @casillas << Calle.new(2, TituloPropiedad.new("Calle Dos", 550, 50, 10, 300,30))
      @casillas << Casilla.new(3, 0, TipoCasilla::SORPRESA)
      @casillas << Calle.new(4, TituloPropiedad.new("Calle Tres", 600, 60, 10, 350,30))
      @casillas << Calle.new(5, TituloPropiedad.new("Calle Cuatro", 650, 6, 10, 400,30))
      @casillas << Casilla.new(6, 100, TipoCasilla::JUEZ)
      @casillas << Calle.new(7, TituloPropiedad.new("Calle Cinco", 650, 70, 10, 450,30))
      @casillas << Calle.new(8, TituloPropiedad.new("Calle Seis", 700, 70, 10, 500,30))
      @casillas << Casilla.new(9, 0, TipoCasilla::SORPRESA)
      @casillas << @carcel
      @casillas << Casilla.new(11, 100, TipoCasilla::PARKING)
      @casillas << Calle.new(12, TituloPropiedad.new("Calle Siete", 750, 75, 10, 550,30))
      @casillas << Calle.new(13, TituloPropiedad.new("Calle Ocho", 800, 75, 10, 600,30))
      @casillas << Casilla.new(14, 0, TipoCasilla::SORPRESA)
      @casillas << Calle.new(15, TituloPropiedad.new("Calle Nueve", 850, 80, 10, 650,30))
      @casillas << Calle.new(16, TituloPropiedad.new("Calle Diez", 900, 90, 10, 700,30))
      @casillas << Casilla.new(17, 100, TipoCasilla::IMPUESTO)
      @casillas << Calle.new(18, TituloPropiedad.new("Calle Once", 950, 95, 10, 725,30))
      @casillas << Calle.new(19, TituloPropiedad.new("Calle Doce", 1000, 100, 10, 750,30))
    end
    
    def es_casilla_carcel(numero_casilla)
      if(numero_casilla == @carcel.numero_casilla)
        return true
      else 
        return false
      end
    end
    
    def obtener_casilla_final(casilla, desplazamiento)
      @casillas.at((casilla.numero_casilla+desplazamiento)%19)
    end
    
    def obtener_casilla_numero(numero_casilla)
      if (numero_casilla >= 0 && numero_casilla < 20)
        return @casillas.at(numero_casilla)
      end
    end
    
    def to_s
      str = String.new
      str<< "Casillas: \n"
      for s in @casillas
        str<< "#{s} \n"
      end
      str
    end
        
    end
  end
