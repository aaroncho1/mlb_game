class Hitter

    attr_reader :name, :position, :tendencies, :speed, :name
    attr_accessor :hits, :at_bats, :homers, :rbis, :walks
    def initialize(name, position, tendencies, speed)
        @name = name
        @position = position
        @tendencies = tendencies 
        @hits, @at_bats, @homers, @rbis, @walks = 0, 0, 0, 0
    end

    def swing_for_the_fences?(pitch_zone)
        puts ""
        puts "Hitting player, swing for the fences? (y/n)"
        choice = gets.chomp.downcase 
        if choice == "y"
            puts "Guess exact pitch zone in format _ _:"
            guessed_pitch_zone = gets.chomp.split(" ")
            hitters_guessed_zone = guessed_pitch_zone.map(& :to_i)
        else
            hitters_guessed_zone = false
        end
        hitters_guessed_zone
    end

    def guess_zone?
        puts ""
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

