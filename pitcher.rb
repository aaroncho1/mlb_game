class Pitcher  
    attr_reader :name, :team, :grade, :tendencies, :pitch_options
    attr_accessor :stamina
    #pitch_options = { 1 => :fastball, 2 => :curveball}
    def initialize(name, team, grade, tendencies, stamina, pitch_options)
        @name = name 
        @grade = grade
        @tendencies = tendencies 
        @stamina = stamina
        @earned_runs = 0
        @pitches, @strikes = 0, 0
        @pitch_options = pitch_options #{1 => :fastball, 2 => :curveball, 3 => :slider}
    end

    def choose_pitch
        puts "Select your pitch with the corresponding number:"
        pitch = gets.chomp.to_i
        chosen_pitch = pitch_options[pitch]
        chosen_pitch #:fastball
    end

    def choose_zone
        puts "Select your zone with the numbers in the form _ _"
        puts "00 01 02"
        puts "10 11 12"
        puts "20 21 22"
        chosen_zone = gets.chomp
        pos = chosen_zone.split(" ").map(& :to_i)
        pos
    end


end