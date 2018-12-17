# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require "singleton"
require_relative "qytetet.rb"
require_relative "MenuOpcion.rb"
require_relative "estado_juego.rb"
require_relative "metodo_salir_carcel.rb"

module ControladorQytetet
  OpcionMenu = [:INICIARJUEGO,:JUGAR,:APLICARSORPRESA,:INTENTARSALIRCARCELPAGANDOLIBERTAD,:INTENTARSALIRCARCELTIRANDODADO,:COMPRARTITULOPROPIEDAD,:HIPOTECARPROPIEDAD,:CANCELARHIPOTECA,
  :EDIFICARCASA,:EDIFICARHOTEL,:VENDERPROPIEDAD,:PASARTURNO,:OBTENERRANKING,:TERMINARJUEGO,:MOSTRARJUGADORACTUAL,:MOSTRARJUGADORES,:MOSTRARTABLERO ]
  
  class ControladorQytetet
    include Singleton
    include ModeloQytetet
   
    def initialize
      @nombre_jugadores = Array.new
      @modelo = Qytetet.instance
    end
    
    def set_nombre_jugadores(nom_jugadores)
      @nombre_jugadores = nom_jugadores
    end
    
    def obtener_operaciones_juego_validas
      operaciones_validas = Array.new
      estado = @modelo.estado
      
      operaciones_validas.clear
      
      if @modelo.jugadores.empty?
        operaciones_validas << OpcionMenu.index(:INICIARJUEGO)
      else
        case estado
        when ModeloQytetet::EstadoJuego::JA_CONSORPRESA
          operaciones_validas << OpcionMenu.index(:APLICARSORPRESA)
        when ModeloQytetet::EstadoJuego::ALGUNJUGADORENBANCARROTA
          operaciones_validas << OpcionMenu.index(:OBTENERRANKING)
        when ModeloQytetet::EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
          operaciones_validas << OpcionMenu.index(:PASARTURNO)
          operaciones_validas << OpcionMenu.index(:HIPOTECARPROPIEDAD)
          operaciones_validas << OpcionMenu.index(:VENDERPROPIEDAD)
          operaciones_validas << OpcionMenu.index(:CANCELARHIPOTECA)
          operaciones_validas << OpcionMenu.index(:EDIFICARCASA)
          operaciones_validas << OpcionMenu.index(:EDIFICARHOTEL)
          operaciones_validas << OpcionMenu.index(:COMPRARTITULOPROPIEDAD)
        when ModeloQytetet::EstadoJuego::JA_PUEDEGESTIONAR
          operaciones_validas << OpcionMenu.index(:PASARTURNO)
          operaciones_validas << OpcionMenu.index(:HIPOTECARPROPIEDAD)
          operaciones_validas << OpcionMenu.index(:VENDERPROPIEDAD)
          operaciones_validas << OpcionMenu.index(:CANCELARHIPOTECA)
          operaciones_validas << OpcionMenu.index(:EDIFICARCASA)
          operaciones_validas << OpcionMenu.index(:EDIFICARHOTEL)
        when ModeloQytetet::EstadoJuego::JA_PREPARADO
          operaciones_validas << OpcionMenu.index(:JUGAR)
        when ModeloQytetet::EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
          operaciones_validas << OpcionMenu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD)
          operaciones_validas << OpcionMenu.index(:INTENTARSALIRCARCELTIRANDODADO)
        when ModeloQytetet::EstadoJuego::JA_ENCARCELADO
          operaciones_validas << OpcionMenu.index(:PASARTURNO)
        end
      end
      
      
      operaciones_validas << OpcionMenu.index(:MOSTRARJUGADORACTUAL)
      operaciones_validas << OpcionMenu.index(:MOSTRARJUGADORES)
      operaciones_validas << OpcionMenu.index(:MOSTRARTABLERO)
      operaciones_validas << OpcionMenu.index(:TERMINARJUEGO)
      
      return operaciones_validas
    end
    
    def necesita_elegir_casilla(op_menu)
      if(OpcionMenu.at(op_menu) == :HIPOTECARPROPIEDAD || OpcionMenu.at(op_menu) == :CANCELARHIPOTECA ||
         OpcionMenu.at(op_menu) == :EDIFICARCASA || OpcionMenu.at(op_menu) == :EDIFICARHOTEL ||
         OpcionMenu.at(op_menu) == :VENDERPROPIEDAD)
         return true
      else
         return false
      end
    end
    
    def obtener_casillas_validas(op_menu)
      lista_casillas = Array.new
     
      if(OpcionMenu.at(op_menu) == :EDIFICARCASA || OpcionMenu.at(op_menu) == :EDIFICARHOTEL ||
         OpcionMenu.at(op_menu) == :VENDERPROPIEDAD)
       lista_casillas = @modelo.obtener_propiedades_jugador
      else
        case OpcionMenu.at(op_menu)
        when :HIPOTECARPROPIEDAD
          lista_casillas = @modelo.obtener_propiedades_jugador_segun_estado_hipoteca(false)
        when :CANCELARHIPOTECA
          lista_casillas = @modelo.obtener_propiedades_jugador_segun_estado_hipoteca(true)
        end
      end
      
      return lista_casillas
    end
    
    def realizar_operacion(opcion_elegida, casilla_elegida)
      informacion = ""

      case OpcionMenu.at(opcion_elegida)
        when :INICIARJUEGO
          informacion += "Comenzamos a jugar" + "\n"
          @modelo.inicializar_juego(@nombre_jugadores)
          informacion += "Juego inicializado..." + "\n"        
        when :APLICARSORPRESA
          informacion += "Carta Sorpresa: " + "\n" + @modelo.carta_actual.to_s
          @modelo.aplicar_sorpresa
        when :JUGAR
          @modelo.jugar          
          informacion += @modelo.jugador_actual.casilla_actual.to_s
        when :INTENTARSALIRCARCELPAGANDOLIBERTAD
          @modelo.intentar_salir_carcel(MetodoSalirCarcel::PAGANDOLIBERTAD)
        when :INTENTARSALIRCARCELTIRANDODADO
          @modelo.intentar_salir_carcel(MetodoSalirCarcel::TIRANDODADO)
        when :COMPRARTITULOPROPIEDAD
          @modelo.comprar_titulo_propiedad
        when :HIPOTECARPROPIEDAD
          @modelo.hipotecar_propiedad(casilla_elegida)
        when :CANCELARHIPOTECA
          @modelo.cancelar_hipoteca(casilla_elegida)
        when :EDIFICARCASA
          @modelo.edificar_casa(casilla_elegida)
        when :EDIFICARHOTEL
          @modelo.edificar_hotel(casilla_elegida)
        when :VENDERPROPIEDAD
          @modelo.vender_propiedad(casilla_elegida)
        when :PASARTURNO
          @modelo.siguiente_jugador
          informacion += "Turno para " + @modelo.jugador_actual.nombre
        when :OBTENERRANKING
          puts @modelo.obtener_ranking.to_s
        when :TERMINARJUEGO
          informacion += "JUEGO TERMINADO"
        when :MOSTRARJUGADORACTUAL
          puts @modelo.jugador_actual.to_s
        when :MOSTRARJUGADORES
          for i in @modelo.jugadores
            puts i.to_s
          end
        when :MOSTRARTABLERO
          puts @modelo.tablero.to_s
      end
      return informacion
    end
  end
end
