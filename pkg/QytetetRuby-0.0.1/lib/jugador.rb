# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "especulador.rb"
module ModeloQytetet
  include Comparable
  class Jugador
    attr_accessor :carta_libertad, :casilla_actual, :encarcelado,
                  :nombre, :propiedades, :saldo
                
    def initialize(nom, e, s, c_l,c_a,p)
      @encarcelado = e
      @nombre = nom
      @saldo = s
      @carta_libertad = c_l
      @casilla_actual = c_a
      if p != nil
        @propiedades = p
      else 
        @propiedades = Array.new
      end
    end
    
    def self.copia(otroJugador)
      new(otroJugador.nombre, otroJugador.encarcelado, otroJugador.saldo, otroJugador.carta_libertad,
          otroJugador.casilla_actual, otroJugador.propiedades)
    end
    
    def self.nuevo(nom)
      new(nom, false, 7500, nil, nil, nil)
    end
    
    def <=> (otro_jugador)
      otro_capital = otro_jugador.obtener_capital
      mi_capital = obtener_capital
      if otro_capital > mi_capital
        return 1 end
      if otro_capital < mi_capital
        return -1 end
      return 0
    end
    
    
    def convertirme(f)
      puts "Te has convertido en especulador."
      especulador = Especulador.copia(self,f)
      return especulador
    end
    
    def debo_ir_a_carcel
      return tengo_carta_libertad
    end
    
    def pagar_impuesto
      @saldo = @saldo - @casilla_actual.coste
    end
    
    def tengo_saldo(cantidad)
      return @saldo > cantidad
    end
    
    public
    def cancelar_hipoteca(titulo)
      cancelada = false
      
      if @saldo > titulo.calcular_coste_cancelar
        modificar_saldo(-titulo.calcular_coste_cancelar)
        titulo.cancelar_hipoteca
        cancelada = true
      end
      
      return cancelada
    end
    
    def comprar_titulo_propiedad()
      coste_compra = @casilla_actual.coste
      comprado = false      
      if coste_compra < @saldo
        titulo = @casilla_actual.asignar_propietario(self)        
        @propiedades << titulo
        modificar_saldo(-coste_compra)
        
        comprado = true
      end
      
      if comprado 
        puts "Propiedad comprada con exito."
      end
      return comprado
    end
    
    def cuantas_casas_hoteles_tengo()
      num_casas_hoteles = 0
      
      for t in @propiedades
        num_casas_hoteles += t.num_casas + t.num_hoteles
      end
      
      return num_casas_hoteles
    end
    
    def debo_pagar_alquiler
        if(!es_de_mi_propiedad(@casilla_actual.titulo))
            if(@casilla_actual.tengo_propietario)
                if(!@casilla_actual.propietario_encarcelado)
                    if(!@casilla_actual.titulo.hipotecada)
                        return true
                    end
                end
            end
        end       
        return false
    end
    
    def devolver_carta_libertad
      carta = @carta_libertad
      @carta_libertad = nil
      return carta
    end
    
    def puedo_edificar_casa(titulo)
      puedo_edificar = false
      num_casas = titulo.num_casas
      coste_edificar_casa = titulo.precio_edificar
      tengo_saldo = tengo_saldo(coste_edificar_casa)
      
      if num_casas < 4 && tengo_saldo
        puedo_edificar = true
      else
        puts "Actualmente no puedes edificar casa."
      end
      
      return puedo_edificar
    end
    
    def edificar_casa(titulo)
      puedo_edificar = puedo_edificar_casa(titulo)
      coste_edificar_casa = titulo.precio_edificar
      if puedo_edificar
          titulo.edificar_casa
          modificar_saldo(-coste_edificar_casa)
      end
      return puedo_edificar
    end
    
    def puedo_edificar_hotel(titulo)
      puedo_edificar = false
      num_casas = titulo.num_casas
      num_hoteles = titulo.num_hoteles
      
      coste_edificar_hotel = titulo.precio_edificar
      tengo_saldo = tengo_saldo(coste_edificar_hotel)
      
      if num_hoteles < 4 && num_casas >= 4 && tengo_saldo
        puedo_edificar = true
      else
        puts "Actualmente no puedes edificar hotel."
      end
      
      return puedo_edificar
    end
    
    def edificar_hotel(titulo)
      puedo_edificar = puedo_edificar_hotel(titulo)
      coste_edificar_hotel = titulo.precio_edificar
      if puedo_edificar
          titulo.edificar_hotel
          modificar_saldo(-coste_edificar_hotel)
      end
      return puedo_edificar
    end
    
    def eliminar_de_mis_propiedades(titulo)
      titulo.propietario=nil
      @propiedades.delete_at(@propiedades.index(titulo))
    end
    
    def es_de_mi_propiedad(titulo)
      es_de_mi_propiedad = false
      
      if @propiedades != nil
        for t in @propiedades
          if t == titulo
            es_de_mi_propiedad = true
          end
        end
      end
      
      return es_de_mi_propiedad
    end
    
    def estoy_en_calle_libre
      
    end
    
    def hipotecar_propiedad(titulo)
      coste_hipoteca = titulo.hipotecar
      modificar_saldo(-coste_hipoteca)
    end
    
    def ir_a_carcel(casilla)
      @casilla_actual=casilla
      @encarcelado=true
    end
    
    def modificar_saldo(cantidad)
      @saldo = @saldo + cantidad
      return @saldo
    end
    
    def obtener_capital
      capital = @saldo
      
        for t in @propiedades
          capital += t.precio_compra + ((t.num_casas+t.num_hoteles)*t.precio_edificar)
        end
     
      
      return capital
    end
    
    def obtener_propiedades(hipotecada)
      propiedades_hipotecadas = Array.new
      
      for t in @propiedades
        if t.hipotecada == hipotecada
          propiedades_hipotecadas << t
        end
      end
      
      return propiedades_hipotecadas
    end
    
    def pagar_alquiler
      puts "Has pagado el alquiler."
      coste_alquiler=@casilla_actual.pagar_alquiler
      modificar_saldo(-coste_alquiler)
    end
    

    def pagar_libertad(cantidad)
      tengo_saldo=tengo_saldo(cantidad)
      if tengo_saldo
        puts "Has salido de la carcel pagando tu libertad."
        @encarcelado=false
        modificar_saldo(-cantidad)
      end
    end
    
    def tengo_carta_libertad
      return @carta_libertad != nil
    end
    

    
    def vender_propiedad(casilla)
      titulo = casilla.titulo
      eliminar_de_mis_propiedades(titulo)
      precio_venta = titulo.calcular_precio_venta()
      modificar_saldo(precio_venta)
      puts "Propiedad vendida con exito."
    end
      
    def to_s
      
      str = String.new
      str<<"Jugador{ " +
              "\n  Encarcelado: #{@encarcelado}" +
              "\n  Nombre: #{@nombre}" +
              "\n  Saldo: #{@saldo}" +
              "\n  Capital: #{obtener_capital}" +
              "\n  Carta Libertad: #{@carta_libertad}" +
              "\n  Casilla Actual: #{@casilla_actual}" +
              "\n  Propiedades: "              
                    for t in @propiedades
                      str<< "#{t} \n"
                    end
              
      return str 
  end
  
  end
end