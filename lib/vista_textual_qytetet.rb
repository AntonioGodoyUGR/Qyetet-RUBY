# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "controlador_qytetet.rb"
require_relative "qytetet.rb"
require_relative "MenuOpcion.rb"

module VistaTextualQytetet
  class VistaTextualQytetet
    include ControladorQytetet
    
    @@controlador = ControladorQytetet.instance
    def initialize
      
    end
    
    def leer_valor_correcto(valores_correctos)
      valido = false
      begin 
        puts "Introduzca un valor valido: "
        lectura = gets.chomp
        
        for i in valores_correctos
          if lectura == i
            valido = true
          end
        end
        
        if !valido
          puts "ERROR! Seleccion erronea \n"
        end
        
      end while(!valido)
      return lectura
    end
    
    def elegir_operacion
      lista = @@controlador.obtener_operaciones_juego_validas
      lista_a_string = Array.new
      puts "Que desea realizar: \n"
      
      for i in lista
        lista_a_string << i.to_s
        puts i.to_s + " " + OpcionMenu.at(i).to_s + "\n"
      end
      
      return Integer(leer_valor_correcto(lista_a_string))
    end
    
    def elegir_casilla(op_menu)
      lista = @@controlador.obtener_casillas_validas(op_menu)
      
      if(!lista.empty?)
        puts lista.to_s 
        
        valido = false
        
        begin
          puts "Introduzca la casilla a elegir: "
          lectura = gets.chomp.to_i
          
          for i in lista
            if lectura == i
              valido = true
            end
          end
          
          if(valido)
            return lectura
          end
        end while(!valido)
      else
        return -1
      end
    end
    
    def obtener_nombres_jugadores
      
      nombres = Array.new
      puts "Introduzca numero de Jugadores: "
      num = gets.chomp.to_i
      i = 0
      while i < num
        puts "Introduzca nombre del jugador: "
        nom = gets.chomp
        nombres << nom
        i += 1
      end
      
      return nombres
      
    end
    
    def self.main
      ui = VistaTextualQytetet.new
      @@controlador.set_nombre_jugadores(ui.obtener_nombres_jugadores)
      
      operacion_elegida = 0
      casilla_elegida = 0
      begin
        operacion_elegida = ui.elegir_operacion
        necesita_elegir_casilla = @@controlador.necesita_elegir_casilla(operacion_elegida)
        
        if necesita_elegir_casilla
          casilla_elegida = ui.elegir_casilla(operacion_elegida)
        end
        
        if (!necesita_elegir_casilla || casilla_elegida >= 0)
          puts @@controlador.realizar_operacion(operacion_elegida, casilla_elegida)
        end
      end while(1==1)
    end
    
  end
  VistaTextualQytetet.main
end
