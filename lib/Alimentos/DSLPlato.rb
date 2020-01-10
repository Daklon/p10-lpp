class DSLPlato
    include Comparable
    attr_reader :nombre
    def initialize (nombre, &block)
    	@nombre = nombre
	@listaAlimentos = List.new()
	@listaGramos = List.new()

	if block_given?
	    if block.arity == 1
	        yield self
	    else
		instance_eval(&block)
	    end
	end
    end
    def nombre(nombre)
	@nombre = nombre
    end
    def alimento(alimento, options = {})
	unless options[:gramos].nil?
	    @listaAlimentos << alimento
	    @listaGramos << options[:gramos]
	end
    end
    def getProteinas
      	temp = listaAlimentos.head
      	temp2 = listaGramos.head
      	proteinas = 0
      	gramosTotales = 0
      	while (temp != nil && listaGramos != nil)
            proteinas += temp.value.proteinas * (temp2.value/100)
            gramosTotales = temp2.value
            temp = temp.next
            temp2 = temp2.next
      	end
      	return ((proteinas * 100)/gramosTotales).round(2)
    end
    def getLipidos
      	temp = listaAlimentos.head
      	temp2 = listaGramos.head
      	lipidos = 0
      	gramosTotales = 0
      	while temp != nil && listaGramos != nil
            lipidos += temp.value.lipidos * (temp2.value/100)
            gramosTotales = temp2.value
            temp = temp.next
            temp2 = temp2.next
      	end
	return ((lipidos * 100)/gramosTotales).round(2)
    end
    def getCarbohidratos
        temp = listaAlimentos.head
        temp2 = listaGramos.head
        carbohidratos = 0
        gramosTotales = 0
        while temp != nil && listaGramos != nil
            carbohidratos += temp.value.carbohidratos * (temp2.value/100)
            gramosTotales = temp2.value
            temp = temp.next
            temp2 = temp2.next
        end
        return ((carbohidratos * 100)/gramosTotales).round(2)
    end
    def getGramosTotales
        temp = listaGramos.head
        gramosTotales = 0
        while temp != nil
            gramosTotales = temp.value
            temp = temp.next
        end
        return gramosTotales
    end
    def getValorCaloricoTotal
        proteinas = (getProteinas * getGramosTotales) / 100
        carbohidratos = (getCarbohidratos * getGramosTotales) / 100
        lipidos = (getLipidos * getGramosTotales) / 100
        return (proteinas*4 + carbohidratos*9 + lipidos*4).round(2)
    end
    def to_s
	ret = "#{@nombre}\n"
	ret + @listaAlimentos.map{
	    |x| x.to_s.split(':')[0]}.zip(@listaGramos).map { 
            |x| x.first.to_s + " - " + x.last.to_s + " gramos"
        }.join("\n")
    end
    def <=>(other)
        if other != nil
            getValorCaloricoTotal <=> other.getValorCaloricoTotal
        end
    end
end
class PlatoCompuesto < Plato
    def initialize (nombre, listaAlimentos, listaGramos)
      super(nombre, listaAlimentos, listaGramos)
    end
    def get_green_house_emissions
      temp = listaAlimentos.head
      temp2 = listaGramos.head
      
      total_ghe = 0
      while temp != nil && temp2 != nil
        total_ghe += temp.value.gases_efecto_invernadero * (temp2.value / 100)
        temp = temp.next
        temp2 = temp2.next
      end
      total_ghe.round(2)
    end

    def get_land_used
      temp = listaAlimentos.head
      temp2 = listaGramos.head

      total_land_used = 0
      while temp != nil && temp2 != nil
        total_land_used = temp.value.terreno * (temp2.value / 100)
        temp = temp.next
      end
      total_land_used.round(2)
    end
    
    def to_s
      super + "Eficiencia energética: #{getValorCaloricoTotal}\n"
    end
  end

