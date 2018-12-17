# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "sorpresa"
require_relative "tipo_sorpresa"
require_relative "tablero"
require_relative "jugador"
require "singleton"
require_relative "dado"
require_relative "estado_juego"
require_relative "calle"
require_relative "casilla"
require_relative "especulador"


module ModeloQytetet
  class Qytetet
    attr_accessor :estado, :mazo, :tablero, :dado, :carta_actual, :jugador_actual, :jugadores
    
    include Singleton
    
    @@MAX_JUGADORES = 4
    @@NUM_SORPRESAS = 10
    @@NUM_CASILLAS = 20
    @@PRECIO_LIBERTAD = 200
    @@SALDO_SALIDA = 1000
    
    def initialize
      @mazo = Array.new
      @carta_actual
      @dado = Dado.instance
      @jugador_actual
      @jugadores = Array.new
      @estado
    end
    
    def inicializar_tablero
      @tablero = Tablero.new
      @tablero.inicializar
    end
    
    def inicializar_cartas_sorpresa
      @mazo.clear
      @mazo << Sorpresa.new("Vas a la carcel", @tablero.carcel.numero_casilla, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Vas a casa de Miguelon", 2, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Vuelve a casa de Pepe", 12, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Te deben dinero tus amigos morosos", 100, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Le debes dinero a tu casero", -100, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Has pisado mi jardin, pagame", -50, TipoSorpresa::PORCASAHOTEL)
      @mazo << Sorpresa.new("Gracias por visitar a tu abuelita, toma un regalito", 50, TipoSorpresa::PORCASAHOTEL)
      @mazo << Sorpresa.new("Has ganado la apuesta a tus amigos!", 10, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("Has perdido la apuesta con tus amuigos!", -10, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("Sales de la carcel", 0, TipoSorpresa::SALIRCARCEL)
      @mazo << Sorpresa.new("Convertirseee!", 3000, TipoSorpresa::CONVERTIRME)
      @mazo << Sorpresa.new("Convertirseee!", 5000, TipoSorpresa::CONVERTIRME)
      @mazo.shuffle
      
    end
    
    def inicializar_juego(nombres)
      inicializar_jugadores(nombres)
      inicializar_tablero
      inicializar_cartas_sorpresa
      salida_jugadores
    end
    
    def inicializar_jugadores(nombres)
      for n in nombres
        @jugadores << Jugador.new(n, false, 7500, nil, nil,nil)
      end
    end
    
    def actuar_si_en_casilla_edificable
      debo_pagar = @jugador_actual.debo_pagar_alquiler
      if debo_pagar
        @jugador_actual.pagar_alquiler
      end
      
      casilla = obtener_casilla_jugador_actual
      
      tengo_propietario = casilla.tengo_propietario
      
      if tengo_propietario
        @estado = EstadoJuego::JA_PUEDEGESTIONAR
      else
        @estado = EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
      end
    end
    
    def actuar_si_en_casilla_no_edificable
      @estado = EstadoJuego::JA_PUEDEGESTIONAR
      
      casilla_actual = @jugador_actual.casilla_actual
      
      if casilla_actual.tipo == TipoCasilla::IMPUESTO
        @jugador_actual.pagar_impuesto
      elsif casilla_actual.tipo == TipoCasilla::JUEZ
          encarcelar_jugador
        elsif casilla_actual.tipo == TipoCasilla::SORPRESA
            @carta_actual = @mazo.delete_at(0)
            @estado = EstadoJuego::JA_CONSORPRESA
        end
    end
   
    def aplicar_sorpresa
      @estado = EstadoJuego::JA_PUEDEGESTIONAR
      
      if @carta_actual == TipoSorpresa::SALIRCARCEL
        @jugador_actual.carta_libertad(@carta_actual)
      else
        @mazo << @carta_actual
      end
      
      if @carta_actual.tipo == TipoSorpresa::PAGARCOBRAR
        @jugador_actual.modificar_saldo(@carta_actual.valor)
        if @jugador_actual.saldo < 0
          @estado = EstadoJuego::ALGUNJUGADORENBANCARROTA
        end
      elsif @carta_actual.tipo == TipoSorpresa::IRACASILLA
          valor = @carta_actual.valor
          casilla_carcel = @tablero.es_casilla_carcel(valor)
          
          if casilla_carcel == true
            encarcelar_jugador
          else
            mover(valor)
          end
      elsif @carta_actual.tipo == TipoSorpresa::PORCASAHOTEL
          cantidad = @carta_actual.valor
          
          numero_total = @jugador_actual.cuantas_casas_hoteles_tengo
          @jugador_actual.modificar_saldo(numero_total*cantidad)
          
          if @jugador_actual.saldo < 0
            @estado = EstadoJuego::ALGUNJUGADORENBANCARROTA
          end
      elsif @carta_actual.tipo == TipoSorpresa::PORJUGADOR
          
          for j in @jugadores
            if j <=> @jugador_actual
              j.modificar_saldo(@carta_actual.valor)
              if j.saldo < 0
                @estado = EstadoJuego::ALGUNJUGADORENBANCARROTA
              end
              @jugador_actual.modificar_saldo(-@carta_actual.valor)
              
              if @jugador_actual.saldo < 0
                @estado = EstadoJuego::ALGUNJUGADORENBANCARROTA
              end
              
            end
          end
      elsif @carta_actual.tipo == TipoSorpresa::CONVERTIRME
        
          especulador = @jugador_actual.convertirme(@carta_actual.valor)
          @jugadores[@jugadores.index(@jugador_actual)]= especulador
          @jugador_actual = especulador
        
      end
    end
    
    def cancelar_hipoteca(numero_casilla)
      c = @tablero.obtener_casilla_numero(numero_casilla)
      cancelada = false
      
      if c.soy_edificable
        if c.titulo.propietario == @jugador_actual
          if c.titulo.hipotecada
            cancelada = @jugador_actual.cancelar_hipoteca(c.titulo)
          end
        end
      end
      
      return cancelada
    end
    
    def comprar_titulo_propiedad
      comprado = @jugador_actual.comprar_titulo_propiedad
      
      if comprado == true
        @estado = EstadoJuego::JA_PUEDEGESTIONAR
      end
      
      return comprado
    end
    
    def edificar_casa(numero_casilla)
      edificada = false
      
      casilla = @tablero.obtener_casilla_numero(numero_casilla)
      titulo = casilla.titulo
      edificada = @jugador_actual.edificar_casa(titulo)
      
      if edificada == true
        @estado = EstadoJuego::JA_PUEDEGESTIONAR
      end
      
      return edificada
    end
    
    def edificar_hotel(numero_casilla)
      edificada = false
      
      casilla = @tablero.obtener_casilla_numero(numero_casilla)
      titulo = casilla.titulo
      edificada = @jugador_actual.edificar_hotel(titulo)
      
      if edificada == true
        @estado = EstadoJuego::JA_PUEDEGESTIONAR
      end
      
      return edificada
    end
    
    def encarcelar_jugador
      if !@jugador_actual.tengo_carta_libertad()
        casilla_carcel=@tablero.carcel
        @jugador_actual.ir_a_carcel(casilla_carcel)
        @estado=EstadoJuego::JA_ENCARCELADO
        puts "Has sido encarcelado."
      else
        carta=@jugador_actual.devolver_carta_libertad()
        puts "Te libras de la carcel, tienes carta de libertad."
        @mazo.add(carta)
        @estado=EstadoJuego::JA_PUEDOGESTIONAR
      end
    end
    
    def get_valor_dado
      @dado.valor
    end
    
    def hipotecar_propiedad(numero_casilla)
      casilla = @tablero.obtener_casilla_numero(numero_casilla)
      titulo = casilla.titulo
      @jugador_actual.hipotecar_propiedad(titulo)
      @estado = EstadoJuego::JA_PUEDEGESTIONAR
    end
   
    def intentar_salir_carcel(metodo)
      if metodo == MetodoSalirCarcel::TIRANDODADO
        resultado = tirar_dado
        if resultado >= 5
          @jugador_actual.encarcelado=false
        end
      else
        @jugador_actual.pagar_libertad(@@PRECIO_LIBERTAD)
      end
      libre = @jugador_actual.encarcelado
      if libre
        puts "Continuas en la carcel..."
        @estado=EstadoJuego::JA_ENCARCELADO
      else
        @estado=EstadoJuego::JA_PREPARADO
      end
      return libre
    end
    
    def jugar
      desplazamiento = tirar_dado
      puts "Jugador " + (@jugadores.index(@jugador_actual)+1).to_s + " lanza el dado... Obtiene un " + @dado.valor.to_s + "\n"
      c = @tablero.obtener_casilla_final(@jugador_actual.casilla_actual, desplazamiento)
      mover(c.numero_casilla)
    end
 
    def mover(num_casilla_destino)
      casilla_inicial=@jugador_actual.casilla_actual
      casilla_final=@tablero.obtener_casilla_numero(num_casilla_destino)
      @jugador_actual.casilla_actual=casilla_final
      
      if num_casilla_destino < casilla_inicial.numero_casilla
        @jugador_actual.modificar_saldo(@@SALDO_SALIDA)
      end
      if casilla_final.soy_edificable
        actuar_si_en_casilla_edificable
      else
        actuar_si_en_casilla_no_edificable
      end
    end
    
    def obtener_casilla_jugador_actual
      return @jugador_actual.casilla_actual
    end
    
    def obtener_propiedades_jugador
      t=@jugador_actual.propiedades
      a=Array.new
      for titulos in t
        for c in @tablero.casillas
          if c.tipo == TipoCasilla::CALLE
            if titulos == c.titulo
              a << c.numero_casilla
            end
          end
        end
      end
      return a
    end
    
    def obtener_casillas_tablero
      @tablero.casillas
    end
    
    def obtener_propiedades_jugador_segun_estado_hipoteca(estado_hipoteca)
      numero_casillas = Array.new
      
      for t in @jugador_actual.obtener_propiedades(estado_hipoteca)
        for c in @tablero.casillas
          if(c.tipo == TipoCasilla::CALLE)
            if c.titulo == t
              numero_casillas << c.numero_casilla
            end
          end
        end
      end
      return numero_casillas
    end
    
    def obtener_ranking
      @jugadores = @jugadores.sort
    end
    
    def obtener_saldo_jugador_actual
      @jugador_actual.saldo
    end
    
    def salida_jugadores
      @estado = EstadoJuego::JA_PREPARADO
      for j in @jugadores
        j.casilla_actual = @tablero.casillas.at(0);
      end
      
      aleatorio = Random.new

      indice = aleatorio.rand(@jugadores.size-1)
      @jugador_actual = @jugadores.at(indice)
    end
    
    def siguiente_jugador
      puts @jugadores.index(@jugador_actual)
      
      indice_siguiente_jugador = @jugadores.index(@jugador_actual)
      
      @jugador_actual = @jugadores.at((indice_siguiente_jugador+1)%@jugadores.length)
      
      @estado = EstadoJuego::JA_PREPARADO
      
      if @jugador_actual.encarcelado == true
        @estado = EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
      end
    end
    
    def tirar_dado
      @dado.tirar
    end
    
    def vender_propiedad(numero_casilla)
      casilla=@tablero.obtener_casilla_numero(numero_casilla)
      @jugador_actual.vender_propiedad(casilla)
      @estado=EstadoJuego::JA_PUEDEGESTIONAR
    end
   
  end
end
