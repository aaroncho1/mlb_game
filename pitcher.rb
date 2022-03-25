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


    end

end