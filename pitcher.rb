class Pitcher  
    attr_reader :pitch_options
    #pitch_options = { 1 => :fastball, 2 => :curveball}
    def initialize(name, team, grade, tendencies, stamina, pitch_options)
        @name = name 
        @grade = grade
        @tendencies = tendencies 
        @stamina = stamina
        @pitch_options = pitch_options #{1 => :fastball, 2 => :curveball}
    end

    def choose_pitch
        puts "Select your pitch with the corresponding number:"
        pitch = gets.chomp.to_i
        chosen_pitch = pitch_options[pitch]
        chosen_pitch #:fastball
    end

    def choose_zone
        puts "Select your zone with the numbers in the form _ _"
        puts "[0 0] [0 1] [0 2]"
        puts "[1 0] [1 1] [1 2]"
        puts "[2 0] [2 1] [2 2]"
        chosen_zone = gets.chomp
        pos = chosen_zone.split(" ").map(& :to_i)
        pos
    end


end