# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "tipo_casilla"

module ModeloQytetet
  class Casilla
    attr_accessor :numero_casilla, :coste, :tipo
    def initialize(num_casilla, cost, t)
      @numero_casilla = num_casilla
      @coste = cost
      @tipo = t
    end
   
    def soy_edificable
      return false
    end
    
    def to_s
      str = String.new
        str<<"Casilla{ " +
                "\n  Numero_casilla: #{@numero_casilla}" +
                "\n  Coste: #{@coste}" +
                "\n  Tipo: #{@tipo}"
      return str 
    end
    
  end
end
