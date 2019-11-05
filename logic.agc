// "logic.agc"...

function ApplyDifficulty ( )
	if (GameMode = ChildStoryMode)
		AddPolygonTimer = 0.0
		AddPolygonTime = (20+(30*10)) - (30*Level)
		AddPolygonTimeOriginal = AddPolygonTime
	elseif (GameMode = TeenStoryMode)
		AddPolygonTimer = 0.0
		AddPolygonTime = (15*10) - (15*Level)
		AddPolygonTimeOriginal = AddPolygonTime
	elseif (GameMode = AdultStoryMode)
		AddPolygonTimer = 0.0
		AddPolygonTime = (10+(20*10)) - (20*Level)
		AddPolygonTimeOriginal = AddPolygonTime
	endif

	if (GameMode = ChildStoryMode)
		MovePolygonsTimer = 0.0
		MovePolygonsTime = (10+(3*10)) - (3*Level)
		MovePolygonsTimeOriginal = MovePolygonsTime
	elseif (GameMode = TeenStoryMode)
		MovePolygonsTimer = 0.0
		MovePolygonsTime = (1*10) - (1*Level)
		MovePolygonsTimeOriginal = MovePolygonsTime
	elseif (GameMode = AdultStoryMode)
		MovePolygonsTimer = 0.0
		MovePolygonsTime = (5+(2*10)) - (2*Level)
		MovePolygonsTimeOriginal = MovePolygonsTime
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function SetupForNewGame ( )
	ClearPlayfieldBlocked()
	
	GameOver = 0
	
	PlayfieldChangedSoDrawIt = FALSE
	
	PlayerRankOnGameOver = 999

	PlayerLostALife = FALSE

	GameWon = FALSE
	
	PauseGame = FALSE	
	
	QuitPlaying = FALSE
	
	Score = 0
	Bonus = ( 12345 * (1+Level) )
		
	Level = 1
	if (StartingLevel > 1) then Level = StartingLevel

	if (Level < 4)
		PlayNewMusic(1, 1)
	elseif Level = 4
		PlayNewMusic(2, 1)
	elseif Level = 6
		PlayNewMusic(3, 1)
	elseif Level = 7
		PlayNewMusic(4, 1)
	elseif Level = 8
		PlayNewMusic(5, 1)
	elseif Level = 9
		PlayNewMusic(6, 1)
	elseif Level = 10
		PlayNewMusic(9, 1)
		GameWon = TRUE
	endif

	Lives = 2

	color as integer
	for color = 0 to 8
		PlayfieldPixelsNext[color] = 0
		MapPixelsNext[color] = 0
	next color

	PlayfieldMoveNext = 1
	KeyboardMovementTimer = 0.0

	ApplyDifficulty()

	indexY as integer
	indexX as integer
	for indexY = 0 to 6
		for indexX = 0 to 6
			if Level = 1
				Playfield[ indexX, indexY] = MapLevelOne[ indexX, indexY ]
				PlayfieldMap[ indexX, indexY] = MapLevelOne[ indexX, indexY ]
			elseif Level = 2
				Playfield[ indexX, indexY] = MapLevelTwo[ indexX, indexY ]
				PlayfieldMap[ indexX, indexY] = MapLevelTwo[ indexX, indexY ]
			elseif Level = 3
				Playfield[ indexX, indexY] = MapLevelThree[ indexX, indexY ]
				PlayfieldMap[ indexX, indexY] = MapLevelThree[ indexX, indexY ]
			elseif Level = 4
				Playfield[ indexX, indexY] = MapLevelFour[ indexX, indexY ]
				PlayfieldMap[ indexX, indexY] = MapLevelFour[ indexX, indexY ]
			elseif Level = 5
				Playfield[ indexX, indexY] = MapLevelFive[ indexX, indexY ]
				PlayfieldMap[ indexX, indexY] = MapLevelFive[ indexX, indexY ]
			elseif Level = 6
				Playfield[ indexX, indexY] = MapLevelSix[ indexX, indexY ]
				PlayfieldMap[ indexX, indexY] = MapLevelSix[ indexX, indexY ]
			elseif Level = 7
				Playfield[ indexX, indexY] = MapLevelSeven[ indexX, indexY ]
				PlayfieldMap[ indexX, indexY] = MapLevelSeven[ indexX, indexY ]
			elseif Level = 8
				Playfield[ indexX, indexY] = MapLevelEight[ indexX, indexY ]
				PlayfieldMap[ indexX, indexY] = MapLevelEight[ indexX, indexY ]
			elseif Level = 9
				Playfield[ indexX, indexY] = MapLevelNine[ indexX, indexY ]
				PlayfieldMap[ indexX, indexY] = MapLevelNine[ indexX, indexY ]
			endif
		next indexX
	next indexY

	originalX as integer
	originalY as integer
	originalColor as integer
	newX as integer
	newY as integer
	shuffle as integer
	for shuffle = 0 to 100
		originalX = Random( 0, 6 )
		originalY = Random( 0, 6 )
		newX = Random( 0, 6 )
		newY = Random( 0, 6 )

		originalColor = Playfield[newX, newY]
		Playfield[ newX, newY] = Playfield[ originalX, originalY]
		Playfield[ originalX, originalY] = originalColor
	next shuffle

	emptyX as integer
	emptyY as integer
	for indexY = 0 to 6
		for indexX = 0 to 6
			if Playfield[ indexX, indexY] = 0
				emptyX = indexX
				emptyY = indexY
			endif
		next indexX
	next indexY
	
	originalColor = Playfield[3, 3]
	Playfield[ 3, 3 ] = 0
	Playfield[emptyX, emptyY] = originalColor

	index as integer
	for index = 0 to 24
		PolygonActive[index] = FALSE
		PolygonPlayfieldX[index] = -9999
		PolygonPlayfieldY[index] = -9999
		PolygonScreenX[index] = -9999
		PolygonScreenY[index] = -9999
		PolygonDirection[index] = JoyCENTER
		PolygonStep[index] = 0
		PolygonScale[index] = 1
		PolygonScaleDirection[index] = -1
		PolygonTransparency[index] = 0
	next index
	
	PositionToMoveToX = -1
	PositionToMoveToY = -1
endfunction

//------------------------------------------------------------------------------------------------------------

function SetupForNewLevel ( )
	if (Level < 10)
		if (LevelSkip[GameMode] < Level)
			LevelSkip[GameMode] = Level
		endif
	endif

	if (QuitPlaying = FALSE)
		if Level = 4
			PlayNewMusic(2, 1)
		elseif Level = 6
			PlayNewMusic(3, 1)
		elseif Level = 7
			PlayNewMusic(4, 1)
		elseif Level = 8
			PlayNewMusic(5, 1)
		elseif Level = 9
			PlayNewMusic(6, 1)
		elseif Level = 10
			PlayNewMusic(9, 1)
			GameWon = TRUE
		endif
	endif

	ClearPlayfieldBlocked()
	
	PauseGame = FALSE
	
	PlayfieldChangedSoDrawIt = FALSE

	if PlayerLostALife = FALSE
		Bonus = ( 10000* (1+Level) )
	endif

	color as integer
	for color = 0 to 8
		PlayfieldPixelsNext[color] = 0
		MapPixelsNext[color] = 0
	next color

	PlayfieldMoveNext = 1
	KeyboardMovementTimer = 0.0

	ApplyDifficulty()

	if PlayerLostALife = FALSE
		indexY as integer
		indexX as integer
		for indexY = 0 to 6
			for indexX = 0 to 6
				if Level = 1
					Playfield[ indexX, indexY] = MapLevelOne[ indexX, indexY ]
					PlayfieldMap[ indexX, indexY] = MapLevelOne[ indexX, indexY ]
				elseif Level = 2
					Playfield[ indexX, indexY] = MapLevelTwo[ indexX, indexY ]
					PlayfieldMap[ indexX, indexY] = MapLevelTwo[ indexX, indexY ]
				elseif Level = 3
					Playfield[ indexX, indexY] = MapLevelThree[ indexX, indexY ]
					PlayfieldMap[ indexX, indexY] = MapLevelThree[ indexX, indexY ]
				elseif Level = 4
					Playfield[ indexX, indexY] = MapLevelFour[ indexX, indexY ]
					PlayfieldMap[ indexX, indexY] = MapLevelFour[ indexX, indexY ]
				elseif Level = 5
					Playfield[ indexX, indexY] = MapLevelFive[ indexX, indexY ]
					PlayfieldMap[ indexX, indexY] = MapLevelFive[ indexX, indexY ]
				elseif Level = 6
					Playfield[ indexX, indexY] = MapLevelSix[ indexX, indexY ]
					PlayfieldMap[ indexX, indexY] = MapLevelSix[ indexX, indexY ]
				elseif Level = 7
					Playfield[ indexX, indexY] = MapLevelSeven[ indexX, indexY ]
					PlayfieldMap[ indexX, indexY] = MapLevelSeven[ indexX, indexY ]
				elseif Level = 8
					Playfield[ indexX, indexY] = MapLevelEight[ indexX, indexY ]
					PlayfieldMap[ indexX, indexY] = MapLevelEight[ indexX, indexY ]
				elseif Level = 9
					Playfield[ indexX, indexY] = MapLevelNine[ indexX, indexY ]
					PlayfieldMap[ indexX, indexY] = MapLevelNine[ indexX, indexY ]
				endif
			next indexX
		next indexY
	endif

	if PlayerLostALife = FALSE
		originalX as integer
		originalY as integer
		originalColor as integer
		newX as integer
		newY as integer
		shuffle as integer
		for shuffle = 0 to 100
			originalX = Random( 0, 6 )
			originalY = Random( 0, 6 )
			newX = Random( 0, 6 )
			newY = Random( 0, 6 )

			originalColor = Playfield[newX, newY]
			Playfield[ newX, newY] = Playfield[ originalX, originalY]
			Playfield[ originalX, originalY] = originalColor
		next shuffle
	endif

	emptyX as integer
	emptyY as integer
	for indexY = 0 to 6
		for indexX = 0 to 6
			if Playfield[ indexX, indexY] = 0
				emptyX = indexX
				emptyY = indexY
			endif
		next indexX
	next indexY
	
	originalColor = Playfield[3, 3]
	Playfield[ 3, 3 ] = 0
	Playfield[emptyX, emptyY] = originalColor

	index as integer
	for index = 0 to 12
		PolygonActive[index] = FALSE
		PolygonPlayfieldX[index] = -9999
		PolygonPlayfieldY[index] = -9999
		PolygonScreenX[index] = -9999
		PolygonScreenY[index] = -9999
		PolygonDirection[index] = JoyCENTER
		PolygonStep[index] = 0
		PolygonScale[index] = 1
		PolygonScaleDirection[index] = -1
		PolygonTransparency[index] = 0
	next index
	
	if (QuitPlaying = FALSE)
		NextScreenToDisplay = CutSceneScreen
		ScreenFadeStatus = FadingToBlack
	endif
	
	PositionToMoveToX = -1
	PositionToMoveToY = -1
endfunction

//------------------------------------------------------------------------------------------------------------

function CheckForLevelClear ( )
	levelIsCleared as integer
	levelIsCleared = TRUE

	indexY as integer
	indexX as integer
	for indexY = 0 to 6
		for indexX = 0 to 6
			if PlayfieldMap[ indexX, indexY] <> Playfield[ indexX, indexY]
				levelIsCleared = FALSE
				exitfunction
  			endif
		next indexX
	next indexY

	if levelIsCleared = TRUE
		inc Score, Bonus
		inc Score, ( (Level+1) * 200000 )
		inc Level, 1
		
		if Level = 4
			PlayNewMusic(2, 1)
		elseif Level = 6
			PlayNewMusic(3, 1)
		elseif Level = 7
			PlayNewMusic(4, 1)
		elseif Level = 8
			PlayNewMusic(5, 1)
		elseif Level = 9
			PlayNewMusic(6, 1)
		elseif Level = 10
			PlayNewMusic(7, 1)
			if SecretCodeCombined = 2777
				GameWon = FALSE
			else
				GameWon = TRUE
			endif
		endif
		
		NextScreenToDisplay = PlayingScreen
		ScreenFadeStatus = FadingToBlack
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function CheckForLossOfLife ( )
	PlayerLostALife = FALSE
	index as integer
	for index = 0 to 12
		if PolygonActive[index] = TRUE and PolygonScaleDirection[index] = 2
			if PolygonStep[index] = 0 and PolygonPlayfieldX[index] = PlayerPosX and PolygonPlayfieldY[index] = PlayerPosY then PlayerLostALife = TRUE
   		endif
	next index
	
	if SecretCodeCombined = 2777
		PlayerLostALife = FALSE
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function ClearPlayfieldBlocked( )
	pfY as integer
	pfX as integer
	for pfY = 0 to 6
		for pfX = 0 to 6
			PlayfieldBlocked[ pfX, pfY ] = -1
		next pfX
	next pfY
endfunction

//------------------------------------------------------------------------------------------------------------

function CheckPlayfieldBlocked( direction as integer, index as integer, posX as integer, posY as integer )
	returnValue as integer
	returnValue = FALSE

	if direction = JoyUP
		if (posX > 0)
			if (PlayfieldBlocked[ posX-1, posY ] > -1)
				if (PlayfieldBlocked[ posX-1, posY ] <> index)
					returnValue = TRUE
				endif
			endif
		endif
	elseif direction = JoyDOWN
		if (posX < 6)
			if (PlayfieldBlocked[ posX+1, posY ] > -1)
				if (PlayfieldBlocked[ posX+1, posY ] <> index)
					returnValue = TRUE
				endif
			endif
		endif
	elseif direction = JoyLEFT
		if (posY > 0)
			if (PlayfieldBlocked[ posX, posY-1 ] > -1)
				if (PlayfieldBlocked[ posX, posY-1 ] <> index)
					returnValue = TRUE
				endif
			endif
		endif
	elseif direction = JoyRIGHT
		if (posY < 6)
			if (PlayfieldBlocked[ posX, posY+1 ] > -1)
				if (PlayfieldBlocked[ posX, posY+1 ] <> index)
					returnValue = TRUE
				endif
			endif
		endif
	endif
endfunction	returnValue

//------------------------------------------------------------------------------------------------------------

function RunGamePlayCore( )
	PlayerPosX = 3
	PlayerPosY = 3
	indexY as integer
	indexX as integer
	for indexY = 0 to 6
		for indexX = 0 to 6
			if Playfield[ indexX, indexY] = 0
				PlayerPosX = indexX
				PlayerPosY = indexY
			endif
		next indexX
	next indexY

	if GameOver = 0
		if Bonus > 0
			dec Bonus, 1
		else
			Bonus = 0
		endif

		colorToMove as integer

		if (KeyboardMovementTimer <= 0)
			select JoystickDirection
				case JoyLEFT:
					if PlayerPosY > 0
						colorToMove = Playfield[PlayerPosX, PlayerPosY-1]
						Playfield[PlayerPosX, PlayerPosY-1] = 0
						Playfield[PlayerPosX, PlayerPosY] = colorToMove
						
						KeyboardMovementTimer = 3
						KeyboardMovementTimer = KeyboardMovementTimer * (roundedFPS / 30)
						
						PlayfieldChangedSoDrawIt = TRUE
						PlaySound(SoundEffect[3])
					endif
				endcase
				case JoyRIGHT:
					if PlayerPosY < 6
						colorToMove = Playfield[PlayerPosX, PlayerPosY+1]
						Playfield[PlayerPosX, PlayerPosY+1] = 0
						Playfield[PlayerPosX, PlayerPosY] = colorToMove
						
						KeyboardMovementTimer = 3
						KeyboardMovementTimer = KeyboardMovementTimer * (roundedFPS / 30)
						
						PlayfieldChangedSoDrawIt = TRUE
						PlaySound(SoundEffect[3])
					endif
				endcase
				case JoyUP:
					if PlayerPosX > 0
						colorToMove = Playfield[PlayerPosX-1, PlayerPosY]
						Playfield[PlayerPosX-1, PlayerPosY] = 0
						Playfield[PlayerPosX, PlayerPosY] = colorToMove
						
						KeyboardMovementTimer = 3
						KeyboardMovementTimer = KeyboardMovementTimer * (roundedFPS / 30)
						
						PlayfieldChangedSoDrawIt = TRUE
						PlaySound(SoundEffect[3])
					endif
				endcase
				case JoyDOWN:
					if PlayerPosX < 6
						colorToMove = Playfield[PlayerPosX+1, PlayerPosY]
						Playfield[PlayerPosX+1, PlayerPosY] = 0
						Playfield[PlayerPosX, PlayerPosY] = colorToMove
						
						KeyboardMovementTimer = 3
						KeyboardMovementTimer = KeyboardMovementTimer * (roundedFPS / 30)
						
						PlayfieldChangedSoDrawIt = TRUE
						PlaySound(SoundEffect[3])
					endif
				endcase
			endselect
		endif

		if (KeyboardMovementTimer >= 0) then dec KeyboardMovementTimer, 1

		if MouseButtonLeft = ON
			if (PositionToMoveToX = -1 and PositionToMoveToY = -1)
				pixelWidthHalf as integer
				pixelWidthHalf = 25
				pixelHeightHalf as integer
				pixelHeightHalf = 25
				
				screenY as integer
				screenY = 300
				screenX as integer
				screenX = 30
				for indexY = 0 to 6
					for indexX = 0 to 6
						if indexY > -1 and indexY = (PlayerPosY-1) and indexX = playerPosX
							if (  ( MouseScreenY > (screenY-(pixelHeightHalf)) ) and ( MouseScreenY < (screenY+(pixelHeightHalf)) ) and ( MouseScreenX > (screenX-(pixelWidthHalf)) ) and ( MouseScreenX < (screenX+(pixelWidthHalf)) )  )
								colorToMove = Playfield[PlayerPosX, PlayerPosY-1]
								Playfield[PlayerPosX, PlayerPosY-1] = 0
								Playfield[PlayerPosX, PlayerPosY] = colorToMove
								PlayfieldChangedSoDrawIt = TRUE
								PlaySound(SoundEffect[3])
							endif
						elseif indexY < 7 and indexY = (PlayerPosY+1) and indexX = playerPosX
							if (  ( MouseScreenY > (screenY-(pixelHeightHalf)) ) and ( MouseScreenY < (screenY+(pixelHeightHalf)) ) and ( MouseScreenX > (screenX-(pixelWidthHalf)) ) and ( MouseScreenX < (screenX+(pixelWidthHalf)) )  )
								colorToMove = Playfield[PlayerPosX, PlayerPosY+1]
								Playfield[PlayerPosX, PlayerPosY+1] = 0
								Playfield[PlayerPosX, PlayerPosY] = colorToMove
								PlayfieldChangedSoDrawIt = TRUE
								PlaySound(SoundEffect[3])
							endif
						elseif indexX > -1 and indexX = (PlayerPosX-1) and indexY = playerPosY
							if (  ( MouseScreenY > (screenY-(pixelHeightHalf)) ) and ( MouseScreenY < (screenY+(pixelHeightHalf)) ) and ( MouseScreenX > (screenX-(pixelWidthHalf)) ) and ( MouseScreenX < (screenX+(pixelWidthHalf)) )  )
								colorToMove = Playfield[PlayerPosX-1, PlayerPosY]
								Playfield[PlayerPosX-1, PlayerPosY] = 0
								Playfield[PlayerPosX, PlayerPosY] = colorToMove
								PlayfieldChangedSoDrawIt = TRUE
								PlaySound(SoundEffect[3])
							endif
						elseif indexX < 7 and indexX = (PlayerPosX+1) and indexY = playerPosY
							if (  ( MouseScreenY > (screenY-(pixelHeightHalf)) ) and ( MouseScreenY < (screenY+(pixelHeightHalf)) ) and ( MouseScreenX > (screenX-(pixelWidthHalf)) ) and ( MouseScreenX < (screenX+(pixelWidthHalf)) )  )
								colorToMove = Playfield[PlayerPosX+1, PlayerPosY]
								Playfield[PlayerPosX+1, PlayerPosY] = 0
								Playfield[PlayerPosX, PlayerPosY] = colorToMove
								PlayfieldChangedSoDrawIt = TRUE
								PlaySound(SoundEffect[3])
							endif
						endif

						if (indexX = PlayerPosX or indexY = PlayerPosY)
							if (  ( MouseScreenY > (screenY-(pixelHeightHalf)) ) and ( MouseScreenY < (screenY+(pixelHeightHalf)) ) and ( MouseScreenX > (screenX-(pixelWidthHalf)) ) and ( MouseScreenX < (screenX+(pixelWidthHalf)) )  )
								PositionToMoveToX = indexX
								PositionToMoveToY = indexY
							endif
						endif

						inc screenY, 50
					next indexX
					
					inc screenX, 50
					screenY = 300
				next indexY
			else
				if (PositionToMoveToX < PlayerPosX)
					colorToMove = Playfield[PlayerPosX-1, PlayerPosY]
					Playfield[PlayerPosX-1, PlayerPosY] = 0
					Playfield[PlayerPosX, PlayerPosY] = colorToMove
					PlayfieldChangedSoDrawIt = TRUE
					PlaySound(SoundEffect[3])
				elseif (PositionToMoveToX > PlayerPosX)
					colorToMove = Playfield[PlayerPosX+1, PlayerPosY]
					Playfield[PlayerPosX+1, PlayerPosY] = 0
					Playfield[PlayerPosX, PlayerPosY] = colorToMove
					PlayfieldChangedSoDrawIt = TRUE
					PlaySound(SoundEffect[3])
				elseif (PositionToMoveToY < PlayerPosY)
					colorToMove = Playfield[PlayerPosX, PlayerPosY-1]
					Playfield[PlayerPosX, PlayerPosY-1] = 0
					Playfield[PlayerPosX, PlayerPosY] = colorToMove
					PlayfieldChangedSoDrawIt = TRUE
					PlaySound(SoundEffect[3])
				elseif (PositionToMoveToY > PlayerPosY)
					colorToMove = Playfield[PlayerPosX, PlayerPosY+1]
					Playfield[PlayerPosX, PlayerPosY+1] = 0
					Playfield[PlayerPosX, PlayerPosY] = colorToMove
					PlayfieldChangedSoDrawIt = TRUE
					PlaySound(SoundEffect[3])
				else
					PositionToMoveToX = -1
					PositionToMoveToY = -1
				endif	
			endif
		endif
	else		
		if GameOver > 1
			dec GameOver, 1
		else
			ScreenFadeStatus = FadingToBlack
		endif
	endif

	if AddPolygonTimer < AddPolygonTime
		inc AddPolygonTimer, 1
	else
		AddPolygonTimer = 0

		AddPolygonTime = AddPolygonTimeOriginal * (roundedFPS / 30)

		polygonAvailable as integer
		polygonAvailable = -1
		
		index as integer
		for index = 0 to 12
			if PolygonActive[index] = FALSE
				polygonAvailable = index
			endif
		next index

		if polygonAvailable > -1
			direction as integer
			direction = Random( 1, 4 ) 
			topX as integer
			bottomX as integer
			leftY as integer
			rightY as integer

			tries as integer
			tries = 10

			if direction = JoyUP
				topX = Random( 0, 6 )
				isAvailable as integer
				isAvailable = FALSE
				while isAvailable = FALSE and tries > 0
					isAvailable = TRUE

					if tries > 0 then dec tries, 1
					topX = Random( 0, 6 )
					
					for index = 0 to 12
						if PolygonPlayfieldX[index] = 0 and PolygonPlayfieldY[index] = topX
							isAvailable = FALSE
						endif
					next index
				endwhile

				if isAvailable = TRUE
					PolygonActive[polygonAvailable] = TRUE
					PolygonPlayfieldX[polygonAvailable] = 0
					PolygonPlayfieldY[polygonAvailable] = topX
					PolygonScreenX[polygonAvailable] = -9999
					PolygonScreenY[polygonAvailable] = -9999
					PolygonDirection[polygonAvailable] = JoyDOWN
					PolygonStep[polygonAvailable] = 0
					PolygonScale[polygonAvailable] = 3
					PolygonScaleDirection[polygonAvailable] = 0
					PolygonTransparency[polygonAvailable] = 0
					PlaySound(3)
				endif
			elseif direction = JoyDOWN
				bottomX = Random( 0, 6 )
				isAvailable = FALSE
				while isAvailable = FALSE and tries > 0
					isAvailable = TRUE

					if tries > 0 then dec tries, 1
					bottomX = Random( 0, 6 )
					
					for index = 0 to 12
						if PolygonPlayfieldX[index] = 6 and PolygonPlayfieldY[index] = bottomX
							isAvailable = FALSE
						endif
					next index
				endwhile

				if isAvailable = TRUE
					PolygonActive[polygonAvailable] = TRUE
					PolygonPlayfieldX[polygonAvailable] = 6
					PolygonPlayfieldY[polygonAvailable] = bottomX
					PolygonScreenX[polygonAvailable] = -9999
					PolygonScreenY[polygonAvailable] = -9999
					PolygonDirection[polygonAvailable] = JoyUP
					PolygonStep[polygonAvailable] = 0
					PolygonScale[polygonAvailable] = 3
					PolygonScaleDirection[polygonAvailable] = 0
					PolygonTransparency[polygonAvailable] = 0
					PlaySound(3)
				endif
			elseif direction = JoyLEFT
				leftY = Random( 0, 6 )
				isAvailable = FALSE
				while isAvailable = FALSE and tries > 0
					isAvailable = TRUE

					if tries > 0 then dec tries, 1
					leftY = Random( 0, 6 )
					
					for index = 0 to 12
						if PolygonPlayfieldX[index] = leftY and PolygonPlayfieldY[index] = 0
							isAvailable = FALSE
						endif
					next index
				endwhile

				if isAvailable = TRUE
					PolygonActive[polygonAvailable] = TRUE
					PolygonPlayfieldX[polygonAvailable] = leftY
					PolygonPlayfieldY[polygonAvailable] = 0
					PolygonScreenX[polygonAvailable] = -9999
					PolygonScreenY[polygonAvailable] = -9999
					PolygonDirection[polygonAvailable] = JoyRIGHT
					PolygonStep[polygonAvailable] = 0
					PolygonScale[polygonAvailable] = 3
					PolygonScaleDirection[polygonAvailable] = 0
					PolygonTransparency[polygonAvailable] = 0
					PlaySound(3)
				endif
			elseif direction = JoyRIGHT
				rightY = Random( 0, 6 )
				isAvailable = FALSE
				while isAvailable = FALSE and tries > 0
					isAvailable = TRUE

					if tries > 0 then dec tries, 1
					rightY = Random( 0, 6 )
					
					for index = 0 to 12
						if PolygonPlayfieldX[index] = rightY and PolygonPlayfieldY[index] = 6
							isAvailable = FALSE
						endif
					next index
				endwhile

				if isAvailable = TRUE
					PolygonActive[polygonAvailable] = TRUE
					PolygonPlayfieldX[polygonAvailable] = rightY
					PolygonPlayfieldY[polygonAvailable] = 6
					PolygonScreenX[polygonAvailable] = -9999
					PolygonScreenY[polygonAvailable] = -9999
					PolygonDirection[polygonAvailable] = JoyLEFT
					PolygonStep[polygonAvailable] = 0
					PolygonScale[polygonAvailable] = 3
					PolygonScaleDirection[polygonAvailable] = 0
					PolygonTransparency[polygonAvailable] = 0
					PlaySound(3)
				endif
			endif
		endif
	endif

	for index = 0 to 12
		if PolygonActive[index] = TRUE and PolygonScaleDirection[index] = 0
			if PolygonScale[index] > 1
				isAvailable = TRUE
				
				if (PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] > -1) then isAvailable = FALSE

				if isAvailable = TRUE
					if PolygonTransparency[index] < 251
						transparencyFactor as integer
						transparencyFactor = 5 * (30 / roundedFPS)
						inc PolygonTransparency[index], transparencyFactor
					else
						PolygonTransparency[index] = 255
					endif
					
					scaleFactor as float
					scaleFactor = .05 * (30 / roundedFPS)
					dec PolygonScale[index], scaleFactor
				endif

				SetSpriteDepth ( PolygonSpriteVertical[index, 0], 1 )
				SetSpriteDepth ( PolygonSpriteHorizontal[index, 0], 1 )
			else
				PolygonTransparency[index] = 255
				
				allPolygonsCentered as integer
				allPolygonsCentered = TRUE
				
				checkPolygonCentered as integer
				for checkPolygonCentered = 0 to 12
					if PolygonStep[checkPolygonCentered] <> 0 then allPolygonsCentered = FALSE
				next checkPolygonCentered
				
				if allPolygonsCentered = TRUE
					PolygonScaleDirection[index] = 2
					PolygonScale[index] = 1
					SetSpriteDepth ( PolygonSpriteVertical[index, 0], 1 )
					SetSpriteDepth ( PolygonSpriteHorizontal[index, 0], 1 )
					
					PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = index
				endif
			endif
		endif
	next index

	if MovePolygonsTimer < MovePolygonsTime
		inc MovePolygonsTimer, 1
	else
		MovePolygonsTimer = 0

		MovePolygonsTime = MovePolygonsTimeOriginal * (roundedFPS / 30)

	endif

	if MovePolygonsTimer = 0
		for index = 0 to 12
			if PolygonActive[index] = TRUE and PolygonScaleDirection[index] = 2
				if PolygonStep[index] = 0
					if PolygonDirection[index] = JoyUP
						if CheckPlayfieldBlocked( JoyUP, index, PolygonPlayfieldX[index], PolygonPlayfieldY[index] ) = TRUE
							PlaySoundEffect(0)
							if PolygonPlayfieldX[index] > 0 and PolygonPlayfieldX[index] < 6
								PolygonDirection[index] = JoyDOWN
								PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = index
								PlayfieldBlocked[ PolygonPlayfieldX[index]+1, PolygonPlayfieldY[index] ] = index
								if ( CheckPlayfieldBlocked( JoyDOWN, index, PolygonPlayfieldX[index], PolygonPlayfieldY[index] ) = FALSE  )
									inc PolygonStep[index], 1
								endif
							else
								PolygonScaleDirection[index] = 1
							endif
						else
							inc PolygonStep[index], 1
							if PolygonPlayfieldX[index] < 0 then PlayfieldBlocked[ PolygonPlayfieldX[index]-1, PolygonPlayfieldY[index] ] = index
						endif
					elseif PolygonDirection[index] = JoyDOWN
						if CheckPlayfieldBlocked( JoyDOWN, index, PolygonPlayfieldX[index], PolygonPlayfieldY[index] ) = TRUE
							PlaySoundEffect(0)
							if PolygonPlayfieldX[index] < 6 and PolygonPlayfieldX[index] > 0
								PolygonDirection[index] = JoyUP
								PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = index
								PlayfieldBlocked[ PolygonPlayfieldX[index]-1, PolygonPlayfieldY[index] ] = index
								if ( CheckPlayfieldBlocked( JoyUP, index, PolygonPlayfieldX[index], PolygonPlayfieldY[index] ) = FALSE  )
									inc PolygonStep[index], 1
								endif
							else
								PolygonScaleDirection[index] = 1
							endif
						else
							inc PolygonStep[index], 1
							if PolygonPlayfieldX[index] < 6 then PlayfieldBlocked[ PolygonPlayfieldX[index]+1, PolygonPlayfieldY[index] ] = index
						endif
					elseif PolygonDirection[index] = JoyLEFT
						if CheckPlayfieldBlocked( JoyLEFT, index, PolygonPlayfieldX[index], PolygonPlayfieldY[index] ) = TRUE
							PlaySoundEffect(0)
							if PolygonPlayfieldY[index] > 0 and PolygonPlayfieldY[index] < 6
								PolygonDirection[index] = JoyRIGHT
								PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = index
								PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]+1 ] = index
								if ( CheckPlayfieldBlocked( JoyRIGHT, index, PolygonPlayfieldX[index], PolygonPlayfieldY[index] ) = FALSE  )
									inc PolygonStep[index], 1
								endif
							else
								PolygonScaleDirection[index] = 1
							endif
						else
							inc PolygonStep[index], 1
							if PolygonPlayfieldY[index] > 0 then PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]-1 ] = index
						endif
					elseif PolygonDirection[index] = JoyRIGHT
						if CheckPlayfieldBlocked( JoyRIGHT, index, PolygonPlayfieldX[index], PolygonPlayfieldY[index] ) = TRUE
							PlaySoundEffect(0)
							if PolygonPlayfieldY[index] < 6 and PolygonPlayfieldY[index] > 0
								PolygonDirection[index] = JoyLEFT
								PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = index
								PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]-1 ] = index
								if ( CheckPlayfieldBlocked( JoyLEFT, index, PolygonPlayfieldX[index], PolygonPlayfieldY[index] ) = FALSE  )
									inc PolygonStep[index], 1
								endif
							else
								PolygonScaleDirection[index] = 1
							endif
						else
							inc PolygonStep[index], 1
							if PolygonPlayfieldY[index] < 6 then PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]+1 ] = index
						endif
					endif
				elseif PolygonStep[index] < 4
					inc PolygonStep[index], 1
				elseif (PolygonStep[index] = 4)
					PolygonStep[index] = 0
					if PolygonDirection[index] = JoyUP
						if PolygonPlayfieldX[index] > 1
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
							dec PolygonPlayfieldX[index], 1
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = index
							if PolygonPlayfieldX[index] > 0
								if PlayfieldBlocked[ PolygonPlayfieldX[index]-1, PolygonPlayfieldY[index] ] = -1
									PlayfieldBlocked[ PolygonPlayfieldX[index]-1, PolygonPlayfieldY[index] ] = index
								endif
								if (PolygonPlayfieldX[index] < 6)
									PlayfieldBlocked[ PolygonPlayfieldX[index]+1, PolygonPlayfieldY[index] ] = -1
								endif
							endif
														
							if PolygonPlayfieldX[index] < 6
								PlayfieldBlocked[ PolygonPlayfieldX[index]+1, PolygonPlayfieldY[index] ] = -1
							endif
						else
							PolygonScaleDirection[index] = 1
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
							dec PolygonPlayfieldX[index], 1
						endif
					elseif PolygonDirection[index] = JoyDOWN
						if PolygonPlayfieldX[index] < 5
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
							inc PolygonPlayfieldX[index], 1
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = index
							if PolygonPlayfieldX[index] < 6
								if PlayfieldBlocked[ PolygonPlayfieldX[index]+1, PolygonPlayfieldY[index] ] = -1
									PlayfieldBlocked[ PolygonPlayfieldX[index]+1, PolygonPlayfieldY[index] ] = index
								endif
								if (PolygonPlayfieldX[index] > 0)
									PlayfieldBlocked[ PolygonPlayfieldX[index]-1, PolygonPlayfieldY[index] ] = -1
								endif
							endif
							
							if PolygonPlayfieldX[index] > 0
								PlayfieldBlocked[ PolygonPlayfieldX[index]-1, PolygonPlayfieldY[index] ] = -1
							endif
						else
							PolygonScaleDirection[index] = 1
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
							inc PolygonPlayfieldX[index], 1
						endif
					elseif PolygonDirection[index] = JoyLEFT
						if PolygonPlayfieldY[index] > 1
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
							dec PolygonPlayfieldY[index], 1
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = index
							if PolygonPlayfieldY[index] > 0
								if PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]-1 ] = -1
									PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]-1 ] = index
								endif
								if (PolygonPlayfieldY[index] < 6)
									PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]+1 ] = -1
								endif
							endif
							
							if PolygonPlayfieldY[index] < 6
								PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]+1 ] = -1
							endif
						else
							PolygonScaleDirection[index] = 1
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
							dec PolygonPlayfieldY[index], 1
						endif
					elseif PolygonDirection[index] = JoyRIGHT
						if PolygonPlayfieldY[index] < 5
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
							inc PolygonPlayfieldY[index], 1
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = index
							if PolygonPlayfieldY[index] < 6
								if PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]+1 ] = -1
									PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]+1 ] = index
								endif
								if (PolygonPlayfieldY[index] > 0)
									PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]-1 ] = -1
								endif
							endif
							
							if PolygonPlayfieldY[index] > 0
								PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index]-1 ] = -1
							endif
						else
							PolygonScaleDirection[index] = 1
							PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
							inc PolygonPlayfieldY[index], 1
						endif
					endif
				endif				
			endif

			if (PolygonStep[index] = 3)
				if PolygonDirection[index] = JoyUP
					if (PolygonPlayfieldX[index] < 6)
						PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
					endif
				elseif PolygonDirection[index] = JoyDOWN
					if (PolygonPlayfieldX[index] > 0)
						PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
					endif
				elseif PolygonDirection[index] = JoyLEFT
					if (PolygonPlayfieldY[index] < 6)
						PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
					endif
				elseif PolygonDirection[index] = JoyRIGHT
					if (PolygonPlayfieldY[index] > 0)
						PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
					endif
				endif
			endif
		next index
	endif

	for index = 0 to 12
		if PolygonActive[index] = TRUE and PolygonScaleDirection[index] = 1
			if PolygonScale[index] < 3
				if PolygonTransparency[index] > 4
					transparencyFactor = 5 * (30 / roundedFPS)
					dec PolygonTransparency[index], transparencyFactor
				else
					PolygonTransparency[index] = 0
				endif
			
				scaleFactor = .05 * (30 / roundedFPS)
				inc PolygonScale[index], scaleFactor
			else
				PlayfieldBlocked[ PolygonPlayfieldX[index], PolygonPlayfieldY[index] ] = -1
				PolygonActive[index] = FALSE
				PolygonPlayfieldX[index] = -9999
				PolygonPlayfieldY[index] = -9999
				PolygonScreenX[index] = -9999
				PolygonScreenY[index] = -9999
				PolygonDirection[index] = JoyCENTER
				PolygonScaleDirection[index] = 0
				PolygonScale[index] = 1
				PolygonScaleDirection[index] = -1
				PolygonTransparency[index] = 0
			endif
		endif
	next index

	if PlayfieldChangedSoDrawIt = TRUE then CheckForLevelClear()

	easterEggOne as integer
	easterEggOne = FALSE
	if (SecretCodeCombined = 9876)
		if ( (MouseButtonLeft = ON and (MouseScreenX > ((ScreenWidth/2)-100) and MouseScreenX < ((ScreenWidth/2)+100) and MouseScreenY > (50) and MouseScreenY < (100))) or (ShiftKeyPressed = TRUE and LastKeyboardChar = 76) )
			PlaySound(1)
			DelayAllUserInput = 20
			easterEggOne = TRUE
		endif
	endif

	if easterEggOne = TRUE
		inc Score, Bonus
		inc Score, ( (Level+1) * 200000 )
		inc Level, 1
		
		if Level = 4
			PlayNewMusic(2, 1)
		elseif Level = 6
			PlayNewMusic(3, 1)
		elseif Level = 7
			PlayNewMusic(4, 1)
		elseif Level = 8
			PlayNewMusic(5, 1)
		elseif Level = 9
			PlayNewMusic(6, 1)
		elseif Level = 10
			PlayNewMusic(7, 1)
			GameWon = TRUE
		endif
		
		NextScreenToDisplay = PlayingScreen
		ScreenFadeStatus = FadingToBlack
	endif


	if GameOver = 0
		CheckForLossOfLife()
		if (PlayerLostALife = TRUE and SecretCodeCombined <> 9876)
			if Lives > 0
				dec Lives, 1
			else
				if CurrentlyPlayingMusicIndex > -1 then StopMusicOGG(MusicTrack[CurrentlyPlayingMusicIndex])
				PlaySound(SoundEffect[5])
				GameOver = 100
			endif
		
			if GameOver = 0
				PlaySound(SoundEffect[4])
				NextScreenToDisplay = PlayingScreen
				ScreenFadeStatus = FadingToBlack
			endif
		endif
	endif
endfunction
