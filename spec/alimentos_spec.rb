require 'rspec/autorun'
require 'lib/Alimentos/Alimentos.rb'
require 'lib/Alimentos/List.rb'
require 'lib/Alimentos/Plato.rb'
require 'lib/Alimentos/DSLPlato.rb'

A1 = Alimentos.new("Tofu",8.0,1.9,4.8,2.0,2.2)
A2 = Alimentos.new("Chocolate",5.3,47.0,30.0,2.3,3.4)
A3 = Alimentos.new("Cerveza",0.5,3.6,0.0,0.24,0.22)
A4 = Alimentos.new("cafe", 0.1, 0.0, 0.0, 0.4, 0.3)
A5 = Alimentos.new("lentejas", 23.5, 52.0, 1.4, 0.4, 3.4)
A6 = Alimentos.new("Carne de Vaca", 21.1, 0.0, 3.1, 50.0, 164.0)
A7 = Alimentos.new("Carne de Cordero", 18.0, 0.0, 17.0, 20.0, 185.0)
A8 = Alimentos.new("Carne de Cerdo", 21.5, 0.0, 6.3, 7.6, 11.0)
A9 = Alimentos.new("Nueces", 20.0, 21.0, 54.0, 0.3, 7.9)
A10 = Alimentos.new("Queso", 25.0, 1.3, 33.0, 11.0, 41.0)
A11 = Alimentos.new("Leche de Vaca", 3.3, 4.8, 3.2, 3.2, 8.9)
A12 = Alimentos.new("Huevos", 13.0, 1.0, 11.0, 4.2, 5.7)

describe Alimentos do
	before :each do
		@L1 = List.new()
		@L1.push_back(1)
		@L1.push_back(2)
	end

	context "DSLPlato" do
		before :all do
			@plato = DSLPlato.new("Hamburguesa") do
				nombre	"Hamburguesa especial de la casa"
				alimento A6,
					:gramos => 100
				alimento A12,
					:gramos => 200
			end
		end
		it "Crear plato usando dsl" do
			expect(@plato.to_s).to eq("Hamburguesa especial de la casa\n" +
						  "Carne de Vaca - 100 gramos\n" +
						  "Huevos - 200 gramos")
		end
	end

	context "DSLMenu" do
		before :all do
			guiso = DSLPlato.new("Guiso de lentejas") do
        		      nombre    "Guiso de lentejas con carne"
        		      alimento  A5,
                  	      		:gramos => 150
        		      alimento  A7,
                  			:gramos => 75
      			end
      			hamburguesa = DSLPlato.new("Hamburguesa") do
        		      nombre    "Hamburguesa especial de la casa"
        		      alimento  A6,
                  			:gramos => 200
        		      alimento  A12,
                  			:gramos => 100
      			end
      			cervezaMenu = DSLPlato.new("Cerveza") do
        		      nombre    "Cerveza de importación"
        		      alimento  A3,
                  			:gramos => 250
      			end
		        @menu = DSLMenu.new("Combinado nº. 1") do
        		      descripcion "Guiso, hamburguesa, cerveza"
        		      componente  guiso,
                    			:precio => 3.50
        		      componente  hamburguesa,
                    			:precio => 4.25
        		      componente  cervezaMenu,
                    			:precio => 2.00
        		      precio      9.75
      			end
		end
		it "crear nuevo menu usando dsl" do
			expect(@menu.to_s).to eq("Menu: Guiso, hamburguesa, cerveza\n" +
                               			 "Platos:\n" +
                               			 "Plato 1: 3.5€\n" +
                               			 "Guiso de lentejas con carne\n" +
                               			 "lentejas - 150 gramos\n" +
                               			 "carne de cordero - 75 gramos\n" +
                               			 "Valor nutricional: 567.58\n" +
                               			 "Valor ambiental: 0.4\n" +
                               			 "Plato 2: 4.25€\n" +
                               			 "Hamburguesa especial de la casa\n" +
                               			 "carne de vaca - 200 gramos\n" +
                               			 "huevos - 100 gramos\n" +
                               			 "Valor nutricional: 298.6\n" +
                               			 "Valor ambiental: 104.2\n" +
                               			 "Plato 3: 2.0€\n" +
                               			 "Cerveza de importación\n" +
                               			 "cerveza - 250 gramos\n" +
                              			 "Valor nutricional: 68.8\n" +
                              			 "Valor ambiental: 0.48")
		end
	end

	context "Menu" do
		before :all do
			@carne = List.new(A6,A7,A8)
			@gramoscarne = List.new(300,200,250)
			@Pcarne = PlatoCompuesto.new("Plato carnívoro",@carne,@gramoscarne)
			@vegetales = List.new(A1,A3,A5,A9)
			@gramosveget = List.new(300,100,200,50)
			@Pveget = PlatoCompuesto.new("Plato vegetariano",@vegetales,@gramosveget)
			@lacteo = List.new(A10,A11,A2,A4)
			@gramoslacteo = List.new(300,200,50,500)
			@Placteo = PlatoCompuesto.new("Plato lacteo",@lacteo,@gramoslacteo)

			@menu = [@Pcarne,@Pveget,@Placteo]

			@preciomenu = [25.95,8.99,7.99]

        	        @indenerg = @menu.map {
        			|x| if x.getValorCaloricoTotal < 670
        	  			1
        			elsif x.getValorCaloricoTotal <= 830
        	  			2
        			else
        	  			3
        			end
      				}
      			@indcarb = @menu.map {
        			|x| if x.get_green_house_emissions < 800
        	  			1
        			elsif x.get_green_house_emissions <= 1200
        	  			2
        			else
        	  			3
        			end
      			}

        	        @indicnutric = [@indenerg, @indcarb].transpose.map { |x| x.reduce(:+) / 2.0 }
    		end

    		it "Calcular plato con máxima huella nutricional" do
			expect(@menu.zip(@indicnutric).max.first).to eq(@Pveget)
    		end

    		it "Incrementar precio" do
      			expect(@preciomenu.map { |x| x * @menu.zip(@indicnutric).reduce { |a, b| (a.last > b.last) ? a : b }.last }).to eq(@preciomenu.map { |x| x * 2.0 })
    		end
	end

	context "Plato class: " do
		before :each do
      			@listaAlimentos = List.new(A1,A2,A3,A4)
      			@listaGramos = List.new(300,200,50,500)
      			@plato = Plato.new("Plato de la dieta", @listaAlimentos, @listaGramos)
		end

    		it "objeto plato exist" do
      			expect(Plato.new(nil, nil, nil)).to be_kind_of(Plato)
    		end

    		it "Check plato name" do
      			expect(@plato.nombre).to eq("Plato de la dieta")
    		end

    		it "Check there are alimentos" do
      			expect(@plato.listaAlimentos).not_to eq(nil)
    		end

    		it "Check grams" do
      			expect(@plato.listaGramos).not_to eq(nil)
    		end

    		it "Check protein percent" do
			expect(@plato.getProteinas).to eq(7.02)
    		end

    		it "Check lipids" do
			expect(@plato.getLipidos).to eq(14.88)
    		end

    		it "Check carbs" do
			expect(@plato.getCarbohidratos).to eq(19.94)
    		end

    		it "Check cal" do
			expect(@plato.getValorCaloricoTotal).to eq(1335.3)
    		end
    		it "Check formatted name" do
			str = "Nombre: Plato de la dieta\n{Tofu: 8.0 g proteínas, 1.9 g carbohidratos, 4.8 g lípidos, 2.0 kgCO2eq Gases de efecto invernadero y 2.2 m2 terreno usado., Chocolate: 5.3 g proteínas, 47.0 g carbohidratos, 30.0 g lípidos, 2.3 kgCO2eq Gases de efecto invernadero y 3.4 m2 terreno usado., Cerveza: 0.5 g proteínas, 3.6 g carbohidratos, 0.0 g lípidos, 0.24 kgCO2eq Gases de efecto invernadero y 0.22 m2 terreno usado., cafe: 0.1 g proteínas, 0.0 g carbohidratos, 0.0 g lípidos, 0.4 kgCO2eq Gases de efecto invernadero y 0.3 m2 terreno usado.}\n"
      		# str = "Nombre: \"Plato de la dieta\"\nAlimentos:\ncarne de vaca: 21.1 - 0.0 - 3.1 - 50.0 - 164.0\nhuevos: 13.0 - 1.0 - 11.0 - 4.2 - 5.7\ntofu: 8.0 - 1.9 - 4.8 - 2.0 - 2.2\ncerveza: 0.5 - 3.6 - 0.0 - 0.24 - 0.22\n"
      			expect(@plato.to_s).to eq(str)
    		end
  	end


	context "List enumerable: " do
		before :each do
                	@L2 = List.new(A1.get_energyvalue(),A2.get_energyvalue(), A4.get_energyvalue(),A5.get_energyvalue())
                	@tempMax = @L2.max
                	@tempMin = @L2.min
                	@tempSort = @L2.sort
                	@Sorted = [A4.get_energyvalue(), A1.get_energyvalue(), A5.get_energyvalue(),A2.get_energyvalue()]
		end

		it "Check max value" do
			expect(@tempMax).to eq(479.2)
    		end

		it "Check min value" do
			expect(@tempMin).to eq(0.4)
		end

		it "Check sort" do
			expect(@tempSort).to eq(@Sorted)
		end

		it "Check collect" do
			array = [nil, nil, nil]
			expect((1..3).collect {}).to eq(array)
		end

		it "Check select" do
			selection = @tempSort.select { |x| x.to_i % 2 == 0 }
			expect(selection).to eq([0.4, 82.8, 314.6])
    		end
	end


	context "Compare testing" do
		it "Comparando operador < " do
			expect(A4 < A5).to eq(true)
    		end
		it "Comparando operador > " do
			expect(A4 > A5) .to eq(false)
    		end
    		it "Comparando operador == " do
      			expect(A4 == A4) .to eq(true)
      			expect(A4 == A5) .to eq(false)
    		end
   	end

	context "List testing" do
		it "Head no null" do
			expect(@L1.head).not_to eq(nil)
		end
		it "Tail no null" do
			expect(@L1.tail).not_to eq(nil)
		end
		it "Head tiene siguiente" do
			expect(@L1.head.next).not_to eq(nil)
		end
		it "Tail tiene previo" do
			expect(@L1.tail.prev).not_to eq(nil)
		end
		it "Recuperar información" do
			node1 = @L1.get(0)
			expect(node1).to eq(1)
		end
		it "Lista con cabeza y cola" do
			expect(@L1.head.value).to eq(1)
			expect(@L1.tail.value).to eq(2)
		end
		it "Insertar elemento en lista" do
			@L1.insert(5,0)
			expect(@L1.get(0)).to eq(5)
		end
		it "Insertar varios elementos en la lista" do
			@L1.insert(6,0)
			@L1.insert(7,1)
			expect(@L1.get(0)).to eq(6)
			expect(@L1.get(1)).to eq(7)
		end
		it "Se extrae el primer elemento de la lista" do
			@L1.push_front(8)
			expect(@L1.pop_front).to eq(8)
			expect(@L1.pop_front).not_to eq(8)
		end
                it "Se extrae el último elemento de la lista" do
                        @L1.push_back(9)
                        expect(@L1.pop_back).to eq(9)
                        expect(@L1.pop_back).not_to eq(9)
                end

	end

	context "Tofu testing" do
                it "nombre del alimento correcto" do
			expect(A1.nombre).to eq("Tofu")
                end
                it "terreno utilizado correcto" do
                        expect(A1.terreno_usado).to eq(2.2)
                end
                it "gases de efecto invernadero correcto" do
                        expect(A1.gases_efecto_invernadero).to eq(2.0)
                end

		it "nombre del alimento correcto(método)" do
			expect(A1.get_name()).to eq("Tofu")
		end
		it "terreno utilizado correcto(método)" do
                        expect(A1.get_landused()).to eq(2.2)
                end
		it "gases de efecto invernadero correcto(método)" do
                        expect(A1.get_greenhousegases()).to eq(2.0)
                end
		it "alimento formateado correcto" do
                        expect(A1.to_s() =="Tofu: 8.0 g proteínas, 1.9 g carbohidratos, 4.8 g lípidos, 2.0 kgCO2eq Gases de efecto invernadero y 2.2 m2 terreno usado.")
                end
                it "Valor energético correcto(método)" do
			expect(A1.get_energyvalue()).to eq(82.8)
                end
                it "Impacto ambiental hombre(método estático)" do
			expect(Alimentos.manImpact(A1)).to eq(0.0276)
                end
                it "Impacto ambiental mujer(método estático)" do
			expect(Alimentos.womanImpact(A1)).to eq(0.036)
                end



	end

        context "Chocolate testing" do
                it "nombre del alimento correcto" do
                        expect(A2.nombre).to eq("Chocolate")
                end
                it "terreno utilizado correcto" do
			expect(A2.terreno_usado).to eq(3.4)
                end
                it "gases de efecto invernadero correcto" do
                        expect(A2.gases_efecto_invernadero).to eq(2.3)
                end

                it "nombre del alimento correcto(método)" do
                        expect(A2.get_name()).to eq("Chocolate")
                end
                it "terreno utilizado correcto(método)" do
			expect(A2.get_landused()).to eq(3.4)
                end
                it "gases de efecto invernadero correcto(método)" do
			expect(A2.get_greenhousegases()).to eq(2.3)
                end
                it "alimento formateado correcto" do
			expect(A2.to_s()).to eq("Chocolate: 5.3 g proteínas, 47.0 g carbohidratos, 30.0 g lípidos, 2.3 kgCO2eq Gases de efecto invernadero y 3.4 m2 terreno usado.")
                end
                it "Valor energético correcto(método)" do
                        expect(A2.get_energyvalue()).to eq(479.2)
                end
                it "Impacto ambiental hombre(método estático)" do
			expect(Alimentos.manImpact(A2)).to be_within(0.01).of(0.15973)
                end
                it "Impacto ambiental mujer(método estático)" do
			expect(Alimentos.womanImpact(A2)).to be_within(0.01).of(0.208)
                end


	end

        context "Cerveza testing" do
                it "nombre del alimento correcto" do
                        expect(A3.nombre).to eq("Cerveza")
                end
                it "terreno utilizado correcto" do
			expect(A3.terreno_usado).to eq(0.22)
                end
                it "gases de efecto invernadero correcto" do
                        expect(A3.gases_efecto_invernadero).to eq(0.24)
                end

                it "nombre del alimento correcto(método)" do
                        expect(A3.get_name()).to eq("Cerveza")
                end
                it "terreno utilizado correcto(método)" do
			expect(A3.get_landused()).to eq(0.22)
                end
                it "gases de efecto invernadero correcto(método)" do
			expect(A3.get_greenhousegases()).to eq(0.24)
                end
                it "alimento formateado correcto" do
			expect(A3.to_s()).to eq("Cerveza: 0.5 g proteínas, 3.6 g carbohidratos, 0.0 g lípidos, 0.24 kgCO2eq Gases de efecto invernadero y 0.22 m2 terreno usado.")
                end
                it "Valor energético correcto(método)" do
			expect(A3.get_energyvalue()).to eq(16.4)
                end
                it "Impacto ambiental hombre(método estático)" do
			expect(Alimentos.manImpact(A3)).to be_within(0.01).of(0.0054)
                end
                it "Impacto ambiental mujer(método estático)" do
			expect(Alimentos.womanImpact(A3)).to be_within(0.01).of(0.0071)
                end


        end
end
