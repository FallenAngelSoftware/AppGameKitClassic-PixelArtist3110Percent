// "data.agc"...

function ClearHighScores( )
	mode as integer
	for mode = 0 to 2
		HighScoreName [ mode, 0 ] = "The Fallen Angel"
		HighScoreName [ mode, 1 ] = "John B."
		HighScoreName [ mode, 2 ] = "Denise T."
		HighScoreName [ mode, 3 ] = "Mike Q."
		HighScoreName [ mode, 4 ] = "Carl D."
		HighScoreName [ mode, 5 ] = "Daotheman"
		HighScoreName [ mode, 6 ] = "theweirdn8"
		HighScoreName [ mode, 7 ] = "mattmatteh"
		HighScoreName [ mode, 8 ] = "Oshi Bobo"
		HighScoreName [ mode, 9 ] = "AppGameKit v2"
		
		HighScoreLevel [ mode, 0 ] = 10
		HighScoreLevel [ mode, 1 ] = 9
		HighScoreLevel [ mode, 2 ] = 8
		HighScoreLevel [ mode, 3 ] = 7
		HighScoreLevel [ mode, 4 ] = 6
		HighScoreLevel [ mode, 5 ] = 5
		HighScoreLevel [ mode, 6 ] = 4
		HighScoreLevel [ mode, 7 ] = 3
		HighScoreLevel [ mode, 8 ] = 2
		HighScoreLevel [ mode, 9 ] = 1

		HighScoreScore [ mode, 0 ] = 10000
		HighScoreScore [ mode, 1 ] = 9000
		HighScoreScore [ mode, 2 ] = 8000
		HighScoreScore [ mode, 3 ] = 7000
		HighScoreScore [ mode, 4 ] = 6000
		HighScoreScore [ mode, 5 ] = 5000
		HighScoreScore [ mode, 6 ] = 4000
		HighScoreScore [ mode, 7 ] = 3000
		HighScoreScore [ mode, 8 ] = 2000
		HighScoreScore [ mode, 9 ] = 1000
	next mode
endfunction

//------------------------------------------------------------------------------------------------------------

function CheckPlayerForHighScore ( )
	PlayerRankOnGameOver = 999

	index as integer
	for index = 9 to 0 step -1
		if Score > HighScoreScore[GameMode, index] then PlayerRankOnGameOver = index
	next index

	if PlayerRankOnGameOver < 10
		if PlayerRankOnGameOver < 9
			for index = 9 to (PlayerRankOnGameOver) step -1
				if index > 0
					HighScoreName[GameMode, index] = HighScoreName[GameMode, index-1]
					HighScoreLevel[GameMode, index] = HighScoreLevel[GameMode, index-1]
					HighScoreScore[GameMode, index] = HighScoreScore[GameMode, index-1]
				endif
			next index
		endif

		HighScoreName[GameMode, PlayerRankOnGameOver] = ""
		HighScoreLevel[GameMode, PlayerRankOnGameOver] = Level
		HighScoreScore[GameMode, PlayerRankOnGameOver] = Score
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function LoadOptionsAndHighScores ( )
	if (Platform <> Web)
		index as integer
		if GetFileExists( DataVersion ) = 0
		else
			OpenToRead(1, DataVersion)
				MusicVolume = readInteger( 1 )
				EffectsVolume = readInteger( 1 )
				GameMode = readInteger( 1 )
				SelectedBackground = readInteger( 1 )
				
				for index = 0 to 2
					LevelSkip[index] = ReadInteger( 1 )
				next index

				for index = 0 to 3
					SecretCode[index] = readInteger( 1 )
				next index

				mode as integer
				rank as integer
				for mode = 0 to 2
					for rank = 0 to 9
						HighScoreName [ mode, rank ] = readString( 1 )
						HighScoreLevel [ mode, rank ] = ReadInteger( 1 )
						HighScoreScore [ mode, rank ] = ReadInteger( 1 )
					next rank
				next mode
			CloseFile ( 1 )
		endif
	else
		cookieValue as string
		cookieValue = LoadSharedVariable("MusicVolume"+HTML5DataVersion, "No Value")
		if (cookieValue <> "No Value") then MusicVolume = Val(cookieValue)
		cookieValue = LoadSharedVariable("EffectsVolume"+HTML5DataVersion, "No Value")
		if (cookieValue <> "No Value") then EffectsVolume = Val(cookieValue)
		cookieValue = LoadSharedVariable("GameMode"+HTML5DataVersion, "No Value")
		if (cookieValue <> "No Value") then GameMode = Val(cookieValue)
		cookieValue = LoadSharedVariable("SelectedBackground"+HTML5DataVersion, "No Value")
		if (cookieValue <> "No Value") then SelectedBackground = Val(cookieValue)

		for index = 0 to 2
			cookieValue = LoadSharedVariable( "LevelSkip"+HTML5DataVersion+str(index), "No Value" )
			if (cookieValue <> "No Value") then LevelSkip[index]= Val(cookieValue)
		next index

		for index = 0 to 3
			cookieValue = LoadSharedVariable( "SecretCode"+HTML5DataVersion+str(index), "No Value" )
			if (cookieValue <> "No Value") then SecretCode[index]= Val(cookieValue)
		next index
		
		for mode = 0 to 2
			for rank = 0 to 9
				cookieValue = LoadSharedVariable( "HighscoreName"+HTML5DataVersion+str(mode)+str(rank), "No Value" )
				if (cookieValue <> "No Value") then HighScoreName [ mode, rank ] = cookieValue
				cookieValue = LoadSharedVariable( "HighScoreLevel"+HTML5DataVersion+str(mode)+str(rank), "No Value" )
				if (cookieValue <> "No Value") then HighScoreLevel [ mode, rank ] = Val(cookieValue)
				cookieValue = LoadSharedVariable( "HighScoreScore"+HTML5DataVersion+str(mode)+str(rank), "No Value" )
				if (cookieValue <> "No Value") then HighScoreScore [ mode, rank ] = Val(cookieValue)
			next rank
		next mode
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function SaveOptionsAndHighScores ( )
	if (Platform <> Web)
		index as integer
		OpenToWrite( 1 , DataVersion )
			WriteInteger ( 1, MusicVolume )
			WriteInteger ( 1, EffectsVolume )
			WriteInteger ( 1, GameMode )
			WriteInteger ( 1, SelectedBackground )
				
			for index = 0 to 2
				WriteInteger ( 1, LevelSkip[index] )
			next index
	  
			for index = 0 to 3
				WriteInteger ( 1, SecretCode[index] )
			next index

			mode as integer
			rank as integer
			for mode = 0 to 2
				for rank = 0 to 9
					WriteString ( 1, HighScoreName [ mode, rank ] )
					WriteInteger ( 1, HighScoreLevel [ mode, rank ] )
					WriteInteger ( 1, HighScoreScore [ mode, rank ] )
				next rank
			next mode
		CloseFile ( 1 )
	else
		SaveSharedVariable( "MusicVolume"+HTML5DataVersion, str(MusicVolume) )
		SaveSharedVariable( "EffectsVolume"+HTML5DataVersion, str(EffectsVolume) )
		SaveSharedVariable( "GameMode"+HTML5DataVersion, str(GameMode) )
		SaveSharedVariable( "SelectedBackground"+HTML5DataVersion, str(SelectedBackground) )

		for index = 0 to 2
			SaveSharedVariable( "LevelSkip"+HTML5DataVersion+str(index), str(LevelSkip[index]) )
		next index

		for index = 0 to 3
			SaveSharedVariable( "SecretCode"+HTML5DataVersion+str(index), str(SecretCode[index]) )
		next index
		
		for mode = 0 to 2
			for rank = 0 to 9
				SaveSharedVariable( "HighscoreName"+HTML5DataVersion+str(mode)+str(rank), HighScoreName [ mode, rank ] )
				SaveSharedVariable( "HighScoreLevel"+HTML5DataVersion+str(mode)+str(rank), str(HighScoreLevel [ mode, rank ]) )
				SaveSharedVariable( "HighScoreScore"+HTML5DataVersion+str(mode)+str(rank), str(HighScoreScore [ mode, rank ]) )
			next rank
		next mode
	endif
endfunction
