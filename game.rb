class Game
    CORNERS = []
    attr_reader :display
    attr_accessor :game_outs, :inning_outs, :inning, :current_pitcher, :current_hitter

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

    def corner_pitch_simulator(pitcher)
        if pitcher.stamina >= 200
            [:S, :S, :S, :S, :S, :S, :S, :S, :B, :B].sample
        elsif pitcher.stamina >= 100
            [:S, :S, :S, :S, :S, :S, :B, :B, :B, :B].sample
        else
            [:S, :S, :S, :S, :B, :B, :B, :B, :B, :B].sample
        end
    end

    def middle_pitch_simulator(pitcher)
        if pitcher.stamina >= 200
            [:S, :S, :S, :S, :S, :S, :S, :S, :S, :B].sample
        elsif pitcher.stamina >= 100
            [:S, :S, :S, :S, :S, :S, :S, :B, :B, :B].sample
        else
            [:S, :S, :S, :S, :S, :S, :B, :B, :B, :B].sample
        end

    def pitch_result(pitcher, first_result, zone)
        if first_result == :S && CORNERS.include?(zone)
            corner_pitch_simulator(pitcher)
        elsif first_result == :S && !CORNERS.include?(zone)
            middle_pitch_simulator(pitcher)
        elsif first_result == :B    
            :B   
        end
    end

    def throw_pitch(pitcher, pitch, zone)
        tendencies = pitcher.tendencies[pitch]
        first_result = tendencies.sample 
        result = pitch_result(pitcher, first_result, zone)
        result
    end

    def pitch(pitcher)
        pitch = pitcher.choose_pitch
        zone = pitcher.choose_zone
        result = throw_pitch(pitcher, pitch, zone)
    end

    def swing(current_hitter)
        guess_pitch?

    def play_half_inning
        display.render(current_pitcher, current_hitter)
        until inning_over?
            pitch(current_pitcher)
            swing(current_hitter)

    end

    def welcome_message
        puts "Welcome to MLB 2 Player Game! The selected teams and players have been added."
        puts "For the pitching player, use the number keys to select pitch zone (i.e, 0 2 for top right corner)"
        puts "For the hitting player, follow the options given on the screen"
        puts "Type 's' and 'enter' to start game"
    end

    def enter_to_start
        selected_key = gets.chomp
        system("clear") if selected_key == "s"
    end

    def play
        welcome_message
        enter_to_start
        until game_won?
            play_half_inning
            switch_sides
        end
    end
end