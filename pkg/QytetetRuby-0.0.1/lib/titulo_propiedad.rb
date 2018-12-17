# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module ModeloQytetet
  class TituloPropiedad
    attr_accessor :nombre, :precio_compra, :alquiler_base, :factor_revalorizacion,
                  :precio_edificar, :hipotecada, :num_casas, :num_hoteles, :propietario
    def initialize(name, precio_com, base_rent, f, precio_edif,hip_base)
      @nombre = name
      @precio_compra = precio_com
      @alquiler_base = base_rent
      @factor_revalorizacion = f
      @precio_edificar = precio_edif
      @hipoteca_base = hip_base
      @hipotecada = false
      @num_casas = 0
      @num_hoteles = 0
      @propietario = nil
    end
    
    def calcular_coste_cancelar
      coste = calcular_coste_hipotecar
      coste = 1.10*coste
      return coste
    end
    
    def cancelar_hipoteca
      puts "Hipoteca cancelada con exito."
      @hipotecada = false
    end
    def calcular_coste_hipotecar
      coste_hipoteca = @hipoteca_base + @num_casas*0.5*@hipoteca_base + @num_hoteles*@hipoteca_base
      return coste_hipoteca
    end
    
    def calcular_importe_alquiler
     a = @alquiler_base + (@num_casas*0.5 + @num_hoteles*0.5)
     return a
    end
    
    def calcular_precio_venta
       precio_venta = @precio_compra + ((@num_casas + @num_hoteles)*@precio_edificar*@factor_revalorizacion )
       return precio_venta
    end
    
    def edificar_casa
      puts "Has edificado una casa."
      @num_casas = @num_casas+1
    end
    
    def edificar_hotel
      puts "Has edificado un hotel."
      @num_casas = @num_casas-4
      @num_hoteles = @num_hoteles+1
    end
    
    def hipotecar
      puts "Propiedad hipotecada con exito."
      @hipotecada = true
      coste_hipoteca = calcular_coste_hipotecar
    end
    
    def pagar_alquiler
      coste_alquiler = calcular_importe_alquiler()
      @propietario.modificar_saldo(coste_alquiler)
      return coste_alquiler
    end
    
    def propietario_encarcelado
      return @propietario.encarcelado
    end
    
    def tengo_propietario
      return @propietario!=nil
    end
    
    def to_s
      "Nombre: #{@nombre} 
          Hipotecada: #{@hipotecada} 
          PrecioCompra: #{@precio_compra} 
          Alquiler Base: #{@alquiler_base}
          Factor Revaloricacion: #{@factor_revalorizacion}
          Precio Edificar: #{@precio_edificar}
          Hipotecada: #{@hipotecada}
          Casas: #{@num_casas}
          Hoteles: #{@num_hoteles}"
    end
    
    
  end
end
