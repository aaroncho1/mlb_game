class Game
    CORNERS = [[0,0], [0,2], [2,0] [2,2]]
    SWING_ON_STRIKE_OPTOINS = [:s, :s, :f, :f, :h, :h, :h, :h]
    attr_reader :display, :away_team, :home_team
    attr_accessor :game_outs, :inning_outs, :inning, :current_pitcher, 
    :current_hitter, :current_pitch_zone, :strike_zone, :balls, :strikes

    def initialize(away_team, home_team, away_team_hitters, away_team_pitchers, 
        home_team_hitters, home_team_pitchers)
        @away_team, @home_team = away_team, home_team
        @away_team_hitters, @home_team_hitters = away_team_hitters, home_team_hitters
        @away_team_pitchers, @home_team_pitchers = away_team_pitchers, away_team_pitchers
        @game_outs, @inning_outs, @balls, @strikes, @inning = 0, 0, 0, 0, 1
        @pitching_team, @hitting_team = home_team, away_team
        @display = Display.new
        @current_pitcher, @current_hitter, @current_pitch_zone = nil, nil, nil
        @strike_zone = Array.new(3){Array.new(3, :X)}
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

    def half_inning_over?
        @inning_outs == 3
    end

    def inning_over?
        @game_outs % 6 == 0
    end

    def add_out
        game_outs += 1
        inning_outs += 1
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

    def second_result(pitcher, first_result, zone)
        if first_result == :S && CORNERS.include?(zone)
            corner_pitch_simulator(pitcher)
        elsif first_result == :S && !CORNERS.include?(zone)
            middle_pitch_simulator(pitcher)
        elsif first_result == :B    
            :B   
        end
    end

    def throw_pitch(pitcher, pitch, zone)
        tendencies = pitcher.tendencies[pitch] #{ :fastball => [:S, :S, :B]
        first_result = tendencies.sample 
        result = second_result(pitcher, first_result, zone)
        result #:S or :B
    end

    def pitch(pitcher)
        pitch = pitcher.choose_pitch #:fastball
        zone = pitcher.choose_zone #[2,0]
        @current_pitch_zone = zone #resets the current pitch with each pitch
        result = throw_pitch(pitcher, pitch, zone)
        result # :S or :B
    end

    def hit?(result)
        result.any?(|num| num > 0)
    end

    def sleep_and_clear
        sleep 1.50
        system("clear")
    end

    def record_hit(result)
        case result
        when 1
            puts "Single!"
            sleep_and_clear
        when 2
            puts "Double!"
            sleep_and_clear
        when 3
            puts "Triple!"
            sleep_and_clear
        when 4
            puts "HOME RUN!"
            sleep_and_clear
        end
    end

    def record_out
        out_result = [:g, :f].sample
        if out_result == :g && display.bases[0].is_a?(Hitter)
            double_play_simulation
        elsif out_result == :f && display.bases[2].is_a?(Hitter)
            sacrifice_fly_simulation
        else 
            inning_outs += 1
        end
    end

    def in_play_guessed_simulation(hitter)
        result = hitter.guessed_tendencies.sample #0,1,2,3,4
        if hit?(result)
            move_players
            record_hit(result)
        else
            record_out
        end
        switch_batter
    end

    def corner_pitch?
        CORNERS.include?(current_pitch_zone)
    end


    def in_play_simulation(hitter)
        result = corner_pitch? ? hitter.corner_tendencies.sample : hitter.tendencies.sample
        if hit?(result)
            move_players
            record_hit(result)
        else
            record_out
        end
        switch_batter
    end

    def strikeout?
        strikes == 3
    end

    def current_batter_pitcher_simulation
        pitch_result = pitch(current_pitcher) #:S or :B
        swing(current_hitter, pitch_result)
    end

    def guessed_hit_simulation(guessed_zone, hitter, pitch)
        if guessed_zone == current_pitch_zone[0]
            puts "Pitch guessed correctly"
            in_play_guessed_simulation(hitter)
        else 
            strikes += 1
            if strikeout?
                puts "Strikeout!"
                add_out
                switch_batter
            else
                puts "Strike swinging"
            end
        end
    end

    def walk?
        balls == 4
    end

    def swing(hitter, pitch)
        guessed_zone = hitter.guess_pitch? # 0,1,2 or false
        if guessed_zone
            guessed_hit_simulation(guessed_zone, hitter, pitch)
        else
            hit_simulation(hitter, pitch)
        end
    end

    def hit_simulation(hitter, pitch)
        swing_choice = hitter.swing?
        if swing_choice == "y" && pitch == :B  
            strikes += 1
            if strikeout?
                puts "Strikeout!"
                add_out
                switch_batter
            else
                puts "Strike swinging"
            end
        elsif swing_choice == "y" && pitch == :S 
            result = SWING_ON_STRIKE_OPTOINS.sample
            if result == :h  
                in_play_simulation(hitter)
            elsif result == :f  
                strikes += 1 unless strikes == 2
                puts "foul"
            elsif result == :s
                strikes += 1  
                if strikeout?
                    puts "Strikeout!"
                    switch_batter
                else
                    puts "Strike swinging"
                end
            end
        elsif swing_choice == "n" && pitch == :B   
            balls += 1 
            if walk?
                puts "Walk!"
                move_players
                switch_batter
            end
        elsif swing_choice == "n" && pitch == :S   
            strikes += 1
            if strikeout?
                puts "Strikeout!"
                add_out
                switch_batter
            else
                puts "Strike looking"
            end
        end
    end

    def play_half_inning
        display.render(current_pitcher, current_hitter, away_team, home_team, inning_outs, balls, strikes)
        current_batter_pitcher_simulation
                


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

    def reset_inning
        @game_outs, @inning_outs, @balls, @strikes = 0, 0, 0, 0
        @inning += 1 if inning_over?
    end

    def play
        welcome_message
        enter_to_start
        until game_won? #outs == 27
            play_half_inning
            switch_sides if half_inning_over?
            reset_inning
        end
    end
end