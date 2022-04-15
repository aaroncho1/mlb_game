class Hitter

    attr_reader :name, :position, :tendencies, :speed, :name
    attr_accessor :hits, :at_bats, :homers, :rbis, :walks

    def initialize(name, position, tendencies, speed)
        @name = name
        @position = position
        @tendencies = tendencies 
        @hits, @at_bats, @homers, @rbis, @walks = 0, 0, 0, 0, 0
    end

    def update_hitter_stats(result)
        @hits += 1
        @homers += 1 if result == 4
        @at_bats += 1
    end

    def steal_base?(display)
        puts ""
        puts "Hitting player, steal base? (y/n)"
        choice = gets.chomp.downcase
        if choice == "y"
            puts "Select base you want to steal from (1-3):"
            begin
                base_chosen = gets.chomp.to_i - 1
                raise "Invalid base number. Try again:" if !base_chosen.between?(0,2)
                raise "Cannot steal from empty base" if !display.bases[base_chosen].is_a?(Hitter)
            rescue => e   
                puts e.message
                retry
            end
            base_chosen 
        else
            base_chosen = false
        end
        base_chosen
    end

    def swing_for_the_fences?(pitch_zone)
        puts ""
        puts "Hitting player, swing for the fences? (y/n)"
        choice = gets.chomp.downcase 
        if choice == "y"
            puts "Guess exact pitch zone in format _ _:"
            alphabet = ("a".."z").to_a
            begin
                guessed_pitch_zone = gets.chomp
                guessed_pitch_zone.each_char do |el|
                    raise "Please use only numbers. Try again:" if alphabet.include?(el.downcase)
                end
                raise "Please use the format # # to choose zone. Try again:" if guessed_pitch_zone.length != 3
                hitters_guessed_zone = guessed_pitch_zone.split(" ").map(& :to_i)
                hitters_guessed_zone.each do |num|
                    raise "Invalid zone. Try again:" if !num.between?(0,2)
                end
            rescue => e    
                puts e.message  
                retry
            end
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
            begin
                alphabet = ("a".."z").to_a
                guessed = gets.chomp.downcase
                guessed.each_char do |el|
                    raise "Please select a number. Try again:" if alphabet.include?(el)
                end
                raise "Invalid length. Try again:" if guessed.length > 1
                guessed_zone =  guessed.to_i
                raise "Invalid number. Try again:" if !guessed_zone.between?(0,2)
            rescue => e  
                puts e.message
                retry
            end
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
        begin
            swing = gets.chomp.downcase
            raise "Invalid answer" if !["y","n"].include?(swing)
        rescue => e   
            puts e.message
            retry
        end
        swing
    end

end

