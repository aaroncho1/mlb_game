require_relative 'hitter'
require_relative 'pitcher'
require_relative 'team'
require_relative 'display'

class Game
    CORNERS = [[0,0], [0,2], [2,0] [2,2]]
    SWING_ON_STRIKE_OPTOINS = [:s, :s, :f, :f, :h, :h, :h, :h]
    attr_reader :display, :away_team, :home_team
    attr_accessor :game_outs, :inning_outs, :inning, :current_pitcher, :inning_half, :pitching_team,
    :hitting_team, :current_hitter, :current_pitch_zone, :strike_zone, :balls, :strikes

    def initialize(away_team, home_team, away_team_hitters, away_team_pitchers, 
        home_team_hitters, home_team_pitchers)
        @away_team, @home_team = away_team, home_team
        @away_team_hitters, @home_team_hitters = away_team_hitters, home_team_hitters
        @away_team_pitchers, @home_team_pitchers = away_team_pitchers, away_team_pitchers
        @game_outs, @inning_outs, @balls, @strikes, @inning = 0, 0, 0, 0, 1
        @inning_half = "Top"
        @pitching_team, @hitting_team = home_team, away_team
        @display = Display.new
        @current_pitcher, @current_hitter, @current_pitch_zone, @current_pitch = nil, hitting_team.players[0], nil, nil
        @strike_zone = Array.new(3){Array.new(3, "_")}
    end

    def switch_batter
        last_hitter = @hitting_team.players.shift
        @hitting_team.players.push(last_hitter)
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

    def score_runs
        players_scored = display.bases.select{|player| display.bases.index(player) > 2}
        @hitting_team.runs += players_scored.count
        players_scored.each do |player|
            puts "#{player.name} scored"
        end
    end 

    def update_bases(result)
        display.bases << current_hitter
        display.move_players(result, current_hitter)
        score_runs if display.bases.length > 3
    end

    def corner_pitch?
        CORNERS.include?(current_pitch_zone)
    end

    def in_play_simulation(hitter)
        result = corner_pitch? ? hitter.corner_tendencies.sample : hitter.tendencies.sample
        if hit?(result)
            record_hit(result)
            update_bases(result)
            switch_batter
        else
            record_out
            switch_batter
        end
        switch_batter
    end

    def strikeout?
        strikes == 3
    end

    def play_half_inning
        display.render(current_pitcher, current_hitter, away_team, home_team, 
        inning, inning_half, inning_outs, balls, strikes, @strike_zone)
        current_batter_pitcher_simulation   
    end

    def current_batter_pitcher_simulation
        pitch_result = pitch(current_pitcher) #:S or :B
        swing(current_hitter, pitch_result)
    end

    def pitch(pitcher)
        pitch = pitcher.choose_pitch #:fastball
        zone = pitcher.choose_zone #[2,0]
        refresh
        @current_pitch_zone = zone #resets the current pitch with each pitch
        @current_pitch = pitch
        result = throw_pitch(pitcher, pitch, zone)
        update_strike_zone(result, zone)
        result # :S or :B
    end

    def throw_pitch(pitcher, pitch, zone)
        selected_pitch_hash = pitcher.tendencies[pitch] #{:fastball => {:S => 8, :B => 2}}
        selected_pitch_tendencies = []
        selected_pitch_hash.each do |pitch_type , n|
            selected_pitch_tendencies += [pitch_type] * n
        end
        first_result = selected_pitch_tendencies.sample 
        result = second_result(pitcher, first_result, zone)
        result #:S or :B
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
    end

    def update_strike_zone(result, zone)
        row, col = zone
        @strike_zone[row][col] = result
    end

    def reset_strike_zone
        @strike_zone = Array.new(3){Array.new(3, "_")}
    end

    def swing(hitter, pitch_result)
        guessed_zone = hitter.guess_zone? # 0,1,2 or false
        if guessed_zone
            guessed_hit_simulation(guessed_zone, hitter, pitch_result)
        else
            hit_simulation(hitter, pitch_result)
        end
    end

    def guessed_hit_simulation(guessed_zone, hitter, pitch_result)
        guessed_pitch = hitter.guess_pitch?(@current_pitch)
        refresh
        if guessed_pitch
            if guessed_pitch == @current_pitch && guessed_zone == current_pitch_zone[0]
                puts "Pitch zone and pitch type guessed correctly"
                in_play_guessed_pitch_simulation(hitter)
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

        if guessed_zone == current_pitch_zone[0]
            puts "Pitch zone guessed correctly"
            in_play_guessed_zone_simulation(hitter)
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
        refresh
    end

    def in_play_guessed_pitch_simulation(hitter)
        hash = hitter.tendencies #0,1,2,3,4 {0 => 120, 1 => 60, 2 => 11, 3 => 1, 4 => 9} out of 200 AB
        guessed_tendencies = []
        hash.each do |k, v|
            if k == 0
                guessed_tendencies += [k] * (v/2)
            else
                guessed_tendencies += [k] * (v * 2)
            end
        end
        result = guessed_tendencies.sample
        if hit?(result)
            record_hit(result)
            update_bases(result)
        else
            record_out
        end
        switch_batter
        refresh
    end

    def in_play_guessed_zone_simulation(hitter)
        hash = hitter.tendencies #0,1,2,3,4 {0 => 120, 1 => 60, 2 => 11, 3 => 1, 4 => 9} 
        guessed_tendencies = []
        hash.each do |k, v|
            guessed_tendencies += [k] * (v * 2)
        end
        result = guessed_tendencies.sample
        if hit?(result)
            record_hit(result)
            update_bases(result)
        else
            record_out
        end
        switch_batter
        refresh
    end

    def hit?(result)
        result > 0
    end

    def record_hit(result)
        case result
        when 1
            puts "Single!"
        when 2
            puts "Double!"
        when 3
            puts "Triple!"
        when 4
            puts "HOME RUN!"
        end
    end

    def walk?
        balls == 4
    end

    def hit_simulation(hitter, pitch_result)
        swing_choice = hitter.swing?
        if swing_choice == "y" && pitch_result == :B  
            strikes += 1
            if strikeout?
                puts "Strikeout!"
                add_out
                switch_batter
            else
                puts "Strike swinging"
            end
        elsif swing_choice == "y" && pitch_result == :S 
            result = SWING_ON_STRIKE_OPTIONS.sample
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
        elsif swing_choice == "n" && pitch_result == :B   
            balls += 1 
            if walk?
                puts "Walk!"
                update_bases(1)
                switch_batter
            end
        elsif swing_choice == "n" && pitch_result == :S   
            strikes += 1
            if strikeout?
                puts "Strikeout!"
                add_out
                switch_batter
            else
                puts "Strike looking"
            end
        end
        refresh
    end

    def refresh
        system("clear")
        display.render(current_pitcher, current_hitter, away_team, home_team, 
        inning, inning_half, inning_outs, balls, strikes, @strike_zone)
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
            if half_inning_over?
                switch_sides
                reset_inning
            end
        end
    end
end