class Display

    attr_accessor :bases

    def initialize
        @bases = []
    end

    def show_bases
        bases.each_with_index do |player, i|
            if i == 0
                player.is_a?(Hitter) ? puts "1st base: #{player.name}" : puts "1st base: empty"
            elsif i == 1
                player.is_a?(Hitter) ? puts "2nd base: #{player.name}" : puts "2nd base: empty"
            elsif i == 2
                player.is_a?(Hitter) ? puts "3rd base: #{player.name}" : puts "3rd base: empty"
            end
        end
    end 
end