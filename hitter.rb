class Hitter

    def initialize(name, team, position, tendencies, guessed_tendencies, corner_tendencies)
        @name = name
        @position = position
        @tendencies = tendencies 
        @guessed_tendencies = guessed_tendencies
        @corner_tendencies
    end

    def guess_pitch
        puts "Guess pitch? (y/n):"
        guess = gets.chomp.downcase
        if guess == "y"
            puts "Select 0- top, 1- middle, 2- down:"
            guessed_zone = gets.chomp.to_i
        else
            false
        end
        guessed_zone
    end

    def swing?
        puts "Swing at pitch? (y/n):"
        swing = gets.chomp.downcase
        swing
    end

end