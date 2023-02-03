% Alexandre Lavoie
% BattleShip Program
% Version 1.0
% 12 oct 2021

import GUI

%Variables
var Ships_Remaining, Bot_Ships_Remaining : int := 3
var hits : int := 0
var bot_hits : int := 0
var x, y, b : int
var Guide_Answer : int
var rows : int := 10
var columns : int := 10
var x_min : int
var x_max : int
var y_min : int
var y_max : int
var my_row : int := 0
var my_column : int := 0
var hit_color : int
var old_row : int
var old_column : int

var p1_grid : array 1 .. 10, 1 .. 10 of int
var p2_grid : array 1 .. 10, 1 .. 10 of int

var square_length : int := 40
var x_start : int := 215
var x2_start : int := 620
var y_start : int := 500
var x_end : int := 615
var x2_end : int := 1020
var y_end : int := 900

var Attack_1 : int
var Attack_2 : int
var p1_carrier : array 1 .. 5, 1 .. 2 of int
var p1_battleship : array 1 .. 5, 1 .. 2 of int
var p1_cruiser : array 1 .. 5, 1 .. 2 of int
var p1_submarine : array 1 .. 5, 1 .. 2 of int
var p1_destroyer : array 1 .. 5, 1 .. 2 of int

var p2_carrier : array 1 .. 5, 1 .. 2 of int
var p2_battleship : array 1 .. 5, 1 .. 2 of int
var p2_cruiser : array 1 .. 5, 1 .. 2 of int
var p2_submarine : array 1 .. 5, 1 .. 2 of int
var p2_destroyer : array 1 .. 5, 1 .. 2 of int

var carrier_hit : boolean := false
var battleship_hit : boolean := false
var cruiser_hit : boolean := false
var submarine_hit : boolean := false
var destroyer_hit : boolean := false
var carrier_sunk : boolean := false
var battleship_sunk : boolean := false
var cruiser_sunk : boolean := false
var submarine_sunk : boolean := false
var destroyer_sunk : boolean := false

var p1_carrier_sunk : boolean := false
var p1_battleship_sunk : boolean := false
var p1_cruiser_sunk : boolean := false
var p1_submarine_sunk : boolean := false
var p1_destroyer_sunk : boolean := false

var p2_carrier_sunk : boolean := false
var p2_battleship_sunk : boolean := false
var p2_cruiser_sunk : boolean := false
var p2_submarine_sunk : boolean := false
var p2_destroyer_sunk : boolean := false

var player : int := 1
var playername : array 1 .. 2 of string
var winner : int
var intfont : int

var p1_carrier_health : int := 5
var p1_battleship_health : int := 4
var p1_cruiser_health : int := 3
var p1_submarine_health : int := 3
var p1_destroyer_health : int := 2

var p2_carrier_health : int := 5
var p2_battleship_health : int := 4
var p2_cruiser_health : int := 3
var p2_submarine_health : int := 3
var p2_destroyer_health : int := 2

% Settings page variables
% Text boxes
var p1_name_text_id, p2_name_text_id, p1_label, p2_label, p1_random_label, p2_random_label : int
% Radio boxes
var p1_manual_random_choices, p2_manual_random_choices, opponent_human_bot : array 1 .. 2 of int
% Check boxes
var music_box, sound_effects_box : int

% Settings we store:
var music_on, sound_effects_on : boolean
var p1_boat_selection_random, p2_boat_selection_random, opponent_human : boolean

var stop_music : boolean := false

music_on := true
sound_effects_on := true
p1_boat_selection_random := true
p2_boat_selection_random := true
opponent_human := false

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Definitions/Functions/Procedures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 is_boat_placement_valid

 Definition : Checks if the boat placement could be valid
 if the row, column and direction allow room for it.

 Parameters :
 row, column: where the boat would start of be part of
 dir_horiz: Horizontal or not (true or false)
 grid: the grid used
 boat_size: size of the boat

 Return :
 true is there is room, false if there is no room
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function is_boat_placement_valid (row, column : int, dir_horiz : boolean, grid : array 1 .. 10, 1 .. 10 of int, boat_size : int) : boolean
	var is_valid : boolean := false
	var coord_min, coord_max : int
	var i, j : int

	if (grid (row, column) = 0) then
		% Only check when first point is available
		if (dir_horiz = true) then
			% Check if it fits horizontal, find the min and max available on this row
			coord_min := column
			coord_max := column

			% Loop from column to 1 to find minimum coord
			i := column
			loop
				exit when grid (row, i) = 2

				if i < coord_min then
					coord_min := i
				end if

				exit when i <= 1

				i -= 1
			end loop

			% Loop from column to 10 to find maximum coord
			j := column
			loop
				exit when grid (row, j) = 2

				if j > coord_max then
					coord_max := j
				end if

				exit when j >= 10

				j += 1
			end loop

			if (coord_max - coord_min + 1) >= boat_size then
				is_valid := true
			end if
		else
			% Check if it fits vertical, find the min and max available on this column
			coord_min := row
			coord_max := row

			% Loop from row to 1 to find minimum coord
			i := row
			loop
				exit when grid (i, column) = 2

				if i < coord_min then
					coord_min := i
				end if

				exit when i <= 1

				i -= 1
			end loop

			% Loop from row to 1 to find maximum coord
			j := row
			loop
				exit when grid (j, column) = 2

				if j > coord_max then
					coord_max := j
				end if

				exit when j >= 10

				j += 1
			end loop

			if (coord_max - coord_min + 1) >= boat_size then
				is_valid := true
			end if
		end if
	end if
	result is_valid
end is_boat_placement_valid


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 play_music

 Definition : Makes the option of selecting music On or Off

 Parameters :
 filled: true if music is On, false otherwise

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
process play_music ()
loop
	Music.PlayFile ("music.mid")
	exit when stop_music = true
end loop
end play_music

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 play_ending_music

 Definition : Makes the option of selecting music On or Off

 Parameters :
 filled: true if music is On, false otherwise

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
process play_ending_music ()
loop
	Music.PlayFile ("ending.mid")
	exit when stop_music = true
end loop
end play_ending_music


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 music_box_pressed

 Definition : Makes the option of selecting music On or Off

 Parameters :
 filled (user selection): true if music is On, false otherwise

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure music_box_pressed (filled : boolean)
	music_on := filled
end music_box_pressed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 sound_effects_box_pressed

 Definition : Makes the option of selecting sound effects On or Off

 Parameters :
 filled (user selection): true if sound effects are On, false otherwise

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure sound_effects_box_pressed (filled : boolean)
	sound_effects_on := filled
end sound_effects_box_pressed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 p1_manual_random_pressed

 Definition : Makes the option of selecting the boat squares manually or randomly for player 1.

 Parameters :
 None

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure p1_manual_random_pressed
	var widget_id : int := GUI.GetEventWidgetID

	if p1_manual_random_choices (1) = widget_id then
		p1_boat_selection_random := true
	else
		p1_boat_selection_random := false
	end if
end p1_manual_random_pressed


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 p2_manual_random_pressed

 Definition : Makes the option of selecting the boat squares manually or randomly for player 2.

 Parameters :
 None

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure p2_manual_random_pressed
	var widget_id : int := GUI.GetEventWidgetID

	if p2_manual_random_choices (1) = widget_id then
		p2_boat_selection_random := true
	else
		p2_boat_selection_random := false
	end if
end p2_manual_random_pressed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 opponent_human_bot_pressed

 Definition : Makes the option of selecting the human or computer opponent.

 Parameters :
 None

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure opponent_human_bot_pressed
	var widget_id : int := GUI.GetEventWidgetID

	if opponent_human_bot (1) = widget_id then
		opponent_human := false
		% Hide the player 2 settings
		GUI.Hide (p2_name_text_id)
		GUI.Hide (p2_label)
		GUI.Hide (p2_random_label)
		for i : 1 .. 2
			GUI.Hide (p2_manual_random_choices (i))
		end for
	else
		opponent_human := true
		% Show the player 2 settings
		GUI.Show (p2_name_text_id)
		GUI.Show (p2_label)
		GUI.Show (p2_random_label)
		for i : 1 .. 2
			GUI.Show (p2_manual_random_choices (i))
		end for

	end if
end opponent_human_bot_pressed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 do_nothing_text

 Definition : Does nothing, procedure for text fields

 Parameters :
 text (string)

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure do_nothing_text (text : string)
end do_nothing_text

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 play_game

 Definition : Record all settings and exit the settings menu

 Parameters :
 None

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure play_game ()
	% Record the settings
	playername (1) := GUI.GetText (p1_name_text_id)
	playername (2) := GUI.GetText (p2_name_text_id)
	% Exit the setting page and continue to the game
	GUI.Quit ()
end play_game

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 Help

 Definition : Procedure that displays some How to play text.

 Parameters :
 None

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure Help
	var helptext : array 1 .. 22 of string
	var helplines : int := 22
	var yhelp : int := maxy - 350
	
	helptext (1) := "How to play / Basic Gameplay: "
	helptext (2) := "Players take turns firing shots (by clicking on squares in a grid)"
	helptext (3) := " to attempt to hit the opponent's enemy ships."
	helptext (4) := ""
	helptext (5) := "On your turn, click a square on "
	helptext (6) := "your target grid."
	helptext (7) := "The game responds 'miss' if"
	helptext (8) := "there is no ship there, or 'hit' if you have correctly guessed a space that is occupied "
	helptext (9) := "by a ship."

	helptext (10) := "The game marks each of your shots or attempts to fire on the enemy using your target "
	helptext (11) := "grid (upper part of the board) by using red pegs to document your misses "
	helptext (12) := "and green pegs to register your hits. As the game proceeds, the green pegs will gradually "
	helptext (13) := "identify the size and location of your opponent's ships."
	helptext (14) := ""
	helptext (15) := "When it is your opponent's turn to fire shots at you, each time one of your ships "
	helptext (16) := "receives a hit, the game puts a green peg into the hole on the ship corresponding to the grid space."
	helptext (17) := "When one of your ships has every slot filled with green pegs, the game will announce to your opponent"
	helptext (18) := "when your ship is sunk. In classic play, the phrase is 'You sunk my battleship!'"
	helptext (19) := ""
	helptext (20) := "Number of boats: 5"
	helptext (21) := "Carrier (occupies 5 spaces), Battleship (4), Cruiser (3), Submarine (3), and Destroyer (2)."
	helptext (22) := "The first player to sink all five of their opponent's ships wins the game."

	for i : 1 .. helplines
		intfont := Font.New ("Times New Roman:15")
		Font.Draw (helptext (i), 200, yhelp, intfont, 34)
		yhelp -= 20
		delay (20)
	end for
end Help

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 display_health_bar

 Definition : Displays 1 health bar

 Parameters :
 x, y: coordinates where to draw the health bar
 health: health value
 health_max: maximum health value

 Return :
 Nothing
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure display_health_bar (x, y, health, health_max : int)
	var health_sq_len : int := 25
	var x2 := x
	var percent : real := (health / health_max) * 100
	var used_color : int

	if (health_max = 2) then
		if percent > 50 then
			used_color := 10
		elsif percent > 0 and percent < 51 then
			used_color := 12
		else
			used_color := 8
		end if
	end if

	if (health_max = 3) then
		if percent > 67 then
			used_color := 10
		elsif percent > 34 then
			used_color := 14
		elsif percent > 0 then
			used_color := 12
		else
			used_color := 8
		end if
	end if

	if (health_max = 4) then
		if percent > 75 then
			used_color := 10
		elsif percent > 50 then
			used_color := 14
		elsif percent > 25 then
			used_color := 42
		elsif percent > 0 then
			used_color := 12
		else
			used_color := 8
		end if
	end if

	if (health_max = 5) then
		if percent > 80 then
			used_color := 10
		elsif percent > 60 then
			used_color := 45
		elsif percent > 40 then
			used_color := 14
		elsif percent > 20 then
			used_color := 42
		elsif percent > 0 then
			used_color := 12
		else
			used_color := 8
		end if
	end if

	for i : 1 .. health_max
		drawbox (x2, y, x2 + health_sq_len, y + health_sq_len, black)
		drawfillbox (x2 + 1, y + 1, x2 - 1 + health_sq_len, y - 1 + health_sq_len, 8)
		x2 += health_sq_len
	end for

	x2 := x
	for j : 1 .. health
		drawfillbox (x2 + 1, y + 1, x2 - 1 + health_sq_len, y - 1 + health_sq_len, used_color)

		x2 += health_sq_len
	end for
end display_health_bar


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 display_health_bars

 Definition : Displays multiple health bars.

 Parameters :
 None

 Return :
 Nothing
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure display_health_bars ()

	%Draw the side boats

	%Left Side
	var x_align : int := 15
	var y_align : int := y_end
	Draw.Text ("Carrier", x_align, y_align, defFontID, black)
	Draw.Text ("Battleship", x_align, y_align - 100, defFontID, black)
	Draw.Text ("Cruiser", x_align, y_align - 200, defFontID, black)
	Draw.Text ("Submarine", x_align, y_align - 300, defFontID, black)
	Draw.Text ("Destroyer", x_align, y_align - 400, defFontID, black)
	x_align := 15
	y_align := y_end - 50
	display_health_bar (x_align, y_align, p1_carrier_health, 5)
	display_health_bar (x_align, y_align - 100, p1_battleship_health, 4)
	display_health_bar (x_align, y_align - 200, p1_cruiser_health, 3)
	display_health_bar (x_align, y_align - 300, p1_submarine_health, 3)
	display_health_bar (x_align, y_align - 400, p1_destroyer_health, 2)

	%Right Side
	x_align := x2_end + 100
	y_align := y_end
	Draw.Text ("Carrier", x_align, y_align, defFontID, black)
	Draw.Text ("Battleship", x_align, y_align - 100, defFontID, black)
	Draw.Text ("Cruiser", x_align, y_align - 200, defFontID, black)
	Draw.Text ("Submarine", x_align, y_align - 300, defFontID, black)
	Draw.Text ("Destroyer", x_align, y_align - 400, defFontID, black)
	x_align := x2_end + 100
	y_align := y_end - 50
	display_health_bar (x_align, y_align, p2_carrier_health, 5)
	display_health_bar (x_align, y_align - 100, p2_battleship_health, 4)
	display_health_bar (x_align, y_align - 200, p2_cruiser_health, 3)
	display_health_bar (x_align, y_align - 300, p2_submarine_health, 3)
	display_health_bar (x_align, y_align - 400, p2_destroyer_health, 2)


end display_health_bars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 draw_display_text_topest

 Definition : Displays a message in the very top area

 Parameters :
 text: string to display

 Return :
 Nothing
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure draw_display_text_topest (text : string)
	intfont := Font.New ("Times New Roman:16")
	drawfillbox (380, 430, 900, 470, white)
	Font.Draw (text, 380, 450, intfont, black)
	delay (50)
end draw_display_text_topest

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 draw_display_text_top

 Definition : Displays a message in the top area

 Parameters :
 text: string to display

 Return :
 Nothing
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure draw_display_text_top (text : string)
	intfont := Font.New ("Times New Roman:15")
	drawfillbox (380, 380, 900, 420, white)
	Font.Draw (text, 380, 400, intfont, black)
	delay (50)
end draw_display_text_top

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 draw_display_text_middle

 Definition : Displays a message in the middle area

 Parameters :
 text: string to display

 Return :
 Nothing
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure draw_display_text_middle (text : string)
	intfont := Font.New ("Times New Roman:14")
	drawfillbox (380, 330, 900, 370, white)
	Font.Draw (text, 380, 350, intfont, black)
	delay (50)
end draw_display_text_middle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 draw_display_text_bottom

 Definition : Displays a message in the bottom area

 Parameters :
 text: string to display

 Return :
 Nothing
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure draw_display_text_bottom (text : string)
	intfont := Font.New ("Times New Roman:12")
	drawfillbox (380, 280, 900, 320, white)
	Font.Draw (text, 380, 300, intfont, black)
	delay (50)
end draw_display_text_bottom

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 add_boat_in_grid

 Definition : % Code that checks if one of boat is getting hit, you put a message if a boat is hit.

 Parameters :
 grid: 2D array that represents the board squares.
 boat_coords: 2D array of the boat coordinates that will represent where the boat will be.
 boat_size: The modified size of the boat.

 Return :
 grid that now includes the boat coordinates
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function add_boat_in_grid (grid : array 1 .. 10, 1 .. 10 of int, boat_coords : array 1 .. 5, 1 .. 2 of int, boat_size : int) : array 1 .. 10, 1 .. 10 of int
	var new_grid : array 1 .. 10, 1 .. 10 of int
	var row : int
	var column : int
	new_grid := grid
	for e : 1 .. boat_size
		row := boat_coords (e, 1)
		column := boat_coords (e, 2)
		new_grid (row, column) := 2
	end for
	result new_grid
end add_boat_in_grid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 check_boat_hit

 Definition : Checks if a boat was hit on this row/column.

 Parameters :
 row, column: area that was hit.
 boat_coords: 2D array of the boat coordinates that will represent where the boat will be.
 boat_size: The modified size of the boat.

 Return :
 boat_hit: true if hit, false if not hit
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function check_boat_hit (row, column : int, boat_coords : array 1 .. 5, 1 .. 2 of int, boat_size : int) : boolean
	var boat_hit : boolean := false
	var boat_row, boat_column : int

	for i : 1 .. boat_size
		boat_row := boat_coords (i, 1)
		boat_column := boat_coords (i, 2)
		if boat_row = row and boat_column = column then
			boat_hit := true
		end if
	end for

	result boat_hit
end check_boat_hit


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 check_boat_sunk

 Definition : Checks if one of boat is sunk, you put a message if a boat is sunk.

 Parameters :
 grid: 2D array that represents the board squares.
 boat_coords: 2D array of the boat coordinates that will represent where the boat will be.
 boat_size: The modified size of the boat.

 Return :
 boat_sunk: true if sunk, false if not sunk
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function check_boat_sunk (grid : array 1 .. 10, 1 .. 10 of int, boat_coords : array 1 .. 5, 1 .. 2 of int, boat_size : int) : boolean
	var boat_sunk : boolean := true

	for i : 1 .. boat_size
		if grid (boat_coords (i, 1), boat_coords (i, 2)) = 2 then
			boat_sunk := false
		end if
	end for

	result boat_sunk
end check_boat_sunk

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 submit_boat_coords

 Definition : Code that records the squares clicked by the user for one boat

 Parameters :
 grid: 2D array that represents the board squares.
 boat_size: The size of the boat.
 player: 1 or 2

 Return :
 boat:2D array containing the boat coordinates
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function submit_boat_coords (grid : array 1 .. 10, 1 .. 10 of int, boat_size, boat_color, player : int) : array 1 .. 5, 1 .. 2 of int
	var boat : array 1 .. 5, 1 .. 2 of int
	var num_coords : int := 0
	draw_display_text_topest ("Turn:")

	if player = 1 then
		x_min := x_start
		x_max := x_end
		y_min := y_start
		y_max := y_end

		draw_display_text_top (playername (1) + ", please select your boats.")
		% Draw a line over the player area
		% Bottom horizontal
		drawline (x_min - 5, y_min - 5, x_max, y_min - 5, 34)
		% Vertical
		drawline (x_min - 5, y_min - 5, x_min - 5, y_max + 5, 34)
		% Top horizontal
		drawline (x_min - 5, y_max + 5, x_max, y_max + 5, 34)
	elsif player = 2 then
		x_min := x2_start
		x_max := x2_end
		y_min := y_start
		y_max := y_end

		draw_display_text_top (playername (2) + ", please select your boats.")
		% Draw a line over the player area
		% Bottom horizontal
		drawline (x_min - 5, y_min - 5, x_max + 5, y_min - 5, 34)
		% Vertical
		drawline (x_max + 5, y_min - 5, x_max + 5, y_max + 5, 34)
		% Top horizontal
		drawline (x_min - 5, y_max + 5, x_max + 5, y_max + 5, 34)
	end if

	my_row := -1
	my_column := -1
	loop
		old_row := my_row
		old_column := my_column
		loop
			mousewhere (x, y, b)
			if (x >= x_min and x <= x_max and y >= y_min and y <= y_max and b = 1) then
				my_row := ((y - y_min) div square_length) + 1
				my_column := ((x - x_min) div square_length) + 1
			else
				my_row := -1
				my_column := -1
			end if
			exit when my_row >= 1 and my_row <= 10 and my_column >= 1 and my_column <= 10
			delay (10)
		end loop

		if ((old_row not= my_row) or (old_column not= my_column)) and grid (my_row, my_column) = 0 then
			% Only accept coords that are connecting and in the same direction
			var accept_coord : boolean := false
			var boat_row, boat_column : int

			if num_coords = 0 then
				var horiz_valid : boolean
				var vert_valid : boolean
				% Accept 1st click if there is room
				horiz_valid := is_boat_placement_valid (my_row, my_column, true, grid, boat_size)
				vert_valid := is_boat_placement_valid (my_row, my_column, false, grid, boat_size)
				if horiz_valid = true or vert_valid = true then
					accept_coord := true
				end if
			elsif num_coords = 1 then
				% 2nd click: Accept above, below, left or right but only if there is room in that direction
				boat_row := boat (1, 1)
				boat_column := boat (1, 2)
				% Check above, below, left and right
				if (my_row = boat_row + 1 and my_column = boat_column) or
						(my_row = boat_row - 1 and my_column = boat_column) then

					accept_coord := is_boat_placement_valid (my_row, my_column, false, grid, boat_size)

				elsif (my_row = boat_row and my_column = boat_column - 1) or
						(my_row = boat_row and my_column = boat_column + 1) then

					accept_coord := is_boat_placement_valid (my_row, my_column, true, grid, boat_size)
				end if
			else
				var coord_min, coord_max : int
				% 3rd click or more: accept the ends
				% Find the direction, horizontal or vertical, by checking first 2 row points
				if boat (1, 1) = boat (2, 1) then
					% Horizontal: find the row number, same for all points, just pick one
					boat_row := boat (1, 1)

					coord_min := 11
					coord_max := 0
					% Find farthest columns
					for i : 1 .. num_coords
						if boat (i, 2) < coord_min then
							coord_min := boat (i, 2)
						end if
						if boat (i, 2) > coord_max then
							coord_max := boat (i, 2)
						end if
					end for
					% Now we know what 2 points we can accept based on min and max of boat
					if (my_row = boat_row) and ((my_column = coord_min - 1) or (my_column = coord_max + 1)) then
						accept_coord := true
					end if
				else
					% Vertical: find the column number, same for all points, just pick one
					boat_column := boat (1, 2)

					coord_min := 11
					coord_max := 0
					% Find farthest rows
					for i : 1 .. num_coords
						if boat (i, 1) < coord_min then
							coord_min := boat (i, 1)
						end if
						if boat (i, 1) > coord_max then
							coord_max := boat (i, 1)
						end if
					end for
					% Now we know what 2 points we can accept based on min and max of boat
					if (my_column = boat_column) and ((my_row = coord_min - 1) or (my_row = coord_max + 1)) then
						accept_coord := true
					end if
				end if
			end if
			if accept_coord = true then
				var x1 : int := ((my_column - 1) * square_length) + x_min
				var y1 : int := ((my_row - 1) * square_length) + y_min
				var x2 : int := x1 + square_length
				var y2 : int := y1 + square_length
				drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, boat_color)
				num_coords += 1
				boat (num_coords, 1) := my_row
				boat (num_coords, 2) := my_column
			end if
		end if
		exit when num_coords = boat_size
	end loop


	if player = 1 then
		x_min := x_start
		x_max := x_end
		y_min := y_start
		y_max := y_end
		% Clear the line over the player area
		% Bottom horizontal
		drawline (x_min - 5, y_min - 5, x_max, y_min - 5, white)
		% Vertical
		drawline (x_min - 5, y_min - 5, x_min - 5, y_max + 5, white)
		% Top horizontal
		drawline (x_min - 5, y_max + 5, x_max, y_max + 5, white)
	elsif player = 2 then
		x_min := x2_start
		x_max := x2_end
		y_min := y_start
		y_max := y_end
		% Clear the line over the player area
		% Bottom horizontal
		drawline (x_min - 5, y_min - 5, x_max + 5, y_min - 5, white)
		% Vertical
		drawline (x_max + 5, y_min - 5, x_max + 5, y_max + 5, white)
		% Top horizontal
		drawline (x_min - 5, y_max + 5, x_max + 5, y_max + 5, white)
	end if

	result boat

end submit_boat_coords

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 find_random_boat_coords

 Definition : Code that finds random coordinates for one boat

 Parameters :
 grid: 2D array that represents the board squares.
 boat_size: The size of the boat.

 Return :
 boat:2D array containing the boat coordinates
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function find_random_boat_coords (grid : array 1 .. 10, 1 .. 10 of int, boat_size : int) : array 1 .. 5, 1 .. 2 of int
	% Select the boats randomly
	var boat : array 1 .. 5, 1 .. 2 of int
	var random_row : int
	var random_column : int
	var random_direction : int
	var horizontal : boolean
	var valid : boolean := false
	var dir_string : string
	var grid_i, boat_i : int

	loop
		randint (random_row, 1, 10)
		randint (random_column, 1, 10)
		randint (random_direction, 1, 2)
		if random_direction = 1 then
			horizontal := false
			dir_string := "Vertical"
		else
			horizontal := true
			dir_string := "Horizontal"
		end if
		valid := is_boat_placement_valid (random_row, random_column, horizontal, grid, 5)
		exit when valid = true
	end loop

	% Find the boat coordinates that fit in the grid
	if horizontal = true then
		% Horizontal
		grid_i := random_column
		boat_i := 0
		loop
			exit when grid_i > 10
			exit when grid (random_row, grid_i) = 2
			boat_i += 1
			boat (boat_i, 1) := random_row
			boat (boat_i, 2) := grid_i
			exit when boat_i >= boat_size
			grid_i += 1
		end loop
		% Check if the boat is filled and go in reverse if you need
		if boat_i < boat_size then
			grid_i := random_column - 1
			loop
				exit when grid_i > 10
				exit when grid (random_row, grid_i) = 2
				boat_i += 1
				boat (boat_i, 1) := random_row
				boat (boat_i, 2) := grid_i
				exit when boat_i >= boat_size
				grid_i -= 1
			end loop
		end if
	else
		% Vertical
		grid_i := random_row
		boat_i := 0
		loop
			exit when grid_i > 10
			exit when grid (grid_i, random_column) = 2
			boat_i += 1
			boat (boat_i, 1) := grid_i
			boat (boat_i, 2) := random_column
			exit when boat_i >= boat_size
			grid_i += 1
		end loop
		% Check if the boat is filled and go in reverse if you need
		if boat_i < boat_size then
			grid_i := random_row - 1
			loop
				exit when grid_i > 10
				exit when grid (grid_i, random_column) = 2
				boat_i += 1
				boat (boat_i, 1) := grid_i
				boat (boat_i, 2) := random_column
				exit when boat_i >= boat_size
				grid_i -= 1
			end loop
		end if
	end if

	result boat
end find_random_boat_coords

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 initialize_grid

 Definition : % Code that fills the grid including with the boat information

 Parameters :
 None
 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure initialize_grid
	for i : 1 .. rows
		for j : 1 .. columns
			p1_grid (i, j) := 0
			p2_grid (i, j) := 0
		end for
	end for
end initialize_grid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 update_boat_hits

 Definition : Update boat hits for the player

 Parameters :
 player: 1 or 2

 Return :
 Nothing
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure update_boat_hits (player : int)
	if player = 1 then

		if carrier_hit = true then
			p1_carrier_health -= 1
		end if
		if battleship_hit = true then
			p1_battleship_health -= 1
		end if
		if cruiser_hit = true then
			p1_cruiser_health -= 1
		end if
		if submarine_hit = true then
			p1_submarine_health -= 1
		end if
		if destroyer_hit = true then
			p1_destroyer_health -= 1
		end if
		p1_carrier_sunk := carrier_sunk
		p1_battleship_sunk := battleship_sunk
		p1_cruiser_sunk := cruiser_sunk
		p1_submarine_sunk := submarine_sunk
		p1_destroyer_sunk := destroyer_sunk

	elsif player = 2 then
		if carrier_hit = true then
			p2_carrier_health -= 1
		end if
		if battleship_hit = true then
			p2_battleship_health -= 1
		end if
		if cruiser_hit = true then
			p2_cruiser_health -= 1
		end if
		if submarine_hit = true then
			p2_submarine_health -= 1
		end if
		if destroyer_hit = true then
			p2_destroyer_health -= 1
		end if
		p2_carrier_sunk := carrier_sunk
		p2_battleship_sunk := battleship_sunk
		p2_cruiser_sunk := cruiser_sunk
		p2_submarine_sunk := submarine_sunk
		p2_destroyer_sunk := destroyer_sunk

	end if

	% Clear stats until next time
	carrier_hit := false
	battleship_hit := false
	cruiser_hit := false
	submarine_hit := false
	destroyer_hit := false

	if carrier_sunk = true and battleship_sunk = true and cruiser_sunk = true and submarine_sunk = true and destroyer_sunk = true then
		draw_display_text_topest ("Now thats the end of the game! All the ships are sunk!")
		% The player being attacked loses if all their boats are sunk
		if player = 1 then
			winner := 2
		else
			winner := 1
		end if
	end if

end update_boat_hits


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 attack_boat

 Definition : Code that attacks a square in the grid and updates the grid with the new info
 grid is marked with these values
 0: empty
 1: square was tried and missed (no boat)
 2: boat
 3: boat is hit

 Parameters :
 grid: 2D array that represents the board squares.
 carrier, battleship, cruiser, submarine, destroyer: 5 boats coordinates
 player: 1 or 2 that you are attacking

 Return :
 grid:2D array containing the updated grid with the attack information
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function attack_boat (attack_grid : array 1 .. 10, 1 .. 10 of int, carrier, battleship, cruiser, submarine, destroyer : array 1 .. 5, 1 .. 2 of int, player : int) : array 1 .. 10, 1 .. 10 of
		int
	var grid : array 1 .. 10, 1 .. 10 of int := attack_grid
	var attacker : string
	draw_display_text_topest ("Turn:")
	if player = 1 then
		x_min := x_start
		x_max := x_end
		y_min := y_start
		y_max := y_end
		
		attacker := playername(2)
		draw_display_text_top (attacker + ", please attack !")
		draw_display_text_middle ("")
		draw_display_text_bottom ("")
		% Draw a line over the player area
		% Bottom horizontal
		drawline (x_min - 5, y_min - 5, x_max, y_min - 5, 34)
		% Vertical
		drawline (x_min - 5, y_min - 5, x_min - 5, y_max + 5, 34)
		% Top horizontal
		drawline (x_min - 5, y_max + 5, x_max, y_max + 5, 34)
	elsif player = 2 then
		x_min := x2_start
		x_max := x2_end
		y_min := y_start
		y_max := y_end

		attacker := playername(1)
		draw_display_text_top (attacker + ", please attack !")
		draw_display_text_middle ("")
		draw_display_text_bottom ("")
		% Draw a line over the player area
		% Bottom horizontal
		drawline (x_min - 5, y_min - 5, x_max + 5, y_min - 5, 34)
		% Vertical
		drawline (x_max + 5, y_min - 5, x_max + 5, y_max + 5, 34)
		% Top horizontal
		drawline (x_min - 5, y_max + 5, x_max + 5, y_max + 5, 34)
	end if

	loop
		mousewhere (x, y, b)
		if (x >= x_min and x <= x_max and y >= y_min and y <= y_max and b = 1) then
			my_row := ((y - y_min) div square_length) + 1
			my_column := ((x - x_min) div square_length) + 1
		else
			my_row := -1
			my_column := -1
		end if
		exit when ((my_row >= 1 and my_row <= 10 and my_column >= 1 and my_column <= 10)) and (grid (my_row, my_column) = 0 or grid (my_row, my_column) = 2)
		delay (10)
	end loop

	if grid (my_row, my_column) = 1 then
		draw_display_text_middle (attacker + " already attempted attacking here! Please try another square.")
		draw_display_text_bottom ("")
	elsif grid (my_row, my_column) = 3 then
		draw_display_text_middle (attacker + " already attempted attacking here! Please try another square.")
		draw_display_text_bottom ("")
	elsif grid (my_row, my_column) = 0 then
		draw_display_text_middle ("Miss!")
		draw_display_text_bottom ("")
		grid (my_row, my_column) := 1

	elsif grid (my_row, my_column) = 2 then
		grid (my_row, my_column) := 3
		draw_display_text_middle ("Hit!")
		carrier_hit := check_boat_hit (my_row, my_column, carrier, 5)
		battleship_hit := check_boat_hit (my_row, my_column, battleship, 4)
		cruiser_hit := check_boat_hit (my_row, my_column, cruiser, 3)
		submarine_hit := check_boat_hit (my_row, my_column, submarine, 3)
		destroyer_hit := check_boat_hit (my_row, my_column, destroyer, 2)
		
		carrier_sunk := false
		battleship_sunk := false
		cruiser_sunk := false
		submarine_sunk := false
		destroyer_sunk := false
		
		if carrier_hit = true then
			draw_display_text_bottom (attacker + " hit the carrier!")
			carrier_sunk := check_boat_sunk (grid, carrier, 5)
			if carrier_sunk = true then
				draw_display_text_bottom (attacker + " sank the carrier!")
			end if

		elsif battleship_hit = true then
			draw_display_text_bottom (attacker + " hit the battleship!")
			battleship_sunk := check_boat_sunk (grid, battleship, 4)
			if battleship_sunk = true then
				draw_display_text_bottom (attacker + " sank the battleship!")
			end if

		elsif cruiser_hit = true then
			draw_display_text_bottom (attacker + " hit the cruiser!")
			cruiser_sunk := check_boat_sunk (grid, cruiser, 3)
			if cruiser_sunk = true then
				draw_display_text_bottom (attacker + " sank the cruiser!")
			end if
		elsif submarine_hit = true then
			draw_display_text_bottom (attacker + " hit the submarine!")
			submarine_sunk := check_boat_sunk (grid, submarine, 3)
			if submarine_sunk = true then
				draw_display_text_bottom (attacker + " sank the submarine!")
			end if

		elsif destroyer_hit = true then
			draw_display_text_bottom (attacker + " hit the destroyer!")
			destroyer_sunk := check_boat_sunk (grid, destroyer, 2)
			if destroyer_sunk = true then
				draw_display_text_bottom (attacker + " sank the destroyer!")
			end if
		end if

	end if

	var x1 : int := ((my_column - 1) * square_length) + x_min
	var y1 : int := ((my_row - 1) * square_length) + y_min
	var x2 : int := x1 + square_length
	var y2 : int := y1 + square_length

	if carrier_hit = true or battleship_hit = true or cruiser_hit = true or submarine_hit = true or destroyer_hit = true then
		hit_color := 10
		drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, 10)
		if sound_effects_on = true then
			Music.PlayFile ("hit.mp3")
		else
			delay (1000)
		end if
		if carrier_sunk = true or battleship_sunk = true or cruiser_sunk = true or submarine_sunk = true or destroyer_sunk = true then
			if sound_effects_on = true then
				Music.PlayFile ("sunk.mp3")
			end if
		end if
	else
		drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, 12)
		if sound_effects_on = true then
			Music.PlayFile ("miss.mp3")
		else
			delay (1000)
		end if
	end if

	% Check boat sunks again, so we can check if it is game over
	carrier_sunk := check_boat_sunk (grid, carrier, 5)
	battleship_sunk := check_boat_sunk (grid, battleship, 4)
	cruiser_sunk := check_boat_sunk (grid, cruiser, 3)
	submarine_sunk := check_boat_sunk (grid, submarine, 3)
	destroyer_sunk := check_boat_sunk (grid, destroyer, 2)
	
	if player = 1 then
		x_min := x_start
		x_max := x_end
		y_min := y_start
		y_max := y_end

		% Clear line over the player area
		% Bottom horizontal
		drawline (x_min - 5, y_min - 5, x_max, y_min - 5, white)
		% Vertical
		drawline (x_min - 5, y_min - 5, x_min - 5, y_max + 5, white)
		% Top horizontal
		drawline (x_min - 5, y_max + 5, x_max, y_max + 5, white)

	elsif player = 2 then
		x_min := x2_start
		x_max := x2_end
		y_min := y_start
		y_max := y_end

		% Clear a line over the player area
		% Bottom horizontal
		drawline (x_min - 5, y_min - 5, x_max + 5, y_min - 5, white)
		% Vertical
		drawline (x_max + 5, y_min - 5, x_max + 5, y_max + 5, white)
		% Top horizontal
		drawline (x_min - 5, y_max + 5, x_max + 5, y_max + 5, white)

	end if

	result grid
end attack_boat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 bot_attack_boat

 Definition : Code when the Bot (player 2) attacks a square in the grid and updates the grid with the new info
 grid is marked with these values
 0: empty
 1: square was tried and missed (no boat)
 2: boat
 3: boat is hit

 Parameters :
 grid: 2D array that represents the board squares.
 carrier, battleship, cruiser, submarine, destroyer: 5 boats coordinates

 Return :
 grid:2D array containing the updated grid with the attack information
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bot_attack_boat (attack_grid : array 1 .. 10, 1 .. 10 of int, carrier, battleship, cruiser, submarine, destroyer : array 1 .. 5, 1 .. 2 of int) : array 1 .. 10, 1 .. 10 of
		int
	var grid : array 1 .. 10, 1 .. 10 of int := attack_grid
	var random_row, random_column : int
	draw_display_text_topest ("Turn:")

	x_min := x_start
	x_max := x_end
	y_min := y_start
	y_max := y_end

	draw_display_text_top (playername (2) + ", attacks !")
	draw_display_text_middle ("")
	draw_display_text_bottom ("")

	% Draw a line over the player area
	% Bottom horizontal
	drawline (x_min - 5, y_min - 5, x_max, y_min - 5, 34)
	% Vertical
	drawline (x_min - 5, y_min - 5, x_min - 5, y_max + 5, 34)
	% Top horizontal
	drawline (x_min - 5, y_max + 5, x_max, y_max + 5, 34)

	% Instead of letting the user select the square, choose a random square that is not already hit or missed
	loop
		randint (my_row, 1, 10)
		randint (my_column, 1, 10)
		exit when (grid (my_row, my_column) = 0 or grid (my_row, my_column) = 2)
	end loop

	if grid (my_row, my_column) = 1 then
		draw_display_text_middle (playername (2) + ": You already attempted attacking here! Please try another square.")
		draw_display_text_bottom ("")
	elsif grid (my_row, my_column) = 3 then
		draw_display_text_middle (playername (2) + ": You already attempted attacking here! Please try another square.")
		draw_display_text_bottom ("")
	elsif grid (my_row, my_column) = 0 then
		draw_display_text_middle (playername (2) + " Missed !")
		draw_display_text_bottom ("")
		grid (my_row, my_column) := 1
	elsif grid (my_row, my_column) = 2 then
		grid (my_row, my_column) := 3
		draw_display_text_middle (playername (2) + " Hit!")

		carrier_hit := check_boat_hit (my_row, my_column, carrier, 5)
		battleship_hit := check_boat_hit (my_row, my_column, battleship, 4)
		cruiser_hit := check_boat_hit (my_row, my_column, cruiser, 3)
		submarine_hit := check_boat_hit (my_row, my_column, submarine, 3)
		destroyer_hit := check_boat_hit (my_row, my_column, destroyer, 2)

		carrier_sunk := false
		battleship_sunk := false
		cruiser_sunk := false
		submarine_sunk := false
		destroyer_sunk := false
		
		if carrier_hit = true then
			draw_display_text_bottom (playername (2) + " hit the carrier!")
			carrier_sunk := check_boat_sunk (grid, carrier, 5)
			if carrier_sunk = true then
				draw_display_text_bottom (playername (2) + " sank the carrier!")
			end if

		elsif battleship_hit = true then
			draw_display_text_bottom (playername (2) + " hit the battleship!")
			battleship_sunk := check_boat_sunk (grid, battleship, 4)
			if battleship_sunk = true then
				draw_display_text_bottom (playername (2) + " sank the battleship!")
			end if

		elsif cruiser_hit = true then
			draw_display_text_bottom (playername (2) + " hit the cruiser!")
			cruiser_sunk := check_boat_sunk (grid, cruiser, 3)
			if cruiser_sunk = true then
				draw_display_text_bottom (playername (2) + " sank the cruiser!")
			end if
		elsif submarine_hit = true then
			draw_display_text_bottom (playername (2) + " hit the submarine!")
			submarine_sunk := check_boat_sunk (grid, submarine, 3)
			if submarine_sunk = true then
				draw_display_text_bottom (playername (2) + " sank the submarine!")
			end if

		elsif destroyer_hit = true then
			draw_display_text_bottom (playername (2) + " hit the destroyer!")
			destroyer_sunk := check_boat_sunk (grid, destroyer, 2)
			if destroyer_sunk = true then
				draw_display_text_bottom (playername (2) + " sank the destroyer!")
			end if
		end if

	end if

	var x1 : int := ((my_column - 1) * square_length) + x_min
	var y1 : int := ((my_row - 1) * square_length) + y_min
	var x2 : int := x1 + square_length
	var y2 : int := y1 + square_length

	if carrier_hit = true or battleship_hit = true or cruiser_hit = true or submarine_hit = true or destroyer_hit = true then
		hit_color := 10
		drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, 10)
		if sound_effects_on = true then
			Music.PlayFile ("hit.mp3")
		else
			delay (1000)
		end if
		if carrier_sunk = true or battleship_sunk = true or cruiser_sunk = true or submarine_sunk = true or destroyer_sunk = true then
			if sound_effects_on = true then
				Music.PlayFile ("sunk.mp3")
			end if
		end if
	else
		drawfillbox (x1 + 1, y1 + 1, x2 - 1, y2 - 1, 12)
		if sound_effects_on = true then
			Music.PlayFile ("miss.mp3")
		else
			delay (1000)
		end if
	end if

	% Check boat sunks again, so we can check if it is game over
	carrier_sunk := check_boat_sunk (grid, carrier, 5)
	battleship_sunk := check_boat_sunk (grid, battleship, 4)
	cruiser_sunk := check_boat_sunk (grid, cruiser, 3)
	submarine_sunk := check_boat_sunk (grid, submarine, 3)
	destroyer_sunk := check_boat_sunk (grid, destroyer, 2)

	x_min := x_start
	x_max := x_end
	y_min := y_start
	y_max := y_end

	% Clear line over the player area
	% Bottom horizontal
	drawline (x_min - 5, y_min - 5, x_max, y_min - 5, white)
	% Vertical
	drawline (x_min - 5, y_min - 5, x_min - 5, y_max + 5, white)
	% Top horizontal
	drawline (x_min - 5, y_max + 5, x_max, y_max + 5, white)

	result grid
end bot_attack_boat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 Board

 Definition : Procedure that prints out a board on screen of 10 x 10 squares

 Parameters :
 None

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure Board

	%Number of competitors
	var sides : int := 2
	var x_begin : int := x_start

	var x_bas : int := x_start
	var y_bas : int := y_start
	var x_haut, y_haut : int

	%Background

	x_haut := x_bas + square_length
	y_haut := y_bas + square_length
	drawfillbox (x_start, y_start, x2_end, y_end, 54)

	%%% The 100 square board %%%
	for p : 1 .. sides
		for i : 1 .. columns
			for j : 1 .. rows
				drawbox (x_bas, y_bas, x_haut, y_haut, white)
				x_bas += square_length
				x_haut += square_length
			end for
			x_bas := x_begin
			x_haut := x_begin + square_length
			y_bas += square_length
			y_haut += square_length
		end for

		x_begin := x2_start
		y_bas := y_start
		x_bas := x2_start
		x_haut := x_bas + square_length
		y_haut := y_bas + square_length
	end for

	%Separate the 2 sides.
	drawfillbox (x2_start - 5, y_start - 5, x2_start, y_end + 5, 34)

	% Draw letters on the side of the board
	var letter : array 1 .. 10 of string
	letter (1) := "A"
	letter (2) := "B"
	letter (3) := "C"
	letter (4) := "D"
	letter (5) := "E"
	letter (6) := "F"
	letter (7) := "G"
	letter (8) := "H"
	letter (9) := "I"
	letter (10) := "J"

	var x_start_letter : int := x_start - (square_length div 2)
	var y_start_letter : int := y_end - (square_length div 2)
	intfont := Font.New ("Times New Roman:12")

	for i : 1 .. 10
		Font.Draw (letter (i), x_start_letter, y_start_letter, intfont, black)
		y_start_letter -= square_length
	end for
	x_start_letter := x2_end + (square_length div 2)
	y_start_letter := y_end - (square_length div 2)
	for i : 1 .. 10
		Font.Draw (letter (i), x_start_letter, y_start_letter, intfont, black)
		y_start_letter -= square_length
	end for

	% Draw numbers on the top the board
	var x_start_num : int := x_start + (square_length div 2)
	var y_start_num : int := y_end + (square_length div 2)
	for i : 1 .. 10
		Font.Draw (intstr (i), x_start_num, y_start_num, intfont, black)
		x_start_num += square_length
	end for
	x_start_num := x2_start + (square_length div 2)
	y_start_num := y_end + (square_length div 2)
	for i : 1 .. 10
		Font.Draw (intstr (i), x_start_num, y_start_num, intfont, black)
		x_start_num += square_length
	end for


	% Draw Health bars on both sides of the board
	display_health_bars ()

	% Draw player names on each top corner

end Board

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 Board_Final

 Definition : Procedure that prints out a board on screen of 10 x 10 squares
			  including the spots that were missed and hit with hidden boats

 Parameters :
 None

 Return :
 None
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure Board_Final()
	var sides : int := 2
	var x_begin : int := x_start
	var x_bas : int := x_start
	var y_bas : int := y_start
	var x_haut, y_haut : int
	var grid : array 1 .. 10, 1 .. 10 of int
	var value : int
	var my_color : int
	var my_font : int
	
	Board 
	
	%Background
	x_haut := x_bas + square_length
	y_haut := y_bas + square_length
	
	my_font := Font.New ("Courier New:36")
	%%% The 100 square board %%%
	for p : 1 .. sides
		for i : 1 .. columns
			for j : 1 .. rows
				if (p = 1) then
					grid := p1_grid
				else
					grid := p2_grid
				end if
				value := grid(i,j)
				if value = 0 then
					my_color := 54
				elsif value = 1 then
					my_color := 12
				elsif value = 2 then
					my_color := 15 
				else
					my_color := 10
				end if
				drawfillbox (x_bas+1, y_bas+1, x_haut-1, y_haut-1, my_color)
				if value = 2 then
					Font.Draw ("X", x_bas+5, y_bas+5, my_font, black)
				end if
				x_bas += square_length
				x_haut += square_length
			end for
			x_bas := x_begin
			x_haut := x_begin + square_length
			y_bas += square_length
			y_haut += square_length
		end for

		x_begin := x2_start
		y_bas := y_start
		x_bas := x2_start
		x_haut := x_bas + square_length
		y_haut := y_bas + square_length
	end for

end Board_Final

%%%%%%%%%%%%%%%%%%%%%%%%% The Real Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
View.Set ("graphics:1280;1024")

% Settings menu
intfont := Font.New ("Times New Roman:18")
Font.Draw ("Settings", x_start + (7 * square_length), y_end + (2 * square_length), intfont, red)
Font.Draw ("VS", x_start + (8 * square_length), maxy - 80, intfont, red)

opponent_human_bot (1) := GUI.CreateRadioButton (700, maxy - 80,
	"Robot", 0, opponent_human_bot_pressed)
opponent_human_bot (2) := GUI.CreateRadioButton (700, maxy - 100,
	"Human", opponent_human_bot (1), opponent_human_bot_pressed)

playername (1) := "Mr Pichette"
playername (2) := "Opponent"

p1_name_text_id := GUI.CreateTextField (200, maxy - 140, 300, playername (1), do_nothing_text)
p2_name_text_id := GUI.CreateTextField (700, maxy - 140, 300, playername (2), do_nothing_text)

p1_label := GUI.CreateLabelFull (GUI.GetX (p1_name_text_id) - 2, GUI.GetY (p1_name_text_id),
	"Player 1 name: ", 0, GUI.GetHeight (p1_name_text_id), GUI.RIGHT + GUI.MIDDLE, 0)
p2_label := GUI.CreateLabelFull (GUI.GetX (p2_name_text_id) - 2, GUI.GetY (p2_name_text_id),
	"Player 2 name: ", 0, GUI.GetHeight (p2_name_text_id), GUI.RIGHT + GUI.MIDDLE, 0)

p1_manual_random_choices (1) := GUI.CreateRadioButton (200, maxy - 180,
	"Random", 0, p1_manual_random_pressed)
p1_manual_random_choices (2) := GUI.CreateRadioButton (200, maxy - 200,
	"Manual", p1_manual_random_choices (1), p1_manual_random_pressed)

p2_manual_random_choices (1) := GUI.CreateRadioButton (700, maxy - 180,
	"Random", 0, p2_manual_random_pressed)
p2_manual_random_choices (2) := GUI.CreateRadioButton (700, maxy - 200,
	"Manual", p2_manual_random_choices (1), p2_manual_random_pressed)

p1_random_label := GUI.CreateLabelFull (GUI.GetX (p1_manual_random_choices (1)) - 2, GUI.GetY (p1_manual_random_choices (1)),
	"Your boat placements:", 0, GUI.GetHeight (p1_manual_random_choices (1)), GUI.RIGHT + GUI.MIDDLE, 0)
p2_random_label := GUI.CreateLabelFull (GUI.GetX (p2_manual_random_choices (1)) - 2, GUI.GetY (p2_manual_random_choices (1)),
	"Your boat placements:", 0, GUI.GetHeight (p2_manual_random_choices (1)), GUI.RIGHT + GUI.MIDDLE, 0)

music_box := GUI.CreateCheckBox (500, maxy - 240, "Music", music_box_pressed)
GUI.SetCheckBox (music_box, true)
sound_effects_box := GUI.CreateCheckBox (500, maxy - 260, "Sound Effects", sound_effects_box_pressed)
GUI.SetCheckBox (sound_effects_box, true)

% Hide the player 2 settings
GUI.Hide (p2_name_text_id)
GUI.Hide (p2_label)
GUI.Hide (p2_random_label)
for i : 1 .. 2
	GUI.Hide (p2_manual_random_choices (i))
end for

var play_game_button := GUI.CreateButton (150, maxy - 300, 800, "Play the Game !", play_game)

Help

loop
	exit when GUI.ProcessEvent
end loop

% We have left the settings menu after we hit the Play the game button

if opponent_human = false then
	playername (2) := "Evil Bot"
end if
	
% Start Music if we need to.
if music_on = true then
	fork play_music
end if

cls

Font.Draw ("B a t t l e  S h i p", x_start + (7 * square_length), y_end + (2 * square_length), intfont, red)

Font.Draw (playername (1), 15, y_end + (2 * square_length), intfont, red)
Font.Draw (playername (2), x2_end + 100, y_end + (2 * square_length), intfont, red)

initialize_grid ()

Board

if p1_boat_selection_random = false then
	draw_display_text_bottom ("Click 5 squares for the carrier on the left board")
	p1_carrier := submit_boat_coords (p1_grid, 5, 7, 1)
	p1_grid := add_boat_in_grid (p1_grid, p1_carrier, 5)

	draw_display_text_bottom ("Click 4 squares for the battleship on the left board")
	p1_battleship := submit_boat_coords (p1_grid, 4, 9, 1)
	p1_grid := add_boat_in_grid (p1_grid, p1_battleship, 4)

	draw_display_text_bottom ("Click 3 squares for the cruiser on the left board")
	p1_cruiser := submit_boat_coords (p1_grid, 3, 10, 1)
	p1_grid := add_boat_in_grid (p1_grid, p1_cruiser, 3)

	draw_display_text_bottom ("Click 3 squares for the submarine on the left board")
	p1_submarine := submit_boat_coords (p1_grid, 3, 11, 1)
	p1_grid := add_boat_in_grid (p1_grid, p1_submarine, 3)

	draw_display_text_bottom ("Click 2 squares for the destroyer on the left board")
	p1_destroyer := submit_boat_coords (p1_grid, 2, 13, 1)
	p1_grid := add_boat_in_grid (p1_grid, p1_destroyer, 2)

	Board
else
	p1_carrier := find_random_boat_coords (p1_grid, 5)
	p1_grid := add_boat_in_grid (p1_grid, p1_carrier, 5)

	p1_battleship := find_random_boat_coords (p1_grid, 4)
	p1_grid := add_boat_in_grid (p1_grid, p1_battleship, 4)

	p1_cruiser := find_random_boat_coords (p1_grid, 3)
	p1_grid := add_boat_in_grid (p1_grid, p1_cruiser, 3)

	p1_submarine := find_random_boat_coords (p1_grid, 3)
	p1_grid := add_boat_in_grid (p1_grid, p1_submarine, 3)

	p1_destroyer := find_random_boat_coords (p1_grid, 2)
	p1_grid := add_boat_in_grid (p1_grid, p1_destroyer, 2)
end if

if p2_boat_selection_random = false and opponent_human = true then
	draw_display_text_bottom ("Click 5 squares for the carrier on the right board")
	p2_carrier := submit_boat_coords (p2_grid, 5, 7, 2)
	p2_grid := add_boat_in_grid (p2_grid, p2_carrier, 5)

	draw_display_text_bottom ("Click 4 squares for the battleship on the right board")
	p2_battleship := submit_boat_coords (p2_grid, 4, 9, 2)
	p2_grid := add_boat_in_grid (p2_grid, p2_battleship, 4)

	draw_display_text_bottom ("Click 3 squares for the cruiser on the right board")
	p2_cruiser := submit_boat_coords (p2_grid, 3, 10, 2)
	p2_grid := add_boat_in_grid (p2_grid, p2_cruiser, 3)

	draw_display_text_bottom ("Click 3 squares for the submarine on the right board")
	p2_submarine := submit_boat_coords (p2_grid, 3, 11, 2)
	p2_grid := add_boat_in_grid (p2_grid, p2_submarine, 3)

	draw_display_text_bottom ("Click 2 squares for the destroyer on the right board")
	p2_destroyer := submit_boat_coords (p2_grid, 2, 13, 2)
	p2_grid := add_boat_in_grid (p2_grid, p2_destroyer, 2)

	draw_display_text_bottom ("Since everyone has their boat positions, fire away!")
	Board
else
	p2_carrier := find_random_boat_coords (p2_grid, 5)
	p2_grid := add_boat_in_grid (p2_grid, p2_carrier, 5)

	p2_battleship := find_random_boat_coords (p2_grid, 4)
	p2_grid := add_boat_in_grid (p2_grid, p2_battleship, 4)

	p2_cruiser := find_random_boat_coords (p2_grid, 3)
	p2_grid := add_boat_in_grid (p2_grid, p2_cruiser, 3)

	p2_submarine := find_random_boat_coords (p2_grid, 3)
	p2_grid := add_boat_in_grid (p2_grid, p2_submarine, 3)

	p2_destroyer := find_random_boat_coords (p2_grid, 2)
	p2_grid := add_boat_in_grid (p2_grid, p2_destroyer, 2)
end if

if opponent_human = true then
	% Human vs Human
	loop
		% Player 2 attacks Player 1
		p1_grid := attack_boat (p1_grid, p1_carrier, p1_battleship, p1_cruiser, p1_submarine, p1_destroyer, 1)
		update_boat_hits (1)
		display_health_bars ()

		exit when p1_carrier_sunk = true and p1_battleship_sunk = true and p1_cruiser_sunk = true and p1_submarine_sunk = true and p1_destroyer_sunk = true

		% Player 1 attacks Player 2
		p2_grid := attack_boat (p2_grid, p2_carrier, p2_battleship, p2_cruiser, p2_submarine, p2_destroyer, 2)
		update_boat_hits (2)
		display_health_bars ()

		exit when p2_carrier_sunk = true and p2_battleship_sunk = true and p2_cruiser_sunk = true and p2_submarine_sunk = true and p2_destroyer_sunk = true
	end loop
else
	% Human vs Bot
	loop
		% Player 1 attacks Bot
		p2_grid := attack_boat (p2_grid, p2_carrier, p2_battleship, p2_cruiser, p2_submarine, p2_destroyer, 2)
		update_boat_hits (2)
		display_health_bars ()
		
		exit when p2_carrier_sunk = true and p2_battleship_sunk = true and p2_cruiser_sunk = true and p2_submarine_sunk = true and p2_destroyer_sunk = true

		% Bot attacks Player 1
		p1_grid := bot_attack_boat (p1_grid, p1_carrier, p1_battleship, p1_cruiser, p1_submarine, p1_destroyer)
		update_boat_hits (1)
		display_health_bars ()

		exit when p1_carrier_sunk = true and p1_battleship_sunk = true and p1_cruiser_sunk = true and p1_submarine_sunk = true and p1_destroyer_sunk = true
	end loop
end if

Board_Final

draw_display_text_topest("")
draw_display_text_top("")
draw_display_text_middle("")
draw_display_text_bottom("")

stop_music := true
Music.PlayFileStop()
stop_music := false

fork play_ending_music()

draw_display_text_topest(playername (winner) + " WINS !!!")
draw_display_text_top(" Thank you for playing BattleShip! I hope you enjoyed it")

