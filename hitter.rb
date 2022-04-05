class Hitter

    attr_reader :position, :tendencies, :speed
    attr_accessor :hits, :at_bats, :homers, :rbis
    def initialize(name, position, tendencies, speed)
        @name = name
        @position = position
        @tendencies = tendencies 
        @hits, @at_bats, @homers, @rbis, @walks = 0, 0, 0, 0
    end

    def guess_zone?
        puts "Hitting player, guess pitch zone? (y/n):"
        guess = gets.chomp.downcase
        if guess == "y"
            puts "Select 0- top, 1- middle, 2- down:"
            guessed_zone = gets.chomp.to_i
        else
            guessed_zone = false
        end
        guessed_zone
    end

    def guess_pitch?
        puts "Hitting player, guess pitch type? (y/n):"
        guess = gets.chomp.downcase
        if guess == "y"
            puts "Guess the pitch:"
            guessed_pitch_num = gets.chomp.to_i
        else
            guessed_pitch_num = false
        end
        guessed_pitch_num
    end

    def swing?
        puts "Swing at pitch? (y/n):"
        swing = gets.chomp.downcase
        swing
    end

end

