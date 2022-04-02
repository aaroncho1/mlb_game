class Hitter

    attr_reader :position, :tendencies, :speed
    attr_accessor :base, :hits, :at_bats, :homers, :rbis
    def initialize(name, position, tendencies, speed)
        @name = name
        @position = position
        @tendencies = tendencies 
        @guessed_tendencies = guessed_tendencies
        @base = 0
        @hits, @at_bats, @homers, @rbis = 0, 0, 0, 0
    end

    def guess_zone?
        puts "Guess pitch zone? (y/n):"
        guess = gets.chomp.downcase
        if guess == "y"
            puts "Select 0- top, 1- middle, 2- down:"
            guessed_zone = gets.chomp.to_i
        else
            guessed_zone = false
        end
        guessed_zone
    end

    def guess_pitch?(pitch)
        puts "Guess pitch type? (y/n):"
        guess = gets.chomp.downcase
        if guess == "y"
            puts "Guess the pitch:"
            guessed_pitch = gets.chomp.to_i
        else
            guessed_pitch = false
        end
        guessed_pitch
    end

    def swing?
        puts "Swing at pitch? (y/n):"
        swing = gets.chomp.downcase
        swing
    end

end

