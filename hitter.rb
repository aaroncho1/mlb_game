class Hitter

    def initialize(name, position, tendencies)
        @name = name
        @position = position
        @tendencies = tendencies 
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

end