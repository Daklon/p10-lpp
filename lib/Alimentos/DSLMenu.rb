class DSLMenu
    attr_reader :name
    def initialize(desc, &block)
        @desc = desc
        @listaPlatos = []
        @listaPrecios = []
        @precio = 0.0

        if block_given?
          if block.arity == 1
            yield self
          else
            instance_eval(&block)
          end
        end
    end
    def descripcion(desc)
        @desc = desc
    end
    def componente(plato, options = {})
        unless options[:precio].nil?
          @listaPlatos << plato 
          @listaPrecios << options[:precio]
        end
    end
    def precio(value)
        @precio = value
    end
    def to_s
        count = 0
        ret = "Menu: #{@desc}\nPlatos:\n"
        ret + @listaPlatos.zip(@listaPrecios).map { 
          |x| "Plato #{count += 1}: "  + x.last.to_s + "€\n" +
          x.first.to_s +
            "\nValor nutricional: #{x.first.getValorCaloricoTotal}" +
            "\nValor ambiental: #{x.first.get_green_house_emissions}"
        }.join("\n")
    end
end
