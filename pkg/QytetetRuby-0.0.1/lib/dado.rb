# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require "singleton"


module ModeloQytetet
  class Dado
    include Singleton
    attr_accessor :valor
    def initialize
      @valor = 0
    end
    
    def tirar
      @valor = rand(6)+1
      return @valor
    end
    
    
  end
end
