class Display

    attr_accessor :bases

    def initialize
        @bases = []
    end

    def show_bases
        bases.each_with_index do |player, i|
            if i == 0
                if player.is_a?(Hitter)
                    puts "1st base: #{player.name}" 
                else 
                    puts "1st base: empty"
                end
            elsif i == 1
                if player.is_a?(Hitter)
                    puts "2nd base: #{player.name}"
                else
                    puts "2nd base: empty"
                end
            elsif i == 2
                if player.is_a?(Hitter)
                    puts "3rd base: #{player.name}"
                else
                    puts "3rd base: empty"
                end
            end
        end
    end 

end