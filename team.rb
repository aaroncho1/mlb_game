class Team 
    attr_reader :name
    attr_accessor :hitters, :pitchers, :runs, :hits, :errors

    def initialize(name, hitters, pitchers)
        @name = name 
        @hitters, @pitchers = hitters, pitchers
        @runs = 0
        @hits = 0
        @errors = 0
    end
end

