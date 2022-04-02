class Team 
    attr_reader :name
    attr_accessor :hitters, :pitchers, :runs, :hits, :errors

    def initialize(name, hitters, pitchers)
        @name = name 
        @hitters = []
        @pitchers = []
        @runs = 0
        @hits = 0
        @errors = 0
    end
end

#hitter tendencies are out of 200 ABs
mets_hitters = [
    Hitter.new("S.Marte", 
]