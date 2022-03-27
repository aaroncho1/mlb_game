class Team 
    attr_reader :name
    attr_accessor :players, :runs, :hits, :errors

    def initialize(name)
        @name = name 
        @players = []
        @runs = 0
        @hits = 0
        @errors = 0
    end
end