# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#
#require_relative "sorpresa"
#require_relative "qytetet"
#require_relative "tablero"
#require_relative "casilla"
#require_relative "titulo_propiedad"
#require_relative "estado_juego"
#require_relative "metodo_salir_carcel"
#
#module ModeloQytetet
#  class PruebaQytetet
#    @@juego = Qytetet.instance
#    def initialize
#      
#    end
#    
#    def self.mayor_que_cero(m)
#      mazo = Array.new
#      
#      for s in m
#        if s.valor > 0
#          mazo << s
#        end
#      end
#      
#      return mazo
#    end
#    
#    def get_casillas_ir_a_casilla(m)
#      mazo = Array.new
#      
#      for s in m
#        if s.tipo == TipoSorpresa::IRACASILLA
#          mazo << s
#        end
#      end
#      
#      return mazo
#    end
#    
#    def self.obtener_nombres_jugadores
#      
#      nombres = Array.new
#      puts "Introduzca numero de Jugadores: "
#      num = gets.chomp.to_i
#      i = 0
#      while i < num
#        puts "Introduzca nombre del jugador: "
#        nom = gets.chomp
#        nombres << nom
#        i += 1
#      end
#      
#      return nombres
#      
#    end
#    
#    def PruebaQytetet.main
#      @@juego.inicializar_juego(obtener_nombres_jugadores)
#      
##      puts @@juego.mazo
##      puts @@juego.tablero
##      puts @@juego.jugadores
#     
##      puts @@juego.jugador_actual
##      @@juego.mover(2)
##      @@juego.comprar_titulo_propiedad
##     
##      @@juego.siguiente_jugador
##      @@juego.mover(5)
##      @@juego.comprar_titulo_propiedad
##      @@juego.edificar_casa(@@juego.jugador_actual.casilla_actual.numero_casilla)
##      puts @@juego.jugador_actual
##      @@juego.siguiente_jugador
##      @@juego.mover(5)
##      puts @@juego.jugador_actual
##      
##      @@juego.obtener_ranking
##      puts @@juego.jugadores
#
##      puts "Compro e hipoteco"
##      @@juego.comprar_titulo_propiedad
##      @@juego.hipotecar_propiedad(@@juego.jugador_actual.casilla_actual.numero_casilla)
##      puts @@juego.jugador_actual
##      
##      puts "Cancelo hipoteca"
##      @@juego.cancelar_hipoteca(@@juego.jugador_actual.casilla_actual.numero_casilla)
##      puts @@juego.jugador_actual
##      
##      puts"Edifico casas"
##      @@juego.edificar_casa(@@juego.jugador_actual.casilla_actual.numero_casilla)
##      @@juego.edificar_casa(@@juego.jugador_actual.casilla_actual.numero_casilla)
##      @@juego.edificar_casa(@@juego.jugador_actual.casilla_actual.numero_casilla)
##      @@juego.edificar_casa(@@juego.jugador_actual.casilla_actual.numero_casilla)
##      puts @@juego.jugador_actual
#      
##      puts"Edifico hotel"
##      @@juego.edificar_hotel(@@juego.jugador_actual.casilla_actual.numero_casilla)
##      puts @@juego.jugador_actual
#      
##      puts "Vendo propiedad"     
##      @@juego.vender_propiedad(@@juego.jugador_actual.casilla_actual.numero_casilla)
#      @@juego.siguiente_jugador
##      puts @@juego.jugador_actual
#
#      puts @@juego.carta_actual
#      @@juego.aplicar_sorpresa
#      
#      puts @@juego.jugador_actual
#      puts @@juego.mazo
#      
#      
#
#    end
#    
#    
#  end
#  PruebaQytetet.main
#end
#
