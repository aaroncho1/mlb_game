class Pitcher  
    attr_reader :name, :grade, :tendencies, :stamina_interval, :pitch_options
    attr_accessor :stamina, :earned_runs, :pitches, :strikes 
    #pitch_options = { 1 => :fastball, 2 => :curveball}
    def initialize(name, grade, tendencies, stamina_interval, pitch_options)
        @name = name 
        @grade = grade
        @tendencies = tendencies 
        @stamina_interval = stamina_interval
        @stamina = 200
        @earned_runs = 0
        @pitches, @strikes = 0, 0
        @pitch_options = pitch_options #{1 => :fastball, 2 => :curveball, 3 => :slider}
    end

    def update_pitching_stats(result)
        @stamina -= stamina_interval
        @pitches += 1
        @strikes += 1 if result == :S   
    end

    def intentional_walk?
        puts ""
        puts "Pitching player, walk batter? (y/n)"
        choice = gets.chomp.downcase
        choice == "y" ? true : false
    end

    def make_him_chase?
        puts ""
        puts "Pitching player, make him chase? (y/n)"
        choice = gets.chomp.downcase
        choice
    end

    def choose_pitch
        puts ""
        puts "Pitching player, select your pitch with the corresponding number:"
        begin
            pitch = gets.chomp.to_i
            raise "Invalid pitch number. Try again:" if !pitch_options.has_key?(pitch)
        rescue => e   
            puts e.message
            retry 
        end
        chosen_pitch = pitch_options[pitch]
        chosen_pitch #:fastball
    end

    def choose_zone
        puts ""
        puts "Pitching player, select your pitch zone with the numbers in the form _ _"
        puts "00 01 02"
        puts "10 11 12"
        puts "20 21 22"
        begin
            alphabet = ("a".."z").to_a
            chosen_zone = gets.chomp
            chosen_zone.each_char do |el|
                raise "Please use only numbers. Try again:" if alphabet.include?(el.downcase)
            end
            raise "Please use the format # # to chose your zone. Try again:" if chosen_zone.length != 3 
            pos = chosen_zone.split(" ").map(& :to_i)
            raise "Invalid pitch zone. Try again:" if !valid_pitch_zone?(pos)
        rescue => e   
            puts e.message
            retry
        end
        pos
    end

    def valid_pitch_zone?(zone)
        zone.each do |num|
            num.between?(0,2)
        end
    end
end