class Pitcher  
    attr_reader :name, :grade, :tendencies, :pitch_options, :stamina_interval
    attr_accessor :stamina, :pitches, :strikes, :earned_runs
    #pitch_options = { 1 => :fastball, 2 => :curveball}
    def initialize(name, grade, tendencies, stamina_interval, pitch_options)
        @name = name 
        @grade = grade
        @tendencies = tendencies 
        @stamina = 200
        @stamina_interval = stamina_interval
        @earned_runs = 0
        @pitches, @strikes = 0, 0
        @pitch_options = pitch_options #{1 => :fastball, 2 => :curveball, 3 => :slider}
    end

    def make_him_chase?
        puts ""
        puts "Pitching player, make him chase? (y/n)"
        #add error here
        choice = gets.chomp.downcase
        choice
    end

    def choose_pitch
        puts ""
        puts "Pitching player, select your pitch with the corresponding number:"
        begin
            pitch = gets.chomp.to_i
            raise "Invalid pitch number" if !pitch_options.has_key?(pitch)
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
        #add error here
        puts "00 01 02"
        puts "10 11 12"
        puts "20 21 22"
        chosen_zone = gets.chomp
        pos = chosen_zone.split(" ").map(& :to_i)
        pos
    end

end