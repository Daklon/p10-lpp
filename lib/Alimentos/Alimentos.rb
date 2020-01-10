class Alimentos
	include Comparable
	attr_reader :nombre, :gases_efecto_invernadero, :terreno_usado, :proteinas, :carbohidratos, :lipidos
        def initialize(nombre, proteinas, carbohidratos, lipidos, gases_efecto_invernadero, terreno_usado)
                @nombre = nombre
                @proteinas = proteinas
                @carbohidratos = carbohidratos
                @lipidos = lipidos
                @gases_efecto_invernadero = gases_efecto_invernadero
                @terreno_usado = terreno_usado
        end

	def <=>(other)
		if other != nil
			get_energyvalue<=>other.get_energyvalue
		end
	end

	def get_name
		@nombre
	end

	def get_landused
		@terreno_usado
	end

	def get_greenhousegases
		@gases_efecto_invernadero
	end

        def to_s
                "#{@nombre}: #{@proteinas} g proteínas, #{@carbohidratos} g carbohidratos, #{@lipidos} g lípidos, #{@gases_efecto_invernadero} kgCO2eq Gases de efecto invernadero y #{@terreno_usado} m2 terreno usado."
        end

	def get_energyvalue
		((@carbohidratos * 4) + (@lipidos * 9) + (@proteinas * 4))
	end

	def self.manImpact(alimento)
		energyvalue = 3000
		(alimento.get_energyvalue/energyvalue)
	end

	def self.womanImpact(alimento)
		energyvalue = 2300
		(alimento.get_energyvalue / energyvalue)
	end
end

