class Game
    attr_reader :display
    attr_accessor :game_outs, :inning_outs, :inning

    def initialize(away_team, home_team, away_team_hitters, away_team_pitchers, 
        home_team_hitters, home_team_pitchers)
        @away_team, @home_team = away_team, home_team
        @away_team_hitters, @home_team_hitters = away_team_hitters, home_team_hitters
        @away_team_pitchers, @home_team_pitchers = away_team_pitchers, away_team_pitchers
        @game_outs = 0
        @inning_outs = 0
        @inning = 1
        @pitching_team = home_team
        @hitting_team = away_team
        @display = Display.new
        @current_pitcher = nil
        @current_hitter = nil
    end

    def score_difference
        @away_team.runs - @home_team.runs
    end

    def extra_innings?
        @game_outs >= 27 && score_difference == 0
    end

    def game_won?
        play_extra_innings if extra_innings?
        game_outs == 27 && score_difference != 0
    end

    def inning_over?
        @inning_outs == 3
    end

    def play_half_inning
        display.render
        until inning_over?
            pitcher.choose_pitch

    end


    def play
        puts "Welcome to MLB 2 Player Game! The selected teams and players have been added."
        puts "For the pitching player, use the number keys to select pitch zone (i.e, 0 2 for top right corner)"
        puts "For the hitting player, follow the options given on the screen"
        puts "Type 's' and 'enter' to start game"
        selected_key = gets.chomp
        system("clear") if selected_key == "s"
        until game_won?
            play_half_inning
            switch_sides
        end
    end
end