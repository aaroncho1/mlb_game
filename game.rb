require_relative 'hitter'
require_relative 'pitcher'
require_relative 'team'
require_relative 'display'
require 'byebug'

class Game
    CORNERS = [[0,0], [0,2], [2,0] [2,2]]
    SWING_ON_STRIKE_OPTOINS = [:s, :s, :f, :f, :h, :h, :h, :h]
    attr_reader :display, :away_team, :home_team
    attr_accessor :game_outs, :inning_outs, :inning, :current_pitcher, :inning_half, :pitching_team,
    :hitting_team, :current_hitter, :current_pitch_zone, :strike_zone, :balls, :strikes

    def initialize(away_team, home_team)
        @away_team, @home_team = away_team, home_team
        @game_outs, @inning_outs, @balls, @strikes, @inning = 0, 0, 0, 0, 1
        @inning_half = "Top"
        @pitching_team, @hitting_team = home_team, away_team
        @display = Display.new
        @current_pitcher, @current_hitter, @current_pitch_zone, @current_pitch = pitching_team.pitchers[0] , hitting_team.hitters[0], nil, nil
        @strike_zone = Array.new(3){Array.new(3, "_")}
    end

    def switch_batter
        @hitting_team.hitters.rotate!
        @current_hitter = @hitting_team.hitters.first
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

    def corner_pitch?
        CORNERS.include?(current_pitch_zone)
    end

    def play
        debugger
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

    def in_play_simulation(hitter)
        hitter_tendencies = hitter.tendencies
        tendencies = []
        if corner_pitch?
            hitter_tendencies.each do |base,freq|
                if k == 0
                    tendencies += [base] * (freq + (freq/4))
                else
                    tendencies += [base] * freq
                end
            end
            result = tendencies.flatten.sample
        else
            hitter_tendencies.each do |base, freq|
                tendencies += [base] * freq
            end
            result = tendencies.flatten.sample
        end

        if hit?(result)
            record_hit(result)
            update_bases(result)
        else
            record_out
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
        @current_pitch_zone = zone #resets the current pitch with each pitch
        @current_pitch = pitch
        pitch_result = throw_pitch(pitcher, pitch, zone)
        pitch_result # :S or :B
    end

    def throw_pitch(pitcher, pitch, zone)
        intentional_ball_choice = pitcher.make_him_chase?
        return :B if intentional_ball_choice == "y"
        first_pitch_result = first_result(pitch)
        result = second_result(pitcher, first_pitch_result, zone)
        update_pitching_stats(pitcher, result)
        result #:S or :B
    end

    def first_result(pitch)
        selected_pitch_frequencies = @current_pitcher.tendencies[pitch] #{:fastball => {:S => 8, :B => 2}}
        selected_pitch_tendencies = []
        selected_pitch_frequencies.each do |pitch_type , n|
            selected_pitch_tendencies += [pitch_type] * n
        end
        selected_pitch_tendencies.sample
    end

    def second_result(pitcher, first_pitch_result, zone)
        if first_pitch_result == :S && CORNERS.include?(zone)
            corner_pitch_simulator(pitcher)
        elsif first_pitch_result == :S && !CORNERS.include?(zone)
            middle_pitch_simulator(pitcher)
        elsif first_pitch_result == :B    
            :B   
        end
    end

    def walk_batter?
        if walk?
            puts "Walk!"
            update_bases(1)
            switch_batter
        end
    end

    def update_pitching_stats(pitcher, result)
        pitcher.stamina -= pitcher.stamina_interval
        pitcher.pitches += 1
        pitcher.strikes += 1 if result == :S   
    end

    def corner_pitch_simulator(pitcher)
        if pitcher.stamina >= 100
            [:S, :S, :S, :S, :S, :S, :S, :S, :B, :B].sample
        elsif pitcher.stamina >= 50
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

    def update_strike_zone(pitch_result, zone)
        row, col = zone
        @strike_zone[row][col] = pitch_result
    end

    def reset_strike_zone
        @strike_zone = Array.new(3){Array.new(3, "_")}
    end

    def swing(hitter, pitch_result)
        system("clear")
        puts "Batter's turn"
        sleep 1.25
        system("clear")
        sleep 0.25
        refresh 
        go_for_hr = try_for_homerun?
        if go_for_hr == false
            batters_eye_simulation(pitch_result)
            guessed_zone_num = hitter.guess_zone? # 0,1,2 or false
            if guessed_zone_num
                guessed_hit_simulation(guessed_zone_num, hitter, pitch_result)
            else
                hit_simulation(hitter, pitch_result)
            end
        end
    end

    def try_for_homerun?
        swing_for_hr = @current_hitter.swing_for_the_fences?(@current_pitch_zone)
        if swing_for_hr
            if swing_for_hr == @current_pitch_zone
                puts "Pitch zone guessed correctly!"
                home_run_simulation
            else
                record_out
            end
            switch_batter
            refresh
        else 
            return false
        end
    end 

    def home_run_simulation
        tendencies = @current_hitter.tendencies
        homer_tendencies = tendencies.select{|k,v| [0,4].include?(k)}
        arr = []
        homer_tendencies.each do |base,freq|
            if base == 0
                arr << [base] * (freq/10)
            else  
                arr << [base] * (freq * 3)
            end
        end
        result = arr.flatten.sample
        if hit?(result)
            record_hit(result)
            update_bases(result)
        else
            record_out
        end
    end


    def batters_eye_simulation(pitch_result)
        if @current_pitcher.grade == "A+"
            see_pitch = [:n, :n, :n, :n, :n, :n, :n, :n, :n, :y].sample
        elsif @current_pitcher.grade == "A"
            see_pitch = [:n, :n, :n, :n, :n, :n, :n, :n, :y, :y].sample
        elsif @current_pitcher.grade == "B+"
            see_pitch = [:n, :n, :n, :n, :n, :n, :n, :y, :y, :y].sample
        elsif @current_pitcher.grade == "B"
            see_pitch = [:n, :n, :n, :n, :n, :n, :y, :y, :y, :y].sample
        else 
            see_pitch = [:n, :n, :n, :n, :n, :y, :y, :y, :y, :y].sample
        end
        
        if see_pitch == :y  
            if pitch_result == :S 
                puts "Batter eyes strike!" 
            else 
                puts "Batter eyes ball!"
            end
        end
    end

    def guessed_hit_simulation(guessed_zone_num, hitter, pitch_result)
        guessed_pitch_num = hitter.guess_pitch?
        refresh
        if guessed_pitch_num #current_pitch = :fastball
            if @current_pitcher.pitch_options[guessed_pitch_num] == @current_pitch && guessed_zone_num == current_pitch_zone[0] # 1 == 1?
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

        if guessed_zone_num == current_pitch_zone[0]
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
        hitter_tendencies = hitter.tendencies #0,1,2,3,4 {0 => 120, 1 => 45, 2 => 11, 3 => 1, 4 => 9} out of 200 AB
        guessed_tendencies = []
        hitter_tendencies.each do |base, freq| #guaranteed hit
            guessed_tendencies += [base] * freq unless base == 0
        end
        result = guessed_tendencies.sample
        record_hit(result)
        update_bases(result)
        switch_batter
        refresh
    end

    def in_play_guessed_zone_simulation(hitter)
        hitter_tendencies = hitter.tendencies #0,1,2,3,4 {0 => 120, 1 => 60, 2 => 11, 3 => 1, 4 => 9} 
        guessed_tendencies = []
        if @current_pitcher.grade == "A+"
            hitter_tendencies.each {|base, freq| base == 0 ? guessed_tendencies += [base] * (freq/2) : guessed_tendencies += [base] * freq}
        elsif @current_pitcher.grade == "A"
            hitter_tendencies.each {|base, freq| base == 0 ? guessed_tendencies += [base] * (freq/3) : guessed_tendencies += [base] * freq}
        elsif @current_pitcher.grade == "B+"
            hitter_tendencies.each {|base, freq| base == 0 ? guessed_tendencies += [base] * (freq/4) : guessed_tendencies += [base] * freq}
        elsif @current_pitcher.grade == "B"
            hitter_tendencies.each {|base, freq| base == 0 ? guessed_tendencies += [base] * (freq/5) : guessed_tendencies += [base] * freq}
        else 
            hitter_tendencies.each {|base, freq| base == 0 ? guessed_tendencies += [base] * (freq/6) : guessed_tendencies += [base] * freq}
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

    def update_bases(result)
        display.move_players(result, current_hitter)
        update_hitter_stats(result)
        score_runs if display.bases.length > 3
    end

    def update_hitter_stats(result)
        @current_hitter.hits += 1
        @current_hitter.homers += 1 if result == 4
        @current_hitter.at_bats += 1
    end

    def score_runs
        players_scored = display.bases.select{|player| display.bases.index(player) > 2 && player.is_a?(Hitter)}
        @current_hitter.rbis += players_scored.count
        @hitting_team.runs += players_scored.count
        players_scored.each do |player|
            puts "#{player.name} scored"
        end
    end 

    def record_out
        out_result = [:g, :f].sample
        if double_play_situation?(out_result)
            double_play_simulation
        elsif sac_fly_situation?(out_result)
            sac_fly_simulation
        else 
            puts "#{current_hitter.name} flied out" if out_result == :f  
            puts "#{current_hitter.name} grounded out" if out_result == :g 
            @current_hitter.at_bats += 1
            @inning_outs += 1
        end
    end

    def double_play_situation?(out_result)
        out_result == :g && display.bases[0].is_a?(Hitter) && inning_outs < 2
    end

    def sac_fly_situation?(out_result)
        out_result == :f && display.bases[2].is_a?(Hitter) && inning_outs < 2
    end

    def double_play_simulation
        if display.bases[0].speed == "A"
            inning_outs += 1
            display.bases << "empty"
        else
            inning_outs += 2
            display.bases[0] = "empty"
        end
        @current_hitter.at_bats += 1
    end

    def sac_fly_simulation
        if display.bases[2].speed == "A"
            puts "#{display.bases[2].name} scored on a sac fly"
            @current_hitter.rbis += 1
            @hitting_team.runs += 1
            @inning_outs += 1
        elsif display.bases[2].speed == "B"
            score_sim = [:O] * 7 + [:X] * 3
            result = score_sim.sample
            if result == :O 
                puts "#{display.bases[2].name} scored on a sac fly"
                @current_hitter.rbis += 1
                @hitting_team.runs += 1
                @inning_outs += 1
            else
                puts "Double play! #{display.bases[2].name} tagged out at home"
                @inning_outs += 2
            end
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
            walk_batter?
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
        begin
            selected_key = gets.chomp
            system("clear") if selected_key == "s"
            raise "press 's' to start game" if selected_key != "s"
        rescue => e  
            puts e.message
            retry
        end
    end

    def reset_inning
        @game_outs, @inning_outs, @balls, @strikes = 0, 0, 0, 0
        @inning += 1 if inning_over?
    end

    def switch_sides
        @inning_half = @inning_half == "Top" ? "Bottom" : "Top"
        @pitching_team = @pitching_team == home_team ? away_team : home_team
        @hitting_team = @hitting_team == home_team ? away_team : home_team
    end
end

#hitter tendencies are out of 200 ABs
#In tendencies hash, 0 represents out, 1- singles, 2-doubles, 3-triples, 4-homers
#for example, Aaron Judge is projected to hit 14 * 3 = 42 HRs in 600 ABs and batting (200 - 143 outs) 57/ 200 = .285
mets_hitters = [
    Hitter.new("S. Marte", "CF", {0 => 138, 1 => 44, 2 => 12, 3 => 1, 4 => 5}, "A"),
    Hitter.new("B. Nimmo", "RF", {0 => 142, 1 => 42, 2 => 10, 3 => 1, 4 => 5}, "A"),
    Hitter.new("F. Lindor", "SS", {0 => 143, 1 => 32, 2 => 13, 3 => 1, 4 => 11}, "B"),
    Hitter.new("P. Alonso", "1B", {0 => 148, 1 => 24, 2 => 12, 3 => 1, 4 => 15}, "C"),
    Hitter.new("E. Esobar", "3B", {0 => 149, 1 => 30, 2 => 9, 3 => 2, 4 => 10}, "C"),
    Hitter.new("R. Cano", "DH", {0 => 149, 1 => 30, 2 => 14, 3 => 0, 4 => 7}, "D"),
    Hitter.new("J. McNeil", "2B", {0 => 150, 1 => 36, 2 => 9, 3 => 1, 4 => 4}, "B"),
    Hitter.new("J. McCann", "C", {0 => 158, 1 => 31, 2 => 6, 3 => 0, 4 => 5}, "C"),
    Hitter.new("M. Canha", "LF", {0 => 154, 1 => 28, 2 => 9, 3 => 2, 4 => 7}, "B")
]

yankees_hitters = [
    Hitter.new("D. LeMahieu", "2B", {0 => 135, 1 => 45, 2 => 11, 3 => 1, 4 => 8}, "B"),
    Hitter.new("A. Rizzo", "1B", {0 => 150, 1 => 32, 2 => 8, 3 => 1, 4 => 9}, "C"),
    Hitter.new("A. Judge", "RF", {0 => 143, 1 => 34, 2 => 9, 3 => 0, 4 => 14}, "B"),
    Hitter.new("G. Stanton", "DH", {0 => 145, 1 => 33, 2 => 8, 3 => 0, 4 => 14}, "C"),
    Hitter.new("G. Torres", "SS", {0 => 148, 1 => 38, 2 => 10, 3 => 0, 4 => 4}, "C"),
    Hitter.new("J. Donaldson", "3B", {0 => 150, 1 => 27, 2 => 12, 3 => 0, 4 => 11}, "C"),
    Hitter.new("J. Gallo", "LF", {0 => 162, 1 => 10, 2 => 14, 3 => 0, 4 => 14}, "C"),
    Hitter.new("A. Hicks", "CF", {0 => 153, 1 => 27, 2 => 9, 3 => 0, 4 => 11}, "B"),
    Hitter.new("K. Higashioka", "C", {0 => 164, 1 => 16, 2 => 10, 3 => 0, 4 => 10}, "C")
]

#Group of pitchers consist of 3 SP and 2 RP, stamina is based on projected IP and pitch tendencies is based on pitch control
#For example, Jacob DeGrom has a 90% chance of locating his fastball for a strike, compared to 50% for his curveball
mets_pitchers = [
    Pitcher.new("J. DeGrom", "A+", {:fastball => {:S => 9, :B => 1}, :slider => {:S => 8, :B => 2}, :changeup => {:S => 7, :B => 3}, 
    :curveball => {:S => 5, :B => 5}}, 2, {1 => :fastball, 2 => :slider, 3 => :changeup, 4 => :curveball}),
    Pitcher.new("M. Scherzer", "A+", {:fastball => {:S => 8, :B => 2}, :slider => {:S => 7, :B => 3}, :changeup => {:S => 7, :B => 3}, 
    :curveball => {:S => 6, :B => 4}}, 2, {1 => :fastball, 2 => :slider, 3 => :changeup, 4 => :curveball}),
    Pitcher.new("C. Bassitt", "B+", {:fastball => {:S => 7, :B => 3}, :changeup => {:S => 6, :B => 4}, :curveball => {:S => 5, :B => 5}, 
    :sinker => {:S => 4, :B => 6}}, 2, {1 => :fastball, 2 => :changeup, 3 => :curveball, 4 => :sinker}),
    Pitcher.new("S. Lugo", "B", {:fastball => {:S => 7, :B => 3}, :curveball => {:S => 6, :B => 4}, :sinker => {:S => 4, :B => 6}, 
    :slider => {:S => 4, :B => 6}}, 3, {1 => :fastball, 2 => :curveball, 3 => :sinker, 4 => :slider}),
    Pitcher.new("E. Diaz", "A", {:fastball => {:S => 8, :B => 2}, :slider => {:S => 7, :B => 3}}, 4, {1 => :fastball, 2 => :slider})
]

yankees_pitchers = [
    Pitcher.new("G. Cole", "A+", {:fastball => {:S => 8, :B => 2}, :slider => {:S => 7, :B => 3}, :curveball => {:S => 5, :B => 5}, 
    :changeup => {:S => 5, :B => 5}}, 2, {1 => :fastball, 2 => :slider, 3 => :curveball, 4 => :changeup}),
    Pitcher.new("J. Montgomery", "B", {:fastball => {:S => 6, :B => 4}, :changeup => {:S => 6, :B => 4}, :curveball => {:S => 6, :B => 4}, 
    :sinker => {:S => 4, :B => 6}}, 2, {1 => :fastball, 2 => :changeup, 3 => :curveball, 4 => :sinker}),
    Pitcher.new("L. Severino", "B", {:fastball => {:S => 6, :B => 4}, :slider => {:S => 5, :B => 5}, :changeup => {:S => 5, :B => 5}},
    2, {1 => :fastball, 2 => :slider, 3 => :changeup}),
    Pitcher.new("J. Loaisiga", "B+", {:fastball => {:S => 4, :B => 6}, :sinker => {:S => 8, :B => 2}, :curveball => {:S => 6, :B => 4}, 
    :changeup => {:S => 4, :B => 6}}, 4, {1 => :fastball, 2 => :sinker, 3 => :curveball, 4 => :changeup}),
    Pitcher.new("A. Chapman", "A", {:fastball => {:S => 8, :B => 2}, :slider => {:S => 7, :B => 3}, :sinker => {:S => 3, :B => 7}}, 4, {1 => :fastball, 2 => :slider, 3 => :sinker})
]

away_team = Team.new("NYM", mets_hitters, mets_pitchers)
home_team = Team.new("NYY", yankees_hitters, yankees_pitchers)

Game.new(away_team, home_team).play
