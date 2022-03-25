class Pitcher  
    attr_reader :pitch_options
    #pitch_options = { 1 => :fastball, 2 => :curveball}
    def initialize(name, tendencies, stamina, pitch_options)
        @name = name 
        @tendencies = tendencies 
        @stamina = stamina
        @pitch_options = pitch_options
    end

    def choose_pitch
        puts "Select your pitch with the corresponding number:"
        pitch = gets.chomp.to_i
        chosen_pitch = pitch_options[pitch]
        chosen_pitch
    end

    def choose_zone
        puts "Select your zone with the numbers in the form _ _"
        

end