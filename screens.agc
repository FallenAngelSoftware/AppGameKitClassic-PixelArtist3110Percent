// "screens.agc"...

function SetDelayAllUserInput()
	DelayAllUserInput = 5
endfunction

//------------------------------------------------------------------------------------------------------------

function LoadSelectedBackground()
offset as integer
	offset = 0

	if (ScreenToDisplay <> TitleScreen and ScreenToDisplay <> PlayingScreen)
		inc offset, 10
	endif

	LoadImage ( 10, "\media\images\backgrounds\TitleBG.png" )
	LoadImage ( 20, "\media\images\backgrounds\TitleBlurBG.png" )
	LoadImage ( 11, "\media\images\backgrounds\TitleTwoBG.png" )
	LoadImage ( 21, "\media\images\backgrounds\TitleTwoBlurBG.png" )

	if (SelectedBackground = 0)
		TitleBG = CreateSprite ( 10+offset )
	elseif (SelectedBackground = 1)
		TitleBG = CreateSprite ( 11+offset )
	endif

	SetSpriteOffset( TitleBG, (GetSpriteWidth(TitleBG)/2) , (GetSpriteHeight(TitleBG)/2) ) 
	SetSpritePositionByOffset( TitleBG, -9999, -9999 )
	SetSpriteDepth ( TitleBG, 5 )
endfunction

//------------------------------------------------------------------------------------------------------------

function AnimateStaticBG ( )
	if (SelectedBackground = 1)
		if (TitleTwoBGAngle = 0)
			TitleTwoBGAngle = 180
		elseif (TitleTwoBGAngle = 180)
			TitleTwoBGAngle = 0
		endif
		
		SetSpriteAngle(TitleBG, TitleTwoBGAngle)
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function ApplyScreenFadeTransition ( )
	if ScreenFadeStatus = FadingFromBlack
		if ScreenFadeTransparency > 85
			dec ScreenFadeTransparency, 85
		else
			ScreenFadeTransparency = 0
			ScreenFadeStatus = FadingIdle
		endif
		
		SetSpriteColorAlpha( FadingBlackBG, ScreenFadeTransparency )
	elseif ScreenFadeStatus = FadingToBlack
		if (ScreenToDisplay = AboutScreen) then SetSpritePositionByOffset( FadingBlackBG, ScreenWidth/2, AboutScreenBackgroundY )
		
		if ScreenFadeTransparency < 255-85
			inc ScreenFadeTransparency, 85
			
			if (ScreenFadeTransparency = 255-85) then ScreenFadeTransparency = 254
		elseif FadingToBlackCompleted = FALSE
			ScreenFadeTransparency = 255
			FadingToBlackCompleted = TRUE
		elseif (ScreenFadeTransparency = 255)
			ScreenFadeTransparency = 255
			FadingToBlackCompleted = FALSE

			ScreenFadeStatus = FadingFromBlack
			ScreenToDisplay = NextScreenToDisplay

			DestroyAllGUI()
			
			DestroyAllTexts()
			
			DeleteAllSprites()

			DeleteImage(10)
			DeleteImage(20)
			DeleteImage(11)
			DeleteImage(21)
			
			FadingBlackBG = CreateSprite ( 1 )
			SetSpriteDepth ( FadingBlackBG, 1 )
			SetSpriteOffset( FadingBlackBG, (GetSpriteWidth(FadingBlackBG)/2) , (GetSpriteHeight(FadingBlackBG)/2) ) 
			SetSpritePositionByOffset( FadingBlackBG, ScreenWidth/2, ScreenHeight/2 )
			SetSpriteTransparency( FadingBlackBG, 1 )
		
			if (ScreenToDisplay <> AboutScreen)
				LoadInterfaceSprites()
				if (ScreenToDisplay <> PlayingScreen) then PreRenderButtonsWithTexts()
			endif
		endif

		SetSpriteColorAlpha( FadingBlackBG, ScreenFadeTransparency )
	endif
	
	if (SecretCodeCombined = 2777 and ScreenIsDirty = TRUE and ScreenFadeStatus = FadingIdle)
		SetSpriteColorAlpha( FadingBlackBG, 200 )
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplaySteamOverlayScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255

		ClearScreenWithColor ( 0, 0, 0 )

		BlackBG = CreateSprite ( 3 )
		SetSpriteDepth ( BlackBG, 4 )
		SetSpriteOffset( BlackBG, (GetSpriteWidth(BlackBG)/2) , (GetSpriteHeight(BlackBG)/2) ) 
		SetSpritePositionByOffset( BlackBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "TM", 999, 8, 255, 255, 255, 255, 90, 90, 90, 0, 180+130, 23-14, 3 )
		CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "''Pixel Artist 3 110%''", 999, 30, 255, 255, 255, 255, 90, 90, 90, 1, ScreenWidth/2, 29, 3 )
		CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "Copyright 2019 By Fallen Angel Software", 999, 16, 255, 255, 255, 255, 90, 90, 90, 1, ScreenWidth/2, 29+25, 3 )
		CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "www.FallenAngelSoftware.com", 999, 16, 255, 255, 255, 255, 90, 90, 90, 1, ScreenWidth/2, 29+25+25, 3 )

		CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "Loading Now!", 999, 30, 255, 255, 255, 255, 90, 90, 90, 1, ScreenWidth/2, ScreenHeight*.25, 3 )

		LoadPercentText = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 150, 255, 255, 255, 255, 90, 90, 90, 1, ScreenWidth/2, ScreenHeight/2, 3)

		CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, "Please Wait!", 999, 30, 255, 255, 255, 255, 90, 90, 90, 1, ScreenWidth/2, ScreenHeight*.75, 3 )

		ScreenDisplayTimer = 275
		NextScreenToDisplay = AppGameKitScreen

		ScreenIsDirty = TRUE
	endif

	if ScreenDisplayTimer > 0
		LoadPercent = 275 / ScreenDisplayTimer
		LoadPercentFixed = LoadPercent
		if (LoadPercentFixed > 100) then LoadPercentFixed = 100
		SetText( LoadPercentText, str(LoadPercentFixed)+"%" )

		dec ScreenDisplayTimer, 1
	elseif ScreenDisplayTimer = 0
		ScreenFadeStatus = FadingToBlack
		SetText( LoadPercentText, "100%" )
	endif

	ScreenIsDirty = TRUE

	if FadingToBlackCompleted = TRUE
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayAppGameKitScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )
		
		BlackBG = CreateSprite ( 1 )
		SetSpriteDepth ( BlackBG, 4 )
		SetSpriteOffset( BlackBG, (GetSpriteWidth(BlackBG)/2) , (GetSpriteHeight(BlackBG)/2) ) 
		SetSpritePositionByOffset( BlackBG, ScreenWidth/2, ScreenHeight/2 )

		LoadImage ( 5, "\media\images\logos\AppGameKitLogo.png" )
		AppGameKitLogo = CreateSprite ( 5 )
		SetSpriteDepth ( AppGameKitLogo, 3 )
		SetSpriteOffset( AppGameKitLogo, (GetSpriteWidth(AppGameKitLogo)/2) , (GetSpriteHeight(AppGameKitLogo)/2) ) 
		SetSpritePositionByOffset( AppGameKitLogo, ScreenWidth/2, (ScreenHeight/2) )
		
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''The Best $79.99 We Ever Spent On A Game Engine!''", 999, 12, 255, 255, 255, 255, 50, 50, 50, 1, ScreenWidth/2, (ScreenHeight/2)-220, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''The Fallen Angel''", 999, 16, 255, 255, 255, 255, 50, 50, 50, 1, ScreenWidth/2, (ScreenHeight/2)-220+30, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "www.AppGameKit.com", 999, 30, 255, 255, 255, 255, 171, 0, 62, 1, ScreenWidth/2, ScreenHeight-40, 3)
		
		ScreenDisplayTimer = 200
		NextScreenToDisplay = SixteenBitSoftScreen

		ScreenIsDirty = TRUE
	endif

	if ScreenDisplayTimer > 0
		dec ScreenDisplayTimer, 1
	elseif ScreenDisplayTimer = 0
		ScreenFadeStatus = FadingToBlack
	endif
	
	if ScreenDisplayTimer > 0
		if MouseButtonLeft = ON or LastKeyboardChar = 32 or LastKeyboardChar = 13 or LastKeyboardChar = 27
			PlaySoundEffect(1)
			SetDelayAllUserInput()
			ScreenDisplayTimer = 0
		endif
	endif

	if FadingToBlackCompleted = TRUE
		DeleteImage(5)
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplaySixteenBitSoftScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )
		
		BlackBG = CreateSprite ( 1 )
		SetSpriteDepth ( BlackBG, 4 )
		SetSpriteOffset( BlackBG, (GetSpriteWidth(BlackBG)/2) , (GetSpriteHeight(BlackBG)/2) ) 
		SetSpritePositionByOffset( BlackBG, ScreenWidth/2, ScreenHeight/2 )

		LoadImage (30, "\media\images\logos\FAS-Statue.png")
		SixteenBitSoftLogo = CreateSprite ( 30 )
		SetSpriteDepth ( SixteenBitSoftLogo, 3 )
		SetSpriteOffset( SixteenBitSoftLogo, (GetSpriteWidth(SixteenBitSoftLogo)/2) , (GetSpriteHeight(SixteenBitSoftLogo)/2) ) 
		SetSpriteScaleByOffset( SixteenBitSoftLogo, .65, .65 )
		SetSpritePositionByOffset( SixteenBitSoftLogo, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(FALSE, CurrentMinTextIndex, "www.FallenAngelSoftware.com", 999, 21, 0, 255, 0, 255, 0, 128, 0, 1, ScreenWidth/2, ScreenHeight-22, 3)
		
		ScreenDisplayTimer = 200
		NextScreenToDisplay = TitleScreen

		ScreenIsDirty = TRUE
	endif

	if ScreenDisplayTimer > 0
		dec ScreenDisplayTimer, 1
	elseif ScreenDisplayTimer = 0
		ScreenFadeStatus = FadingToBlack
	endif
	
	if ScreenDisplayTimer > 0
		if MouseButtonLeft = ON or LastKeyboardChar = 32 or LastKeyboardChar = 13 or LastKeyboardChar = 27
			PlaySoundEffect(1)
			SetDelayAllUserInput()
			ScreenDisplayTimer = 0
		endif
	endif

	if FadingToBlackCompleted = TRUE
		DeleteImage(30)
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayTitleScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		SaveOptionsAndHighScores()
		
		LoadSelectedBackground()
		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		if MusicVolume > 0 or EffectsVolume > 0
			CreateIcon(1, 18, 18 )
		else
			CreateIcon(0, 18, 18 )
		endif

		offsetY as integer
		offsetY = 10

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, GameVersion, 999, 16, 128, 128, 128, 255, 0, 0, 0, 1, ScreenWidth/2, 18-4, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, GameVersion, 999, 16, 64, 64, 64, 255, 0, 0, 0, 1, ScreenWidth/2, 18+4, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, GameVersion, 999, 16, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 18, 3)

		LoadImage ( 35, "\media\images\logos\PA3Logo.png" )
		PA3Logo = CreateSprite ( 35 )
		SetSpriteOffset( PA3Logo, (GetSpriteWidth(PA3Logo)/2) , (GetSpriteHeight(PA3Logo)/2) ) 
		SetSpriteScaleByOffset( PA3Logo, 1, 1.3 )
		SetSpritePositionByOffset( PA3Logo, ScreenWidth/2, 49+offsetY+36 )
		SetSpriteDepth ( PA3Logo, 3 )
			
		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 105+offsetY+13+5+28 )
		SetSpriteColor(ScreenLine[0], 255, 255, 255, 255)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''"+HighScoreName [ GameMode, 0 ]+"''", 999, 19, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 125+offsetY+13+5+28, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, str(HighScoreScore [ GameMode, 0 ]), 999, 19, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 125+21+offsetY+13+5+28, 3)

		SetSpritePositionByOffset( ScreenLine[1], ScreenWidth/2, 165+offsetY+13+3+28 )
		SetSpriteColor(ScreenLine[1], 255, 255, 255, 255)
		
		startScreenY as integer = 244
		inc startScreenY, offsetY
		offsetScreenY as integer = 43
		CreateButton( 0, (ScreenWidth / 2), startScreenY + (offsetScreenY*0) )
		CreateButton( 1, (ScreenWidth / 2), startScreenY + (offsetScreenY*1) )
		CreateButton( 2, (ScreenWidth / 2), startScreenY + (offsetScreenY*2) )
		CreateButton( 3, (ScreenWidth / 2), startScreenY + (offsetScreenY*3) )
		CreateButton( 4, (ScreenWidth / 2), startScreenY + (offsetScreenY*4) )
		CreateButton( 5, (ScreenWidth / 2), startScreenY + (offsetScreenY*5) )

		SetSpritePositionByOffset( ScreenLine[2], ScreenWidth/2, ScreenHeight-165+offsetY+13 )
		SetSpriteColor(ScreenLine[2], 255, 255, 255, 255)

		if ShowCursor = TRUE
			CreateIcon(2, (ScreenWidth/2), (ScreenHeight-100+13) )
		elseif ShowCursor = FALSE
			CreateIcon(3, (ScreenWidth/2), (ScreenHeight-100+13) )
		endif

		SetSpritePositionByOffset( ScreenLine[3], ScreenWidth/2, ScreenHeight-40+offsetY-15+13 )
		SetSpriteColor(ScreenLine[3], 255, 255, 255, 255)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "©2019 www.FallenAngelSoftware.com", 999, 17, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, ScreenHeight-25+13-2, 3)

		if (SecretCodeCombined = 5432 or SecretCodeCombined = 5431) then CreateIcon(6, 360-17, 17)
		
		ScreenIsDirty = TRUE
	endif

	if ThisIconWasPressed(0) = TRUE
		if MusicVolume > 0 or EffectsVolume > 0
			SetSpriteColorAlpha(Icon[IconSprite[0]], 0)
			IconSprite[0] = 0
			SetSpriteColorAlpha(Icon[IconSprite[0]], 255)
			MusicVolume = 0
			EffectsVolume = 0
			SetVolumeOfAllMusicAndSoundEffects()
			GUIchanged = TRUE
		else
			SetSpriteColorAlpha(Icon[IconSprite[0]], 0)
			IconSprite[0] = 1
			SetSpriteColorAlpha(Icon[IconSprite[0]], 255)
			MusicVolume = 100
			EffectsVolume = 100
			SetVolumeOfAllMusicAndSoundEffects()
			GUIchanged = TRUE
		endif
		SaveOptionsAndHighScores()
	elseif ThisIconWasPressed(1) = TRUE
		OpenBrowser( "https://play.google.com/store/apps/details?id=com.fallenangelsoftware.pixelartist" )
	endif

	if ThisButtonWasPressed(0) = TRUE
		SetupForNewGame()
		NextScreenToDisplay = CutSceneScreen
		ScreenFadeStatus = FadingToBlack
	elseif ThisButtonWasPressed(1) = TRUE
		NextScreenToDisplay = OptionsScreen
		ScreenFadeStatus = FadingToBlack
	elseif ThisButtonWasPressed(2) = TRUE
		NextScreenToDisplay = HowToPlayScreen
		ScreenFadeStatus = FadingToBlack
	elseif ThisButtonWasPressed(3) = TRUE
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	elseif ThisButtonWasPressed(4) = TRUE
		NextScreenToDisplay = AboutScreen
		ScreenFadeStatus = FadingToBlack
	elseif ThisButtonWasPressed(5) = TRUE
		if Platform = Android
			ExitGame = 1
		elseif Platform = Web
			OpenBrowser( "http://www.fallenangelsoftware.com" )
		elseif (Platform = Windows or Platform = Linux)
			ExitGame = 1		
		endif
	elseif ThisIconWasPressed(2) = TRUE
		MusicVolume = 100
		EffectsVolume = 100
		SetVolumeOfAllMusicAndSoundEffects()
		GUIchanged = TRUE
		
		MusicPlayerScreenIndex = 0

		NextScreenToDisplay = MusicPlayerScreen
		ScreenFadeStatus = FadingToBlack
	endif

	AnimateStaticBG()

	if FadingToBlackCompleted = TRUE
		DeleteImage(35)
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayOptionsScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		LoadSelectedBackground()
		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''O P T I O N S''", 999, 30, 255, 255, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 255, 255, 0, 255)

		CreateArrowSet(75-17)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Music Volume:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 75-17, 3)
		ArrowSetTextStringIndex[0] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 75-17, 3)
		if MusicVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "100%" )
		elseif MusicVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "75%" )
		elseif MusicVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "50%" )
		elseif MusicVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "25%" )
		elseif MusicVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "0%" )
		endif

		CreateArrowSet(75+44-17)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Effects Volume:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 75+44-17, 3)
		ArrowSetTextStringIndex[1] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 75+44-17, 3)
		if EffectsVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "100%" )
		elseif EffectsVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "75%" )
		elseif EffectsVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "50%" )
		elseif EffectsVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "25%" )
		elseif EffectsVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "0%" )
		endif

		SetSpritePositionByOffset( ScreenLine[1], ScreenWidth/2, 150-17 )
		SetSpriteColor(ScreenLine[1], 255, 255, 255, 255)

		CreateArrowSet(180-19)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Game Mode:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 180-19, 3)
		ArrowSetTextStringIndex[2] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 180-19, 3)
		if GameMode = ChildStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Child" )
		elseif GameMode = TeenStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Teen" )
		elseif GameMode = AdultStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Adult" )
		endif

		CreateArrowSet(180+44+23-38-3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Background:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 180+44+23-38-3, 3)
		ArrowSetTextStringIndex[3] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 180+44+23-38-3, 3)
		if SelectedBackground = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[3], "Space" )
		elseif SelectedBackground = 1
			SetTextStringOutlined ( ArrowSetTextStringIndex[3], "T.V. Static" )
		endif

		CreateArrowSet(180+44+23-38+38+2)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Starting Level:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 180+44+23-38+38+2, 3)
		ArrowSetTextStringIndex[4] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 180+44+23-38+38+2, 3)
		SetTextStringOutlined ( ArrowSetTextStringIndex[4], str(StartingLevel) )

		SetSpritePositionByOffset( ScreenLine[2], ScreenWidth/2, 256+16+5 )
		SetSpriteColor(ScreenLine[2], 255, 255, 255, 255)

		CreateArrowSet(288+16)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Secret Code #1:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 288+16, 3)
		ArrowSetTextStringIndex[5] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 288+16, 3)
		SetTextStringOutlined ( ArrowSetTextStringIndex[5], str(SecretCode[0]) )

		CreateArrowSet(288+44+16)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Secret Code #2:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 288+44+16, 3)
		ArrowSetTextStringIndex[6] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 288+44+16, 3)
		SetTextStringOutlined ( ArrowSetTextStringIndex[6], str(SecretCode[1]) )

		CreateArrowSet(288+44+44+16)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Secret Code #3:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 288+44+44+16, 3)
		ArrowSetTextStringIndex[7] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 288+44+44+16, 3)
		SetTextStringOutlined ( ArrowSetTextStringIndex[7], str(SecretCode[2]) )

		CreateArrowSet(288+44+44+44+16)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Secret Code #4:", 999, 20, 255, 255, 255, 255, 0, 0, 0, 0, 56, 288+44+44+44+16, 3)
		ArrowSetTextStringIndex[8] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 2, (ScreenWidth-56), 288+44+44+44+16, 3)
		SetTextStringOutlined ( ArrowSetTextStringIndex[8], str(SecretCode[3]) )

		SetSpritePositionByOffset( ScreenLine[3], ScreenWidth/2, 443+19 )
		SetSpriteColor(ScreenLine[3], 255, 255, 255, 255)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "See You Again", 999, 45, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 495, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Next Time!", 999, 45, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 490+60, 3)
		
		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 255, 255, 0, 255)

		CreateButton( 6, (ScreenWidth / 2), (ScreenHeight-40+15) )
		ChangingBackground = FALSE

		ScreenIsDirty = TRUE
	endif

	if ThisButtonWasPressed(6) = TRUE
		SetDelayAllUserInput()
		NextScreenToDisplay = TitleScreen
		ScreenFadeStatus = FadingToBlack
	endif

	index as integer

	if ThisArrowWasPressed(0) = TRUE
		if MusicVolume > 0
			dec MusicVolume, 25
		else
			MusicVolume = 100
		endif

		if MusicVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "100%" )
		elseif MusicVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "75%" )
		elseif MusicVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "50%" )
		elseif MusicVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "25%" )
		elseif MusicVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "0%" )
		endif
		
		SetVolumeOfAllMusicAndSoundEffects()
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(.5) = TRUE
		if MusicVolume < 100
			inc MusicVolume, 25
		else
			MusicVolume = 0
		endif

		if MusicVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "100%" )
		elseif MusicVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "75%" )
		elseif MusicVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "50%" )
		elseif MusicVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "25%" )
		elseif MusicVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "0%" )
		endif
		
		SetVolumeOfAllMusicAndSoundEffects()
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(1) = TRUE
		if EffectsVolume > 0
			dec EffectsVolume, 25
		else
			EffectsVolume = 100
		endif

		if EffectsVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "100%" )
		elseif EffectsVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "75%" )
		elseif EffectsVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "50%" )
		elseif EffectsVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "25%" )
		elseif EffectsVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "0%" )
		endif
		
		SetVolumeOfAllMusicAndSoundEffects()
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(1.5) = TRUE
		if EffectsVolume < 100
			inc EffectsVolume, 25
		else
			EffectsVolume = 0
		endif

		if EffectsVolume = 100
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "100%" )
		elseif EffectsVolume = 75
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "75%" )
		elseif EffectsVolume = 50
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "50%" )
		elseif EffectsVolume = 25
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "25%" )
		elseif EffectsVolume = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[1], "0%" )
		endif
		
		SetVolumeOfAllMusicAndSoundEffects()
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(2) = TRUE
		if GameMode > 0
			dec GameMode, 1
		else
			GameMode = 2
		endif

		if (StartingLevel > LevelSkip[GameMode]) then StartingLevel = 1
		SetTextStringOutlined ( ArrowSetTextStringIndex[4], str(StartingLevel) )

		if GameMode = ChildStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Child" )
		elseif GameMode = TeenStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Teen" )
		elseif GameMode = AdultStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Adult" )
		endif

		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(2.5) = TRUE
		if GameMode < 2
			inc GameMode, 1
		else
			GameMode = 0
		endif

		if (StartingLevel > LevelSkip[GameMode]) then StartingLevel = 1
		SetTextStringOutlined ( ArrowSetTextStringIndex[4], str(StartingLevel) )

		if GameMode = ChildStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Child" )
		elseif GameMode = TeenStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Teen" )
		elseif GameMode = AdultStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[2], "Adult" )
		endif

		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(3) = TRUE
		if SelectedBackground > 0
			dec SelectedBackground, 1
		else
			SelectedBackground = 1
		endif

		ChangingBackground = TRUE
		ScreenFadeStatus = FadingToBlack
		NextScreenToDisplay = OptionsScreen
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(3.5) = TRUE
		if SelectedBackground < 1
			inc SelectedBackground, 1
		else
			SelectedBackground = 0
		endif

		ChangingBackground = TRUE
		ScreenFadeStatus = FadingToBlack
		NextScreenToDisplay = OptionsScreen
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(4) = TRUE
		if (StartingLevel > 1)
			dec StartingLevel, 1
		else
			StartingLevel = LevelSkip[GameMode]
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[4], str(StartingLevel) )

		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(4.5) = TRUE
		if (StartingLevel < LevelSkip[GameMode])
			inc StartingLevel, 1
		else
			StartingLevel = 1
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[4], str(StartingLevel) )

		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(5) = TRUE
		if SecretCode[0] > 0
			dec SecretCode[0], 1
		else
			SecretCode[0] = 9
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[5], str(SecretCode[0]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(5.5) = TRUE
		if SecretCode[0] < 9
			inc SecretCode[0], 1
		else
			SecretCode[0] = 0
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[5], str(SecretCode[0]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(6) = TRUE
		if SecretCode[1] > 0
			dec SecretCode[1], 1
		else
			SecretCode[1] = 9
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[6], str(SecretCode[1]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(6.5) = TRUE
		if SecretCode[1] < 9
			inc SecretCode[1], 1
		else
			SecretCode[1] = 0
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[6], str(SecretCode[1]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(7) = TRUE
		if SecretCode[2] > 0
			dec SecretCode[2], 1
		else
			SecretCode[2] = 9
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[7], str(SecretCode[2]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(7.5) = TRUE
		if SecretCode[2] < 9
			inc SecretCode[2], 1
		else
			SecretCode[2] = 0
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[7], str(SecretCode[2]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(8) = TRUE
		if SecretCode[3] > 0
			dec SecretCode[3], 1
		else
			SecretCode[3] = 9
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[8], str(SecretCode[3]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput()
	elseif ThisArrowWasPressed(8.5) = TRUE
		if SecretCode[3] < 9
			inc SecretCode[3], 1
		else
			SecretCode[3] = 0
		endif

		SetTextStringOutlined ( ArrowSetTextStringIndex[8], str(SecretCode[3]) )
		SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )
		SetDelayAllUserInput()
	endif

	if (SecretCodeCombined = 2777)
		SetSpritePositionByOffset( FadingBlackBG,  -80, -200 )
		SetSpriteColorAlpha( FadingBlackBG, 200 )
	else
		SetSpritePositionByOffset( FadingBlackBG,  ScreenWidth/2, ScreenHeight/2 )
		SetSpriteColorAlpha( FadingBlackBG, 0 )
	endif

	if (SecretCodeCombined = 6789) then LevelSkip[GameMode] = 9

	if ThisIconWasPressed(0) = TRUE
		OpenBrowser( "https://play.google.com/store/apps/details?id=com.fallenangelsoftware.lettersfall" )
	endif

	DrawAllArrowSets()

	AnimateStaticBG()
	
	if FadingToBlackCompleted = TRUE
	endif
endfunction
	
//------------------------------------------------------------------------------------------------------------

function DisplayHowToPlayScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		LoadSelectedBackground()
		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''H O W   T O   P L A Y''", 999, 30, 255, 255, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 255, 255, 0, 255)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "+ Match bottom grid to top map! +", 999, 19, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 70, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "(by moving the colored squares)", 999, 16, 200, 200, 200, 255, 0, 0, 0, 1, ScreenWidth/2, 70+25, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "- Avoid the evil polygon cubes! -", 999, 19, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 70+25+40, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "(by rapidly moving your position)", 999, 16, 200, 200, 200, 255, 0, 0, 0, 1, ScreenWidth/2, 70+25+40+25, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "+ Can you complete all 9 levels? +", 999, 19, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 70+25+40+25+40, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "(must beat them all to win)", 999, 16, 200, 200, 200, 255, 0, 0, 0, 1, ScreenWidth/2, 70+25+40+25+40+25, 3)

		LoadImage ( 300000, "\media\images\pixels\SquareBlack.png" )
		LoadImage ( 300001, "\media\images\pixels\SquareRed.png" )
		LoadImage ( 300002, "\media\images\pixels\SquareOrange.png" )
		LoadImage ( 300003, "\media\images\pixels\SquareYellow.png" )
		LoadImage ( 300004, "\media\images\pixels\Player.png" )
		LoadImage ( 300005, "\media\images\pixels\SquareGreen.png" )
		LoadImage ( 300006, "\media\images\pixels\SquareBlue.png" )
		LoadImage ( 300007, "\media\images\pixels\SquarePurple.png" )
		LoadImage ( 300008, "\media\images\pixels\SquareBlack.png" )

		color as integer
		for color = 0 to 8
			PlayfieldPixels[color, 0] = CreateSprite ( 300000+color )
			SetSpriteDepth ( PlayfieldPixels[color, 0], 5 )
			SetSpriteOffset( PlayfieldPixels[color, 0], (GetSpriteWidth(PlayfieldPixels[color, 0])/2) , (GetSpriteHeight(PlayfieldPixels[color, 0])/2) ) 
			SetSpritePositionByOffset( PlayfieldPixels[color, 0], -9999, -9999 )
			SetSpriteTransparency(PlayfieldPixels[color, 0], 255) 
			SetSpriteColorAlpha(PlayfieldPixels[color, 0], 255)
			SetSpriteScaleByOffset(PlayfieldPixels[color, 0], 2, 2)
		next color

		direction as integer
		for direction = 1 to 12
			PlayfieldMove[direction] = CreateSprite ( 299990 )
			SetSpriteDepth ( PlayfieldMove[direction], 4 )
			SetSpriteOffset( PlayfieldMove[direction], (GetSpriteWidth(PlayfieldMove[direction])/2) , (GetSpriteHeight(PlayfieldMove[direction])/2) ) 
			SetSpritePositionByOffset( PlayfieldMove[direction], -9999, -9999 )
			SetSpriteColorAlpha(PlayfieldMove[direction], 128)
			SetSpriteScaleByOffset(PlayfieldMove[direction], 2, 2)
		next direction

		index as integer
		screenX as integer
		screenY as integer
		screenX = (ScreenWidth/2) - (50*2)
		screenY = (ScreenHeight/2) - (10)
		for index = 0 to 8
			if (index = 1 or index = 3 or index = 5 or index = 7) then SetSpritePositionByOffset( PlayfieldMove[index], screenX, screenY )
			SetSpritePositionByOffset( PlayfieldPixels[index, 0], screenX, screenY )
			screenX = screenX + (50*2)
			if (  screenX > ( (50*2)*3 )  )
				screenX = (ScreenWidth/2) - (50*2)
				screenY = screenY + (50*2)
			endif
		next index

		AboutScreenPlayfield[0, 0] = 0
		AboutScreenPlayfield[1, 0] = 1
		AboutScreenPlayfield[2, 0] = 2
		AboutScreenPlayfield[0, 1] = 3
		AboutScreenPlayfield[1, 1] = 4
		AboutScreenPlayfield[2, 1] = 5
		AboutScreenPlayfield[0, 2] = 6
		AboutScreenPlayfield[1, 2] = 7
		AboutScreenPlayfield[2, 2] = 8
		AboutScreenMoveDelay = 25
		AboutScreenMoveIndex = 0

		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 255, 255, 0, 255)

		CreateButton( 6, (ScreenWidth / 2), (ScreenHeight-40+15) )

		ScreenIsDirty = TRUE
	endif

	pfScreenY as integer
	pfScreenX as integer
	pfScreenY = (ScreenHeight/2) - (10)
	pfScreenX = (ScreenWidth/2) - (50*2)
	pfIndex as integer
	playfieldY as integer
	playfieldX as integer
	moveIndex as integer
	playerIndexY as integer
	playerIndexX as integer
	for playfieldY = 0 to 2
		for playfieldX = 0 to 2
			if (AboutScreenPlayfield[playfieldX, playfieldY] = 4)
				playerIndexX = playfieldX
				playerIndexY = playfieldY
			endif
		next playfieldX
	next playfieldY
		
	for playfieldY = 0 to 2
		for playfieldX = 0 to 2
			SetSpritePositionByOffset( PlayfieldPixels[ AboutScreenPlayfield[playfieldX, playfieldY], 0 ], pfScreenX, pfScreenY )
				
			pfScreenX = pfScreenX + (50*2)
		next playfieldX
		
		pfScreenX = (ScreenWidth/2) - (50*2)
		pfScreenY = pfScreenY + (50*2)
	next playfieldY

	for moveIndex = 1 to 12
		SetSpritePositionByOffset( PlayfieldMove[moveIndex], -9999, -9999 )
	next moveIndex
	
	pfScreenY = (ScreenHeight/2) - (10)
	pfScreenX = (ScreenWidth/2) - (50*2)
	moveIndex = 1
	for playfieldY = 0 to 2
		for playfieldX = 0 to 2
			if (playfieldX = playerIndexX or playfieldY = playerIndexY)
				if (playfieldX = playerIndexX and playfieldY = playerIndexY)
					
				else
					SetSpritePositionByOffset( PlayfieldMove[moveIndex], pfScreenX, pfScreenY )
					
					moveIndex = moveIndex + 1
				endif
			endif
		
			pfScreenX = pfScreenX + (50*2)
			
		next playfieldX
		
		pfScreenX = (ScreenWidth/2) - (50*2)
		pfScreenY = pfScreenY + (50*2)
	next playfieldY

	oldTile as integer
	if (AboutScreenMoveDelay > 0)
		AboutScreenMoveDelay = AboutScreenMoveDelay - 1
	else
		AboutScreenMoveDelay = 25
		
		if (AboutScreenMoveIndex = 0)
			oldTile = AboutScreenPlayfield[1, 0]
			AboutScreenPlayfield[1, 0] = AboutScreenPlayfield[1, 1]
			AboutScreenPlayfield[1, 1] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 1)
			oldTile = AboutScreenPlayfield[0, 0]
			AboutScreenPlayfield[0, 0] = AboutScreenPlayfield[1, 0]
			AboutScreenPlayfield[1, 0] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 2)
			oldTile = AboutScreenPlayfield[0, 1]
			AboutScreenPlayfield[0, 1] = AboutScreenPlayfield[0, 0]
			AboutScreenPlayfield[0, 0] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 3)
			oldTile = AboutScreenPlayfield[1, 1]
			AboutScreenPlayfield[1, 1] = AboutScreenPlayfield[0, 1]
			AboutScreenPlayfield[0, 1] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 4)
			oldTile = AboutScreenPlayfield[1, 2]
			AboutScreenPlayfield[1, 2] = AboutScreenPlayfield[1, 1]
			AboutScreenPlayfield[1, 1] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 5)
			oldTile = AboutScreenPlayfield[2, 2]
			AboutScreenPlayfield[2, 2] = AboutScreenPlayfield[1, 2]
			AboutScreenPlayfield[1, 2] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 6)
			oldTile = AboutScreenPlayfield[2, 1]
			AboutScreenPlayfield[2, 1] = AboutScreenPlayfield[2, 2]
			AboutScreenPlayfield[2, 2] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 7)
			oldTile = AboutScreenPlayfield[1, 1]
			AboutScreenPlayfield[1, 1] = AboutScreenPlayfield[2, 1]
			AboutScreenPlayfield[2, 1] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 8)
			oldTile = AboutScreenPlayfield[0, 1]
			AboutScreenPlayfield[0, 1] = AboutScreenPlayfield[1, 1]
			AboutScreenPlayfield[1, 1] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 9)
			oldTile = AboutScreenPlayfield[0, 2]
			AboutScreenPlayfield[0, 2] = AboutScreenPlayfield[0, 1]
			AboutScreenPlayfield[0, 1] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 10)
			oldTile = AboutScreenPlayfield[1, 2]
			AboutScreenPlayfield[1, 2] = AboutScreenPlayfield[0, 2]
			AboutScreenPlayfield[0, 2] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 11)
			oldTile = AboutScreenPlayfield[1, 1]
			AboutScreenPlayfield[1, 1] = AboutScreenPlayfield[1, 2]
			AboutScreenPlayfield[1, 2] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 12)
			oldTile = AboutScreenPlayfield[2, 1]
			AboutScreenPlayfield[2, 1] = AboutScreenPlayfield[1, 1]
			AboutScreenPlayfield[1, 1] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 13)
			oldTile = AboutScreenPlayfield[2, 0]
			AboutScreenPlayfield[2, 0] = AboutScreenPlayfield[2, 1]
			AboutScreenPlayfield[2, 1] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 14)
			oldTile = AboutScreenPlayfield[1, 0]
			AboutScreenPlayfield[1, 0] = AboutScreenPlayfield[2, 0]
			AboutScreenPlayfield[2, 0] = oldTile
			AboutScreenMoveIndex = AboutScreenMoveIndex + 1
		elseif (AboutScreenMoveIndex = 15)
			oldTile = AboutScreenPlayfield[1, 0]
			AboutScreenPlayfield[1, 0] = AboutScreenPlayfield[1, 1]
			AboutScreenPlayfield[1, 1] = oldTile
			AboutScreenMoveIndex = 0
		endif
	endif

	if ThisButtonWasPressed(6) = TRUE
		NextScreenToDisplay = TitleScreen
		ScreenFadeStatus = FadingToBlack
	endif

	AnimateStaticBG()

	if FadingToBlackCompleted = TRUE
		for color = 0 to 8
			DeleteSprite(PlayfieldPixels[color, 0])
		next color
		
		for index = 300000 to 300008
			DeleteImage(index)
		next index

		for direction = 1 to 12
			DeleteSprite(PlayfieldMove[direction])
		next direction
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayHighScoresScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		LoadSelectedBackground()
		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''H I G H   S C O R E S''", 999, 30, 255, 255, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 255, 255, 0, 255)

		CreateArrowSet(75)
		ArrowSetTextStringIndex[0] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, (ScreenWidth/2), 75, 3)
		if GameMode = ChildStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "Child Mode" )
		elseif GameMode = TeenStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "Teen Mode" )
		elseif GameMode = AdultStoryMode
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "Adult Mode" )
		endif

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "NAME", 999, 15, 200, 200, 200, 255, 0, 0, 0, 0, 29, 130, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "LEVEL", 999, 15, 200, 200, 200, 255, 0, 0, 0, 0, 29+170, 130, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "SCORE", 999, 15, 200, 200, 200, 255, 0, 0, 0, 0, 29+170+60, 130, 3)
		screenY as integer
		screenY = 150
		rank as integer
		blue as integer
		for rank = 0 to 9
			blue = 255
			if Score = HighScoreScore [ GameMode, rank ] and Level = HighScoreLevel [ GameMode, rank ] then blue = 0
			
			CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, str(rank+1)+".", 999, 15, 200, 200, 200, 255, 0, 0, 0, 0, 8, screenY, 3)
			CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, HighScoreName [ GameMode, rank ], 999, 18, 255, 255, blue, 255, 0, 0, 0, 0, 29, screenY, 3)
			
			if HighScoreLevel[GameMode, rank] < 10
				CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, str(HighScoreLevel [ GameMode, rank ]), 999, 18, 255, 255, blue, 255, 0, 0, 0, 0, 29+170, screenY, 3)
			elseif (GameMode = ChildStoryMode or GameMode = TeenStoryMode or GameMode = AdultStoryMode)
				CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "WON!", 999, 18, 255, 255, blue, 255, 0, 0, 0, 0, 29+170, screenY, 3)
			else
				CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, str(HighScoreLevel [ GameMode, rank ]), 999, 18, 255, 255, blue, 255, 0, 0, 0, 0, 29+170, screenY, 3)
			endif
			
			CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, str(HighScoreScore [ GameMode, rank ]), 999, 18, 255, 255, blue, 255, 0, 0, 0, 0, 29+170+60, screenY, 3)
	
			inc screenY, 40
		next rank

		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 255, 255, 0, 255)

		CreateButton( 6, (ScreenWidth / 2), (ScreenHeight-40+15) )
		
		if SecretCode[0] = 2 and SecretCode[1] = 7 and SecretCode[2] = 7 and SecretCode[3] = 7 then CreateButton( 7, (ScreenWidth/2), (ScreenHeight-85) )

		ScreenIsDirty = TRUE
	endif

	if ThisButtonWasPressed(6) = TRUE
		NextScreenToDisplay = TitleScreen
		ScreenFadeStatus = FadingToBlack
	elseif ThisButtonWasPressed(7) = TRUE
		ClearHighScores()
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	endif

	if ThisArrowWasPressed(0) = TRUE
		if GameMode > 0
			dec GameMode, 1
		else
			GameMode = 2
		endif
		
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	elseif ThisArrowWasPressed(.5) = TRUE
		if GameMode < 2
			inc GameMode, 1
		else
			GameMode = 0
		endif
		
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	endif

	DrawAllArrowSets()

	AnimateStaticBG()
	
	if FadingToBlackCompleted = TRUE
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function SetupAboutScreenTexts( )
	outline as integer
	
//	if (GameWon = TRUE)	
		outline = TRUE
//	else
//		outline = FALSE
//	endif

	startScreenY as integer
	startScreenY = 640+15
	AboutTextsScreenY[0] = startScreenY
	StartIndexOfAboutScreenTexts = CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[0], 999, 16, 255, 255, AboutTextsBlue[0], 255, 0, 0, 0, 1, ScreenWidth/2+84, AboutTextsScreenY[0], 3)
	AboutTextVisable[0] = 0
	inc startScreenY, 25
	AboutTextsScreenY[1] = startScreenY
	CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[1], 999, 16, 255, 255, AboutTextsBlue[1], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[1], 3)
	AboutTextVisable[1] = 0

	index as integer
	for index = 2 to (NumberOfAboutScreenTexts-1)
		if AboutTextsBlue[index-1] = 0
			inc startScreenY, 30
		elseif AboutTextsBlue[index-1] = 254
			inc startScreenY, 30
		elseif AboutTextsBlue[index] = 254
			inc startScreenY, 30
		elseif AboutTextsBlue[index-1] = 255 and AboutTextsBlue[index] = 255
			inc startScreenY, 30
		else
			inc startScreenY, 80
		endif

		if index = (NumberOfAboutScreenTexts-2)
			inc startScreenY, 320-45
		endif

		AboutTextsScreenY[index] = startScreenY
		
		if (AboutTexts[index] = "Hyper-Custom ''JeZxLee'' Pro-Built Desktop")
			CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[index], 999, 15, 255, 255, AboutTextsBlue[index], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[index], 3)
		elseif (AboutTexts[index] = "GIGABYTE® GA-970A-DS3P 2.0 AM3+ Motherboard")
			CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[index], 999, 13, 255, 255, AboutTextsBlue[index], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[index], 3)
		elseif (AboutTexts[index] = "nVidia® GeForce GTX 970TT 4GB GDDR5 GPU")
			CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[index], 999, 15, 255, 255, AboutTextsBlue[index], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[index], 3)
		elseif (AboutTexts[index] = "Western Digital® 1TB HDD Hard Drive(Personal Data)")
			CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[index], 999, 13, 255, 255, AboutTextsBlue[index], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[index], 3)
		else
			CreateAndInitializeOutlinedText(outline, CurrentMinTextIndex, AboutTexts[index], 999, 16, 255, 255, AboutTextsBlue[index], 255, 0, 0, 0, 1, ScreenWidth/2, AboutTextsScreenY[index], 3)
		endif

		AboutTextVisable[index] = 0
	next index
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayAboutScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		SetDelayAllUserInput()
		
		LoadSelectedBackground()

		if (GameWon = FALSE)
			SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )
		else
			LoadImage (50009, "\media\images\story\Story-10.png")
			StoryImage = CreateSprite ( 50009 )
			SetSpriteOffset( StoryImage, (GetSpriteWidth(StoryImage)/2) , (GetSpriteHeight(StoryImage)/2) ) 
			SetSpriteDepth( StoryImage, 4 )
			SetSpritePositionByOffset( StoryImage, ScreenWidth/2, ScreenHeight/2 )
		endif

		NextScreenToDisplay = TitleScreen
		SetupAboutScreenTexts()
		DestroyAllGUI()
		
		AboutScreenOffsetY = 0
		AboutScreenBackgroundY = 320

		AboutScreenFPSY = -200

		multiplier = 3

		ScreenIsDirty = TRUE
	endif

	if AboutScreenOffsetY > (AboutTextsScreenY[NumberOfAboutScreenTexts-1]+10) or MouseButtonLeft = ON or LastKeyboardChar = 32 or LastKeyboardChar = 13 or LastKeyboardChar = 27
		ScreenFadeStatus = FadingToBlack
		if AboutScreenOffsetY < (AboutTextsScreenY[NumberOfAboutScreenTexts-1]+10) then PlaySoundEffect(1)
		SetDelayAllUserInput()
	endif

	if (PerformancePercent > 1)
		multiplier = 3 * PerformancePercent
	endif

	if (ScreenFadeStatus = FadingIdle)
		inc AboutScreenOffsetY, multiplier
		inc AboutScreenBackgroundY, multiplier
		inc AboutScreenFPSY, multiplier
		
			if (GameWon = FALSE)
				SetSpritePositionByOffset( TitleBG, ScreenWidth/2, AboutScreenBackgroundY )
			elseif (GameWon = TRUE)
				SetSpritePositionByOffset( StoryImage, ScreenWidth/2, AboutScreenBackgroundY )
			endif

		if (SecretCodeCombined = 2777) then SetSpritePositionByOffset( FadingBlackBG, -80, AboutScreenFPSY )

		SetViewOffset( 0, AboutScreenOffsetY )
	endif

	AnimateStaticBG()

	if FadingToBlackCompleted = TRUE
		SetViewOffset( 0, 0 )
		if (GameWon = TRUE) then DeleteImage(50009)

		LoadInterfaceSprites()
		PreRenderButtonsWithTexts()

		if (GameWon = TRUE)
			CheckPlayerForHighScore()
			if (PlayerRankOnGameOver < 10)
				if (OnMobile = TRUE)
					NextScreenToDisplay = NewHighScoreNameInputAndroidScreen
				else
					NextScreenToDisplay = NewHighScoreNameInputScreen
				endif
			else	
				NextScreenToDisplay = HighScoresScreen
			endif
		elseif (GameWon = FALSE)
			NextScreenToDisplay = TitleScreen
		endif
		
		GameWon = FALSE
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayMusicPlayerScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		LoadSelectedBackground()
		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''M U S I C   S C R E E N''", 999, 30, 255, 255, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 255, 255, 0, 255)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "CHOOSE", 999, 65, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 120, 3)

		PlayNewMusic(MusicPlayerScreenIndex, 1)

		CreateArrowSet(ScreenHeight/3)
		ArrowSetTextStringIndex[0] = CreateAndInitializeOutlinedText( TRUE, CurrentMinTextIndex, " ", 999, 16, 255, 255, 255, 255, 0, 0, 0, 1, (ScreenWidth/2), (ScreenHeight/3), 3 )
		if MusicPlayerScreenIndex = 0
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Title" )
		elseif MusicPlayerScreenIndex = 1
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: In Game 1-3" )
		elseif MusicPlayerScreenIndex = 2
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: In Game 4-5" )
		elseif MusicPlayerScreenIndex = 3
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: In Game 6" )
		elseif MusicPlayerScreenIndex = 4
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: In Game 7" )
		elseif MusicPlayerScreenIndex = 5
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: In Game 8" )
		elseif MusicPlayerScreenIndex = 6
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: In Game 9" )
		elseif MusicPlayerScreenIndex = 7
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: New High Score Sad" )
		elseif MusicPlayerScreenIndex = 8
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: New High Score Happy" )
		elseif MusicPlayerScreenIndex = 9
			SetTextStringOutlined ( ArrowSetTextStringIndex[0], "BGM: Win Game" )
		endif

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "YOUR", 999, 65, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 300, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "BGM", 999, 65, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 300+75, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "MUSIC!", 999, 65, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 300+75+75, 3)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "(Not Final!)", 999, 35, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 300+75+75+80, 3)

		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 255, 255, 0, 255)

		CreateButton( 6, (ScreenWidth / 2), (ScreenHeight-40+15) )

		ScreenIsDirty = TRUE
	endif

	if ThisButtonWasPressed(6) = TRUE
		NextScreenToDisplay = TitleScreen
		ScreenFadeStatus = FadingToBlack
		MusicPlayerScreenIndex = 0
		PlayNewMusic(0, 1)
	endif

	if ThisArrowWasPressed(0) = TRUE
		if MusicPlayerScreenIndex > 0
			dec MusicPlayerScreenIndex, 1
		else
			MusicPlayerScreenIndex = 9
		endif

		if (MusicPlayerScreenIndex = 9 and SecretCodeCombined <> 5431) then MusicPlayerScreenIndex = 8
		
		NextScreenToDisplay = MusicPlayerScreen
		ScreenFadeStatus = FadingToBlack
	elseif ThisArrowWasPressed(.5) = TRUE
		if MusicPlayerScreenIndex < 9
			inc MusicPlayerScreenIndex, 1
		else
			MusicPlayerScreenIndex = 0
		endif

		if (MusicPlayerScreenIndex = 9 and SecretCodeCombined <> 5431) then MusicPlayerScreenIndex = 0
		
		NextScreenToDisplay = MusicPlayerScreen
		ScreenFadeStatus = FadingToBlack
	endif

	DrawAllArrowSets()

	AnimateStaticBG()
	
	if FadingToBlackCompleted = TRUE
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function ClearSinglePolygonSprites( polygonIndex as integer)
	index as integer
	for index = 0 to 4
		SetSpritePositionByOffset( PolygonSpriteHorizontal[polygonIndex, index], -9999, -9999 )
		SetSpritePositionByOffset( PolygonSpriteVertical[polygonIndex, index], -9999, -9999 )
	next index
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayPlayingScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		LoadSelectedBackground()
		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		BlackBG = CreateSprite ( 3 )
		SetSpriteDepth ( BlackBG, 2 )
		SetSpriteOffset( BlackBG, (GetSpriteWidth(BlackBG)/2) , (GetSpriteHeight(BlackBG)/2) ) 
		SetSpritePositionByOffset( BlackBG, ScreenWidth/2, ScreenHeight/2 )
		SetSpriteColorAlpha( BlackBG, 0)

		NextScreenToDisplay = PlayingScreen

		if MusicVolume > 0 or EffectsVolume > 0
			CreateIcon(1, 18, 18 )
		else
			CreateIcon(0, 18, 18 )
		endif

		LivesText = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 18, 255, 255, 255, 255, 0, 0, 0, 1, (100), 18, 3)
		SetTextStringOutlined ( LivesText, "Lives("+str(Lives)+")Lives" )

		CreateIcon(5, (ScreenWidth/2), 18 )

		LevelText = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 18, 255, 255, 255, 255, 0, 0, 0, 1, (ScreenWidth-100), 18, 3)
		SetTextStringOutlined ( LevelText, "Level("+str(Level)+")Level" )

		CreateIcon(4, (ScreenWidth-18), 18 )

		BonusText = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, (ScreenWidth/2), 75-25, 3)
		SetTextStringOutlined ( BonusText, "Bonus("+str(Bonus)+")Bonus" )

		ScoreText = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 35, 255, 255, 255, 255, 0, 0, 0, 1, (ScreenWidth/2), 75+4, 3)
		SetTextStringOutlined ( ScoreText, str(Score) )

		LoadImage ( 299979, "\media\images\backgrounds\GamePaused.png" )
		GamePausedSprite = CreateSprite ( 299979 )
		SetSpriteDepth ( GamePausedSprite, 2 )
		SetSpriteOffset( GamePausedSprite, (GetSpriteWidth(GamePausedSprite)/2) , (GetSpriteHeight(GamePausedSprite)/2) ) 
		SetSpritePositionByOffset( GamePausedSprite, -9999, -9999 )
		SetSpriteTransparency(GamePausedSprite, 0) 
		SetSpriteColorAlpha(GamePausedSprite, 0)

		PixelBG = CreateSprite ( 299980 )
		SetSpriteDepth ( PixelBG, 5 )
		SetSpriteOffset( PixelBG, (GetSpriteWidth(PixelBG)/2) , (GetSpriteHeight(PixelBG)/2) )
		SetSpritePositionByOffset( PixelBG, -9999, -9999 )
		SetSpriteColorAlpha(PixelBG, 255)

		LoadImage ( 81111, "\media\images\gui\Match-Left.png" )
		MatchLeft = CreateSprite ( 81111 )
		SetSpriteDepth ( MatchLeft, 4 )
		SetSpriteOffset( MatchLeft, (GetSpriteWidth(MatchLeft)/2) , (GetSpriteHeight(MatchLeft)/2) )
		SetSpritePositionByOffset( MatchLeft, 54, 216 )

		LoadImage ( 81112, "\media\images\gui\Match-Right.png" )
		MatchRight = CreateSprite ( 81112 )
		SetSpriteDepth ( MatchRight, 4 )
		SetSpriteOffset( MatchRight, (GetSpriteWidth(MatchRight)/2) , (GetSpriteHeight(MatchRight)/2) )
		SetSpritePositionByOffset( MatchRight, 304, 216 )

		direction as integer
		for direction = 1 to 12
			PlayfieldMove[direction] = CreateSprite ( 299990 )
			SetSpriteDepth ( PlayfieldMove[direction], 4 )
			SetSpriteOffset( PlayfieldMove[direction], (GetSpriteWidth(PlayfieldMove[direction])/2) , (GetSpriteHeight(PlayfieldMove[direction])/2) ) 
			SetSpritePositionByOffset( PlayfieldMove[direction], -9999, -9999 )
			SetSpriteColorAlpha(PlayfieldMove[direction], 0)
		next direction

		for index = 0 to 12
			PolygonActive[index] = FALSE
			PolygonPlayfieldX[index] = -9999
			PolygonPlayfieldY[index] = -9999
			PolygonScreenX[index] = -9999
			PolygonScreenY[index] = -9999
			PolygonDirection[index] = JoyCENTER
			PolygonStep[index] = 0
			PolygonScaleDirection[index] = -1
			PolygonScale[index] = 1
			PolygonTransparency[index] = 0
			
			PolygonSpriteHorizontal[index, 0] = CreateSprite ( 700000 )
			SetSpriteDepth ( PolygonSpriteHorizontal[index, 0], 4 )
			SetSpriteOffset( PolygonSpriteHorizontal[index, 0], (GetSpriteWidth(PolygonSpriteHorizontal[index, 0])/2) , (GetSpriteHeight(PolygonSpriteHorizontal[index, 0])/2) ) 
			SetSpritePositionByOffset( PolygonSpriteHorizontal[index, 0], -9999, -9999 )
			SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 0], PolygonScale[index], PolygonScale[index])
			SetSpriteColorAlpha(PolygonSpriteHorizontal[index, 0], PolygonTransparency[index])
				
			PolygonSpriteHorizontal[index, 1] = CreateSprite ( 700001 )
			SetSpriteDepth ( PolygonSpriteHorizontal[index, 1], 4 )
			SetSpriteOffset( PolygonSpriteHorizontal[index, 1], (GetSpriteWidth(PolygonSpriteHorizontal[index, 1])/2) , (GetSpriteHeight(PolygonSpriteHorizontal[index, 1])/2) ) 
			SetSpritePositionByOffset( PolygonSpriteHorizontal[index, 1], -9999, -9999 )
			SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 1], PolygonScale[index], PolygonScale[index])
			SetSpriteColorAlpha(PolygonSpriteHorizontal[index, 1], PolygonTransparency[index])
			
			PolygonSpriteHorizontal[index, 2] = CreateSprite ( 700002 )
			SetSpriteDepth ( PolygonSpriteHorizontal[index, 2], 4 )
			SetSpriteOffset( PolygonSpriteHorizontal[index, 2], (GetSpriteWidth(PolygonSpriteHorizontal[index, 2])/2) , (GetSpriteHeight(PolygonSpriteHorizontal[index, 2])/2) ) 
			SetSpritePositionByOffset( PolygonSpriteHorizontal[index, 2], -9999, -9999 )
			SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 2], PolygonScale[index], PolygonScale[index])
			SetSpriteColorAlpha(PolygonSpriteHorizontal[index, 2], PolygonTransparency[index])
			
			PolygonSpriteHorizontal[index, 3] = CreateSprite ( 700003 )
			SetSpriteDepth ( PolygonSpriteHorizontal[index, 3], 4 )
			SetSpriteOffset( PolygonSpriteHorizontal[index, 3], (GetSpriteWidth(PolygonSpriteHorizontal[index, 3])/2) , (GetSpriteHeight(PolygonSpriteHorizontal[index, 3])/2) ) 
			SetSpritePositionByOffset( PolygonSpriteHorizontal[index, 3], -9999, -9999 )
			SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 3], PolygonScale[index], PolygonScale[index])
			SetSpriteColorAlpha(PolygonSpriteHorizontal[index, 3], PolygonTransparency[index])
			
			PolygonSpriteHorizontal[index, 4] = CreateSprite ( 700000 )
			SetSpriteDepth ( PolygonSpriteHorizontal[index, 4], 4 )
			SetSpriteOffset( PolygonSpriteHorizontal[index, 4], (GetSpriteWidth(PolygonSpriteHorizontal[index, 4])/2) , (GetSpriteHeight(PolygonSpriteHorizontal[index, 4])/2) ) 
			SetSpritePositionByOffset( PolygonSpriteHorizontal[index, 4], -9999, -9999 )
			SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 4], PolygonScale[index], PolygonScale[index])
			SetSpriteColorAlpha(PolygonSpriteHorizontal[index, 4], PolygonTransparency[index])

			PolygonSpriteVertical[index, 0] = CreateSprite ( 700000 )
			SetSpriteDepth ( PolygonSpriteVertical[index, 0], 4 )
			SetSpriteOffset( PolygonSpriteVertical[index, 0], (GetSpriteWidth(PolygonSpriteVertical[index, 0])/2) , (GetSpriteHeight(PolygonSpriteVertical[index, 0])/2) ) 
			SetSpritePositionByOffset( PolygonSpriteVertical[index, 0], -9999, -9999 )
			SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 0], PolygonScale[index], PolygonScale[index])
			SetSpriteColorAlpha(PolygonSpriteVertical[index, 0], PolygonTransparency[index])
			
			PolygonSpriteVertical[index, 1] = CreateSprite ( 700004 )
			SetSpriteDepth ( PolygonSpriteVertical[index, 1], 4 )
			SetSpriteOffset( PolygonSpriteVertical[index, 1], (GetSpriteWidth(PolygonSpriteVertical[index, 1])/2) , (GetSpriteHeight(PolygonSpriteVertical[index, 1])/2) ) 
			SetSpritePositionByOffset( PolygonSpriteVertical[index, 1], -9999, -9999 )
			SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 1], PolygonScale[index], PolygonScale[index])
			SetSpriteColorAlpha(PolygonSpriteVertical[index, 1], PolygonTransparency[index])
			
			PolygonSpriteVertical[index, 2] = CreateSprite ( 700005 )
			SetSpriteDepth ( PolygonSpriteVertical[index, 2], 4 )
			SetSpriteOffset( PolygonSpriteVertical[index, 2], (GetSpriteWidth(PolygonSpriteVertical[index, 2])/2) , (GetSpriteHeight(PolygonSpriteVertical[index, 2])/2) ) 
			SetSpritePositionByOffset( PolygonSpriteVertical[index, 2], -9999, -9999 )
			SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 2], PolygonScale[index], PolygonScale[index])
			SetSpriteColorAlpha(PolygonSpriteVertical[index, 2], PolygonTransparency[index])
			
			PolygonSpriteVertical[index, 3] = CreateSprite ( 700006 )
			SetSpriteDepth ( PolygonSpriteVertical[index, 3], 4 )
			SetSpriteOffset( PolygonSpriteVertical[index, 3], (GetSpriteWidth(PolygonSpriteVertical[index, 3])/2) , (GetSpriteHeight(PolygonSpriteVertical[index, 3])/2) ) 
			SetSpritePositionByOffset( PolygonSpriteVertical[index, 3], -9999, -9999 )
			SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 3], PolygonScale[index], PolygonScale[index])
			SetSpriteColorAlpha(PolygonSpriteVertical[index, 3], PolygonTransparency[index])
			
			PolygonSpriteVertical[index, 4] = CreateSprite ( 700000 )
			SetSpriteDepth ( PolygonSpriteVertical[index, 4], 4 )
			SetSpriteOffset( PolygonSpriteVertical[index, 4], (GetSpriteWidth(PolygonSpriteVertical[index, 0])/2) , (GetSpriteHeight(PolygonSpriteVertical[index, 4])/2) ) 
			SetSpritePositionByOffset( PolygonSpriteVertical[index, 4], -9999, -9999 )
			SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 4], PolygonScale[index], PolygonScale[index])
			SetSpriteColorAlpha(PolygonSpriteVertical[index, 4], PolygonTransparency[index])
		next index

		SetSpritePositionByOffset( PixelBG, (ScreenWidth/2), (ScreenHeight/2) )
	
		LoadImage ( 300000, "\media\images\pixels\Player.png" )
		LoadImage ( 300001, "\media\images\pixels\SquareWhite.png" )
		LoadImage ( 300002, "\media\images\pixels\SquareRed.png" )
		LoadImage ( 300003, "\media\images\pixels\SquareOrange.png" )
		LoadImage ( 300004, "\media\images\pixels\SquareYellow.png" )
		LoadImage ( 300005, "\media\images\pixels\SquareGreen.png" )
		LoadImage ( 300006, "\media\images\pixels\SquareBlue.png" )
		LoadImage ( 300007, "\media\images\pixels\SquarePurple.png" )
		LoadImage ( 300008, "\media\images\pixels\SquareBlack.png" )
		LoadImage ( 300010, "\media\images\map\MapPlayer.png" )
		LoadImage ( 300011, "\media\images\map\MapSquareWhite.png" )
		LoadImage ( 300012, "\media\images\map\MapSquareRed.png" )
		LoadImage ( 300013, "\media\images\map\MapSquareOrange.png" )
		LoadImage ( 300014, "\media\images\map\MapSquareYellow.png" )
		LoadImage ( 300015, "\media\images\map\MapSquareGreen.png" )
		LoadImage ( 300016, "\media\images\map\MapSquareBlue.png" )
		LoadImage ( 300017, "\media\images\map\MapSquarePurple.png" )
		LoadImage ( 300018, "\media\images\map\MapSquareBlack.png" )

		ActivePixels as integer[9, 50]
		colorIndex as integer[9]
		for indexX = 0 to 8
			colorIndex[indexX] = 0
			
			for indexY = 0 to 49
				ActivePixels[indexX, indexY] = -1
			next indexY
		next indexX
				
		for indexY = 0 to 6
			for indexX = 0 to 6
				if Playfield[ indexX, indexY] = 0
					ActivePixels[ 0, colorIndex[0] ] = 0
					inc colorIndex[0], 1
				elseif Playfield[ indexX, indexY] = 1
					ActivePixels[ 1, colorIndex[1] ] = 1
					inc colorIndex[1], 1
				elseif Playfield[ indexX, indexY] = 2
					ActivePixels[ 2, colorIndex[2] ] = 2
					inc colorIndex[2], 1
				elseif Playfield[ indexX, indexY] = 3
					ActivePixels[ 3, colorIndex[3] ] = 3
					inc colorIndex[3], 1
				elseif Playfield[ indexX, indexY] = 4
					ActivePixels[ 4, colorIndex[4] ] = 4
					inc colorIndex[4], 1
				elseif Playfield[ indexX, indexY] = 5
					ActivePixels[ 5, colorIndex[5] ] = 5
					inc colorIndex[5], 1
				elseif Playfield[ indexX, indexY] = 6
					ActivePixels[ 6, colorIndex[6] ] = 6
					inc colorIndex[6], 1
				elseif Playfield[ indexX, indexY] = 7
					ActivePixels[ 7, colorIndex[7] ] = 7
					inc colorIndex[7], 1
				elseif Playfield[ indexX, indexY] = 8
					ActivePixels[ 8, colorIndex[8] ] = 8
					inc colorIndex[8], 1
				endif
			next indexX
		next indexY

		for color = 0 to 8
			for duplicateIndex = 0 to 49
				if (ActivePixels[color, duplicateIndex] > -1)
					PlayfieldPixels[color, duplicateIndex] = CreateSprite ( 300000+color )
					SetSpriteDepth ( PlayfieldPixels[color, duplicateIndex], 5 )
					SetSpriteOffset( PlayfieldPixels[color, duplicateIndex], (GetSpriteWidth(PlayfieldPixels[color, duplicateIndex])/2) , (GetSpriteHeight(PlayfieldPixels[color, duplicateIndex])/2) ) 
					SetSpritePositionByOffset( PlayfieldPixels[color, duplicateIndex], -9999, -9999 )
					SetSpriteTransparency(PlayfieldPixels[color, duplicateIndex], 0) 
					SetSpriteColorAlpha(PlayfieldPixels[color, duplicateIndex], 0)

					MapPixels[color, duplicateIndex] = CreateSprite ( 300010+color )
					SetSpriteDepth ( MapPixels[color, duplicateIndex], 5 )
					SetSpriteOffset( MapPixels[color, duplicateIndex], (GetSpriteWidth(MapPixels[color, duplicateIndex])/2) , (GetSpriteHeight(MapPixels[color, duplicateIndex])/2) ) 
					SetSpritePositionByOffset( MapPixels[color, duplicateIndex], -9999, -9999 )
					SetSpriteTransparency(MapPixels[color, duplicateIndex], 0) 
					SetSpriteColorAlpha(MapPixels[color, duplicateIndex], 0)
				endif
			next duplicateIndex
		next color
	
		color as integer
		for color = 0 to 8
			PlayfieldPixelsNext[color] = 0
			MapPixelsNext[color] = 0
		next color

		screenY as integer
		screenY = 106+14
		screenX as integer
		screenX = 107
		indexY as integer
		indexX as integer
		for indexY = 0 to 6
			for indexX = 0 to 6
				if PlayfieldMap[ indexX, indexY] = 0
					SetSpritePositionByOffset( MapPixels[0, MapPixelsNext[0]], screenX, screenY )
					SetSpriteColorAlpha(MapPixels[0, MapPixelsNext[0]], 255)
					inc MapPixelsNext[0], 1
				elseif PlayfieldMap[ indexX, indexY] = 1
					SetSpritePositionByOffset( MapPixels[1, MapPixelsNext[1]], screenX, screenY )
					SetSpriteColorAlpha(MapPixels[1, MapPixelsNext[1]], 255)
					inc MapPixelsNext[1], 1
				elseif PlayfieldMap[ indexX, indexY] = 2
					SetSpritePositionByOffset( MapPixels[2, MapPixelsNext[2]], screenX, screenY )
					SetSpriteColorAlpha(MapPixels[2, MapPixelsNext[2]], 255)
					inc MapPixelsNext[2], 1
				elseif PlayfieldMap[ indexX, indexY] = 3
					SetSpritePositionByOffset( MapPixels[3, MapPixelsNext[3]], screenX, screenY )
					SetSpriteColorAlpha(MapPixels[3, MapPixelsNext[3]], 255)
						inc MapPixelsNext[3], 1
				elseif PlayfieldMap[ indexX, indexY] = 4
					SetSpritePositionByOffset( MapPixels[4, MapPixelsNext[4]], screenX, screenY )
					SetSpriteColorAlpha(MapPixels[4, MapPixelsNext[4]], 255)
					inc MapPixelsNext[4], 1
				elseif PlayfieldMap[ indexX, indexY] = 5
					SetSpritePositionByOffset( MapPixels[5, MapPixelsNext[5]], screenX, screenY )
					SetSpriteColorAlpha(MapPixels[5, MapPixelsNext[5]], 255)
					inc MapPixelsNext[5], 1
				elseif PlayfieldMap[ indexX, indexY] = 6
					SetSpritePositionByOffset( MapPixels[6, MapPixelsNext[6]], screenX, screenY )
					SetSpriteColorAlpha(MapPixels[6, MapPixelsNext[6]], 255)
					inc MapPixelsNext[6], 1
				elseif PlayfieldMap[ indexX, indexY] = 7
					SetSpritePositionByOffset( MapPixels[7, MapPixelsNext[7]], screenX, screenY )
					SetSpriteColorAlpha(MapPixels[7, MapPixelsNext[7]], 255)
					inc MapPixelsNext[7], 1
				elseif PlayfieldMap[ indexX, indexY] = 8
					SetSpritePositionByOffset( MapPixels[8, MapPixelsNext[8]], screenX, screenY )
					SetSpriteColorAlpha(MapPixels[8, MapPixelsNext[8]], 255)
					inc MapPixelsNext[8], 1
				endif

				inc screenY, 24
			next indexX
			
			inc screenX, 24
			screenY = 106+14
		next indexY

		PlayerPosX = 3
		PlayerPosY = 3
		for indexY = 0 to 6
			for indexX = 0 to 6
				if Playfield[ indexX, indexY] = 0
					PlayerPosX = indexX
					PlayerPosY = indexY
				endif
			next indexX
		next indexY

		screenY = 300+7
		screenX = 30
		for indexY = 0 to 6
			for indexX = 0 to 6
				BlockedText[indexX, indexY] = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 30, 0, 0, 0, 255, 0, 0, 0, 1, screenX, screenY, 3)
				inc screenY, 50
			next indexX
			
			inc screenX, 50
			screenY = 300+7
		next indexY
		
		PlayfieldChangedSoDrawIt = TRUE
	endif

	if ThisIconWasPressed(0) = TRUE
		if MusicVolume > 0 or EffectsVolume > 0
			SetSpriteColorAlpha(Icon[IconSprite[0]], 0)
			IconSprite[0] = 0
			SetSpriteColorAlpha(Icon[IconSprite[0]], 255)
			MusicVolume = 0
			EffectsVolume = 0
			SetVolumeOfAllMusicAndSoundEffects()
			GUIchanged = TRUE
		else
			SetSpriteColorAlpha(Icon[IconSprite[0]], 0)
			IconSprite[0] = 1
			SetSpriteColorAlpha(Icon[IconSprite[0]], 255)
			MusicVolume = 100
			EffectsVolume = 100
			SetVolumeOfAllMusicAndSoundEffects()
			GUIchanged = TRUE
		endif
	elseif ThisIconWasPressed(1) = TRUE
		if PauseGame = FALSE
			PauseMusicOGG( MusicTrack[CurrentlyPlayingMusicIndex] ) 
			SetSpriteColorAlpha(Icon[IconSprite[1]], 0)
			IconSprite[1] = 6
			SetSpriteColorAlpha(Icon[IconSprite[1]], 255)
			SetSpriteColorAlpha(GamePausedSprite, 222)
			if (SecretCodeCombined <> 9876) then SetSpritePositionByOffset( GamePausedSprite, ScreenWidth/2, ScreenHeight/2 )
			PauseGame = TRUE
			GUIchanged = TRUE

			SetSpriteDepth ( Icon[0], 1 )
			SetSpriteDepth ( Icon[1], 1 )
			SetSpriteDepth ( Icon[2], 1 )
			SetSpriteDepth ( Icon[3], 1 )
			SetSpriteDepth ( Icon[4], 1 )
			SetSpriteDepth ( Icon[5], 1 )
			SetSpriteDepth ( Icon[6], 1 )
		elseif PauseGame = TRUE
			ResumeMusicOGG( MusicTrack[CurrentlyPlayingMusicIndex] ) 
			SetSpriteColorAlpha(Icon[IconSprite[1]], 0)
			IconSprite[1] = 5
			SetSpriteColorAlpha(Icon[IconSprite[1]], 255)
			SetSpriteColorAlpha(GamePausedSprite, 0)
			SetSpritePositionByOffset( GamePausedSprite, -9999, -9999 )
			PauseGame = FALSE
			GUIchanged = TRUE

			SetSpriteDepth ( Icon[0], 3 )
			SetSpriteDepth ( Icon[1], 3 )
			SetSpriteDepth ( Icon[2], 3 )
			SetSpriteDepth ( Icon[3], 3 )
			SetSpriteDepth ( Icon[4], 3 )
			SetSpriteDepth ( Icon[5], 3 )
			SetSpriteDepth ( Icon[6], 3 )
		endif
		
		DelayAllUserInput = 20
	elseif ThisIconWasPressed(2) = TRUE
		DelayAllUserInput = 20
		PlayNewMusic(0, 1)
		NextScreenToDisplay = TitleScreen
		if ScreenToDisplay = PlayingScreen
			GameOver = 1
			Score = 0
			QuitPlaying = TRUE
		endif
		ScreenFadeStatus = FadingToBlack
	endif

	if LastKeyboardChar = 32
		if PauseGame = FALSE
			PauseMusicOGG( MusicTrack[CurrentlyPlayingMusicIndex] ) 
			SetSpriteColorAlpha(Icon[IconSprite[1]], 0)
			IconSprite[1] = 6
			SetSpriteColorAlpha(Icon[IconSprite[1]], 255)
			SetSpriteColorAlpha(GamePausedSprite, 222)
			if (SecretCodeCombined <> 9876) then SetSpritePositionByOffset( GamePausedSprite, ScreenWidth/2, ScreenHeight/2 )
			PauseGame = TRUE
		elseif PauseGame = TRUE
			ResumeMusicOGG( MusicTrack[CurrentlyPlayingMusicIndex] ) 
			SetSpriteColorAlpha(Icon[IconSprite[1]], 0)
			IconSprite[1] = 5
			SetSpriteColorAlpha(Icon[IconSprite[1]], 255)
			SetSpriteColorAlpha(GamePausedSprite, 0)
			SetSpritePositionByOffset( GamePausedSprite, -9999, -9999 )
			PauseGame = FALSE
		endif
		
		PlaySound(1)
		DelayAllUserInput = 20
	endif

	for color = 0 to 8
		PlayfieldPixelsNext[color] = 0
	next color

	PlayerPosX = 3
	PlayerPosY = 3
	for indexY = 0 to 6
		for indexX = 0 to 6
			if Playfield[ indexX, indexY] = 0
				PlayerPosX = indexX
				PlayerPosY = indexY
			endif
		next indexX
	next indexY

	PlayfieldMoveNext = 1

	for indexY = 0 to 6
		for indexX = 0 to 6
			SetTextStringOutlined ( BlockedText[indexX, indexY], " " )
		
			if ( PlayfieldBlocked[ indexX, indexY ] > 0 and (SecretCodeCombined = 2777) ) then SetTextStringOutlined ( BlockedText[indexX, indexY], str(PlayfieldBlocked[ indexX, indexY ]) )
		next indexX
	next indexY

	if PlayfieldChangedSoDrawIt = TRUE
		SetSpritePositionByOffset( PlayfieldMove[1], -9999, -9999 )
		SetSpritePositionByOffset( PlayfieldMove[2], -9999, -9999 )
		SetSpritePositionByOffset( PlayfieldMove[3], -9999, -9999 )
		SetSpritePositionByOffset( PlayfieldMove[4], -9999, -9999 )

		screenY = 300+7
		screenX = 30
		for indexY = 0 to 6
			for indexX = 0 to 6
				select Playfield[ indexX, indexY]
					case 0:
						SetSpritePositionByOffset( PlayfieldPixels[0, PlayfieldPixelsNext[0]], screenX, screenY )
						SetSpriteColorAlpha(PlayfieldPixels[0, PlayfieldPixelsNext[0]], 255)
						inc PlayfieldPixelsNext[0], 1
					endcase
					case 1:
						SetSpritePositionByOffset( PlayfieldPixels[1, PlayfieldPixelsNext[1]], screenX, screenY )
						SetSpriteColorAlpha(PlayfieldPixels[1, PlayfieldPixelsNext[1]], 255)
						inc PlayfieldPixelsNext[1], 1
					endcase
					case 2:
						SetSpritePositionByOffset( PlayfieldPixels[2, PlayfieldPixelsNext[2]], screenX, screenY )
						SetSpriteColorAlpha(PlayfieldPixels[2, PlayfieldPixelsNext[2]], 255)
						inc PlayfieldPixelsNext[2], 1
					endcase
					case 3:
						SetSpritePositionByOffset( PlayfieldPixels[3, PlayfieldPixelsNext[3]], screenX, screenY )
						SetSpriteColorAlpha(PlayfieldPixels[3, PlayfieldPixelsNext[3]], 255)
						inc PlayfieldPixelsNext[3], 1
					endcase
					case 4:
						SetSpritePositionByOffset( PlayfieldPixels[4, PlayfieldPixelsNext[4]], screenX, screenY )
						SetSpriteColorAlpha(PlayfieldPixels[4, PlayfieldPixelsNext[4]], 255)
						inc PlayfieldPixelsNext[4], 1
					endcase
					case 5:
						SetSpritePositionByOffset( PlayfieldPixels[5, PlayfieldPixelsNext[5]], screenX, screenY )
						SetSpriteColorAlpha(PlayfieldPixels[5, PlayfieldPixelsNext[5]], 255)
						inc PlayfieldPixelsNext[5], 1
					endcase
					case 6:
						SetSpritePositionByOffset( PlayfieldPixels[6, PlayfieldPixelsNext[6]], screenX, screenY )
						SetSpriteColorAlpha(PlayfieldPixels[6, PlayfieldPixelsNext[6]], 255)
						inc PlayfieldPixelsNext[6], 1
					endcase
					case 7:
						SetSpritePositionByOffset( PlayfieldPixels[7, PlayfieldPixelsNext[7]], screenX, screenY )
						SetSpriteColorAlpha(PlayfieldPixels[7, PlayfieldPixelsNext[7]], 255)
						inc PlayfieldPixelsNext[7], 1
					endcase
					case 8:
						SetSpritePositionByOffset( PlayfieldPixels[8, PlayfieldPixelsNext[8]], screenX, screenY )
						SetSpriteColorAlpha(PlayfieldPixels[8, PlayfieldPixelsNext[8]], 255)
						inc PlayfieldPixelsNext[8], 1
					endcase
				endselect

				if (PlayerPosX = indexX or PlayerPosY = indexY)
					if (PlayerPosX = indexX and PlayerPosY = indexY)
								
					else
						SetSpritePositionByOffset( PlayfieldMove[PlayfieldMoveNext], screenX, screenY )
						SetSpriteColorAlpha(PlayfieldMove[PlayfieldMoveNext], 100)
						inc PlayfieldMoveNext, 1
					endif
				endif
				inc screenY, 50
				next indexX
				
				inc screenX, 50
				screenY = 300+7
			next indexY
		
		PlayfieldChangedSoDrawIt = FALSE
	endif

	if DisablePolygonDraws = FALSE
		fixAnimation as integer
		screenY = 300+7
		screenX = 30
		for indexY = 0 to 6
			for indexX = 0 to 6
				index as integer
				for index = 0 to 12
					if PolygonActive[index] = TRUE
						if PolygonPlayfieldX[index] = indexX and PolygonPlayfieldY[index] = indexY
							if PolygonDirection[index] = JoyUP
								if PolygonScaleDirection[index] = 0 or PolygonScaleDirection[index] = 1 or PolygonScaleDirection[index] = 2
									ClearSinglePolygonSprites(index)
									
									PolygonScreenX[index] = screenX
									PolygonScreenY[index] = screenY
									if PolygonStep[index] < 4
										dec PolygonScreenY[index], (PolygonStep[index]*(64/4))
									else
										dec PolygonScreenY[index], 64-14
									endif

									fixAnimation = PolygonStep[index]
									if PolygonStep[index] = 1
										fixAnimation = 3
									elseif PolygonStep[index] = 3
										fixAnimation = 1
									elseif PolygonStep[index] = 4
										fixAnimation = 0
									endif
									
									SetSpritePositionByOffset( PolygonSpriteVertical[index, fixAnimation], PolygonScreenX[index], PolygonScreenY[index] )
									SetSpriteScaleByOffset( PolygonSpriteVertical[index, fixAnimation], PolygonScale[index], PolygonScale[index])
									SetSpriteColorAlpha(PolygonSpriteVertical[index, fixAnimation], PolygonTransparency[index])
									if PolygonScale[index] > 0 then SetSpriteDepth(PolygonSpriteVertical[index, 0], 4)
								endif							
							elseif PolygonDirection[index] = JoyDOWN
								if PolygonScaleDirection[index] = 0 or PolygonScaleDirection[index] = 1 or PolygonScaleDirection[index] = 2
									ClearSinglePolygonSprites(index)

									fixAnimation = PolygonStep[index]
									if PolygonStep[index] = 4
										fixAnimation = 0
									endif
									
									PolygonScreenX[index] = screenX
									PolygonScreenY[index] = screenY
									if PolygonStep[index] < 4
										inc PolygonScreenY[index], (fixAnimation*(64/4))
									else
										inc PolygonScreenY[index], 64-14
									endif
									
									SetSpritePositionByOffset( PolygonSpriteVertical[index, fixAnimation], PolygonScreenX[index], PolygonScreenY[index] )
									SetSpriteScaleByOffset( PolygonSpriteVertical[index, fixAnimation], PolygonScale[index], PolygonScale[index])
									SetSpriteColorAlpha(PolygonSpriteVertical[index, fixAnimation], PolygonTransparency[index])
									if PolygonScale[index] > 0 then SetSpriteDepth(PolygonSpriteVertical[index, 0], 4)
								endif
							elseif PolygonDirection[index] = JoyLEFT
								if PolygonScaleDirection[index] = 0 or PolygonScaleDirection[index] = 1 or PolygonScaleDirection[index] = 2
									ClearSinglePolygonSprites(index)
									
									PolygonScreenX[index] = screenX
									PolygonScreenY[index] = screenY
									if PolygonStep[index] < 4
										dec PolygonScreenX[index], (PolygonStep[index]*(64/4))
									else
										dec PolygonScreenX[index], 64-14
									endif

									fixAnimation = PolygonStep[index]
									if PolygonStep[index] = 1
										fixAnimation = 3
									elseif PolygonStep[index] = 3
										fixAnimation = 1
									elseif PolygonStep[index] = 4
										fixAnimation = 0
									endif
									
									SetSpritePositionByOffset( PolygonSpriteHorizontal[index, fixAnimation], PolygonScreenX[index], PolygonScreenY[index] )
									SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, fixAnimation], PolygonScale[index], PolygonScale[index])
									SetSpriteColorAlpha(PolygonSpriteHorizontal[index, fixAnimation], PolygonTransparency[index])
									if PolygonScale[index] > 0 then SetSpriteDepth(PolygonSpriteHorizontal[index, 0], 4)
								endif
							elseif PolygonDirection[index] = JoyRIGHT
								if PolygonScaleDirection[index] = 0 or PolygonScaleDirection[index] = 1 or PolygonScaleDirection[index] = 2
									ClearSinglePolygonSprites(index)

									fixAnimation = PolygonStep[index]
									if PolygonStep[index] = 4
										fixAnimation = 0
									endif

									PolygonScreenX[index] = screenX
									PolygonScreenY[index] = screenY
									if PolygonStep[index] < 4
										inc PolygonScreenX[index], (fixAnimation*(64/4))
									else
										inc PolygonScreenX[index], 64-14
									endif
									
									SetSpritePositionByOffset( PolygonSpriteHorizontal[index, fixAnimation], PolygonScreenX[index], PolygonScreenY[index] )
									SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, fixAnimation], PolygonScale[index], PolygonScale[index])
									SetSpriteColorAlpha(PolygonSpriteHorizontal[index, fixAnimation], PolygonTransparency[index])
									if PolygonScale[index] > 0 then SetSpriteDepth(PolygonSpriteHorizontal[index, 0], 4)
								endif
							endif
						endif
					endif
				next index


				inc screenY, 50
			next indexX
			
			inc screenX, 50
			screenY = 300+7
		next indexY
	endif

	SetTextStringOutlined ( BonusText, "Bonus("+str(Bonus)+")Bonus" )

	if PauseGame = FALSE and ScreenFadeStatus = FadingIdle then RunGamePlayCore()

	AnimateStaticBG()

	if GameOver = 100
		SetSpriteColorAlpha( BlackBG, 200)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "GAME OVER", 999, 63, 255, 255, 255, 255, 0, 0, 0, 1, (ScreenWidth/2), (ScreenHeight/2)-3, 1 )
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "GAME OVER", 999, 63, 255, 255, 255, 255, 0, 0, 0, 1, (ScreenWidth/2), (ScreenHeight/2)+3, 1 )
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "GAME OVER", 999, 63, 255, 255, 255, 255, 0, 0, 0, 1, (ScreenWidth/2), (ScreenHeight/2), 1 )
	endif

	if FadingToBlackCompleted = TRUE
		DeleteSprite(TitleBG)
		
		DeleteSprite(BlackBG)		
		
		SetSpritePositionByOffset( PixelBG, -9999, -9999 )

		for index = 300000 to 300018
			DeleteImage(index)
		next index
		
		duplicateIndex as integer
		for color = 0 to 8
			for duplicateIndex = 0 to 49
					DeleteSprite(PlayfieldPixels[color, duplicateIndex])
					DeleteSprite(MapPixels[color, duplicateIndex])
			next duplicateIndex
		next color

		for direction = 1 to 12
			SetSpritePositionByOffset( PlayfieldMove[direction], -9999, -9999 )
			SetSpriteColorAlpha(PlayfieldMove[direction], 0)
		next direction

		for color = 0 to 8
			PlayfieldPixelsNext[color] = 0
			MapPixelsNext[color] = 0
		next color

		for index = 0 to 12
			PolygonActive[index] = FALSE
			PolygonPlayfieldX[index] = -9999
			PolygonPlayfieldY[index] = -9999
			PolygonScreenX[index] = -9999
			PolygonScreenY[index] = -9999
			PolygonDirection[index] = JoyCENTER
			PolygonStep[index] = 0
			PolygonScaleDirection[index] = -1
			PolygonScale[index] = 1
			PolygonTransparency[index] = 0
			
			if ( GetSpriteExists(PolygonSpriteHorizontal[index, 0]) )
				SetSpritePositionByOffset( PolygonSpriteHorizontal[index, 0], -9999, -9999 )
				SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 0], PolygonScale[index], PolygonScale[index])
				SetSpriteColorAlpha(PolygonSpriteHorizontal[index, 0], PolygonTransparency[index])
			endif
			
			if ( GetSpriteExists(PolygonSpriteHorizontal[index, 1]) )
				SetSpritePositionByOffset( PolygonSpriteHorizontal[index, 1], -9999, -9999 )
				SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 1], PolygonScale[index], PolygonScale[index])
				SetSpriteColorAlpha(PolygonSpriteHorizontal[index, 1], PolygonTransparency[index])
			endif
				
			if ( GetSpriteExists(PolygonSpriteHorizontal[index, 2]) )
				SetSpritePositionByOffset( PolygonSpriteHorizontal[index, 2], -9999, -9999 )
				SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 2], PolygonScale[index], PolygonScale[index])
				SetSpriteColorAlpha(PolygonSpriteHorizontal[index, 2], PolygonTransparency[index])
			endif				
				
			if ( GetSpriteExists(PolygonSpriteHorizontal[index, 3]) )
				SetSpritePositionByOffset( PolygonSpriteHorizontal[index, 3], -9999, -9999 )
				SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 3], PolygonScale[index], PolygonScale[index])
				SetSpriteColorAlpha(PolygonSpriteHorizontal[index, 3], PolygonTransparency[index])
			endif
								
			if ( GetSpriteExists(PolygonSpriteHorizontal[index, 4]) )
				SetSpritePositionByOffset( PolygonSpriteHorizontal[index, 4], -9999, -9999 )
				SetSpriteScaleByOffset( PolygonSpriteHorizontal[index, 4], PolygonScale[index], PolygonScale[index])
				SetSpriteColorAlpha(PolygonSpriteHorizontal[index, 4], PolygonTransparency[index])
			endif

			if ( GetSpriteExists(PolygonSpriteVertical[index, 0]) )
				SetSpritePositionByOffset( PolygonSpriteVertical[index, 0], -9999, -9999 )
				SetSpriteScaleByOffset( PolygonSpriteVertical[index, 0], PolygonScale[index], PolygonScale[index])
				SetSpriteColorAlpha(PolygonSpriteVertical[index, 0], PolygonTransparency[index])
			endif
				
			if ( GetSpriteExists(PolygonSpriteVertical[index, 1]) )
				SetSpritePositionByOffset( PolygonSpriteVertical[index, 1], -9999, -9999 )
				SetSpriteScaleByOffset( PolygonSpriteVertical[index, 1], PolygonScale[index], PolygonScale[index])
				SetSpriteColorAlpha(PolygonSpriteVertical[index, 1], PolygonTransparency[index])
			endif
				
			if ( GetSpriteExists(PolygonSpriteVertical[index, 2]) )
				SetSpritePositionByOffset( PolygonSpriteVertical[index, 2], -9999, -9999 )
				SetSpriteScaleByOffset( PolygonSpriteVertical[index, 2], PolygonScale[index], PolygonScale[index])
				SetSpriteColorAlpha(PolygonSpriteVertical[index, 2], PolygonTransparency[index])
			endif
				
			if ( GetSpriteExists(PolygonSpriteVertical[index, 3]) )
				SetSpritePositionByOffset( PolygonSpriteVertical[index, 3], -9999, -9999 )
				SetSpriteScaleByOffset( PolygonSpriteVertical[index, 3], PolygonScale[index], PolygonScale[index])
				SetSpriteColorAlpha(PolygonSpriteVertical[index, 3], PolygonTransparency[index])
			endif
				
			if ( GetSpriteExists(PolygonSpriteVertical[index, 4]) )
				SetSpritePositionByOffset( PolygonSpriteVertical[index, 4], -9999, -9999 )
				SetSpriteScaleByOffset( PolygonSpriteVertical[index, 4], PolygonScale[index], PolygonScale[index])
				SetSpriteColorAlpha(PolygonSpriteVertical[index, 4], PolygonTransparency[index])
			endif
		next index

		SetSpritePositionByOffset( GamePausedSprite, -9999, -9999 )

		PlayfieldMoveNext = 1
		
		DeleteImage(299979)
		
		DeleteImage(81111)
		DeleteImage(81112)

		SetupForNewLevel()
		if (QuitPlaying = FALSE)
			if GameOver = 1
				CheckPlayerForHighScore()
				
				if PlayerRankOnGameOver < 10
					PlayNewMusic(8, 1)
					if (OnMobile = FALSE)
						NextScreenToDisplay = NewHighScoreNameInputScreen
					else
						NextScreenToDisplay = NewHighScoreNameInputAndroidScreen
					endif					
				else
					PlayNewMusic(7, 1)
					NextScreenToDisplay = HighScoresScreen
				endif
			
				ScreenFadeStatus = FadingToBlack
			endif
		endif
	
		if GameWon = TRUE
			PlayNewMusic(9, 1)
			NextScreenToDisplay = AboutScreen
			ScreenFadeStatus = FadingToBlack
		endif
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayNewHighScoreNameInputScreen ( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		PreRenderCharacterIconTexts()

		LoadSelectedBackground()
		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''N E W   H I G H   S C O R E''", 999, 28, 255, 255, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 255, 255, 0, 255)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "You Achieved A New High Score!", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 70, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Enter Your Name!", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 70+25, 3)

		SetSpritePositionByOffset( ScreenLine[1], ScreenWidth/2, 130 )
		SetSpriteColor(ScreenLine[1], 255, 255, 255, 255)

		NewHighScoreCurrentName = ""
		NewHighScoreNameIndex = 0

		NewNameText = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 30, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 185, 3)
		SetTextStringOutlined ( NewNameText, NewHighScoreCurrentName )

		SetSpritePositionByOffset( ScreenLine[2], ScreenWidth/2, 240 )
		SetSpriteColor(ScreenLine[2], 255, 255, 255, 255)

		screenX as integer
		screenX = 18
		screenY as integer
		screenY = 310
		indexX as integer
		indexY as integer
		index as integer
		index = 10
		for indexY = 0 to 4
			for indexX = 0 to 12
				CreateIcon( index, (screenX+(indexX*27)), (screenY+(indexY*48)) )
				
				inc index, 1
			next indexX
		next indexY

		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 255, 255, 0, 255)

		CreateButton( 5, (ScreenWidth / 2), (ScreenHeight-40+15) )

		NextScreenToDisplay = HighScoresScreen

CurrentIconBeingPressed = -1

		ScreenIsDirty = TRUE
	endif

	shiftAddition as integer
	shiftAddition = 0
	if ShiftKeyPressed = FALSE then inc shiftAddition, 26
	
	if DelayAllUserInput = 0
		index = LastKeyboardChar
		if (LastKeyboardChar >= 65 and LastKeyboardChar <= 90)
			IconAnimationTimer[ (index-65) + shiftAddition ] = 2
			CurrentIconBeingPressed = index

			if (CurrentKeyboardKeyPressed < 2)
				inc NewHighScoreNameIndex, 1
				NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[(index-65) + 10 + shiftAddition]
				CurrentKeyboardKeyPressed = 2
			endif
		elseif (LastKeyboardChar >= 48 and LastKeyboardChar <= 57)
			IconAnimationTimer[ (index+4) ] = 2
			CurrentIconBeingPressed = index

			if (CurrentKeyboardKeyPressed < 2)
				inc NewHighScoreNameIndex, 1
				NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[index+4+10]
				CurrentKeyboardKeyPressed = 2
			endif
		elseif LastKeyboardChar = 32
			IconAnimationTimer[26+37] = 2
			CurrentIconBeingPressed = 26+37

			if (CurrentKeyboardKeyPressed < 2)
				inc NewHighScoreNameIndex, 1
				NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[26+37+10]
				CurrentKeyboardKeyPressed = 2
			endif
		elseif LastKeyboardChar = 107
			IconAnimationTimer[72-10] = 2
			CurrentIconBeingPressed = 72

			if (CurrentKeyboardKeyPressed < 2)
				inc NewHighScoreNameIndex, 1
				NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[72]
				CurrentKeyboardKeyPressed = 2
			endif
		elseif LastKeyboardChar = 8
			IconAnimationTimer[26+38] = 2
			CurrentIconBeingPressed = 26+38

			CurrentKeyboardKeyPressed = index
		else
			if (CurrentKeyboardKeyPressed > -1) then dec CurrentKeyboardKeyPressed, 1
		endif
	endif

	for index = 0 to 63
		if ThisIconWasPressed(index) and CurrentKeyboardKeyPressed = -1
			inc NewHighScoreNameIndex, 1
			NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[10+index]
		endif
	next index

	if ThisIconWasPressed(64)
		SetDelayAllUserInput()
		if NewHighScoreNameIndex > 0 then dec NewHighScoreNameIndex, 1
		NewHighScoreCurrentName = left( NewHighScoreCurrentName, len(NewHighScoreCurrentName) -1 )
	endif

	if NewHighScoreNameIndex > 9
		NewHighScoreNameIndex = 9
		NewHighScoreCurrentName= left( NewHighScoreCurrentName, len(NewHighScoreCurrentName) -1 )
	endif

	if ThisButtonWasPressed(5) = TRUE
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	endif

	SetTextStringOutlined ( NewNameText, NewHighScoreCurrentName )

	AnimateStaticBG()

	if FadingToBlackCompleted = TRUE
		HighScoreName [ GameMode, PlayerRankOnGameOver ] = NewHighScoreCurrentName
		SaveOptionsAndHighScores()
	endif
endfunction

//------------------------------------------------------------------------------------------------------------

function DisplayNewHighScoreNameInputAndroidScreen ( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		PreRenderCharacterIconTexts()

		LoadSelectedBackground()
		SetSpritePositionByOffset( TitleBG, ScreenWidth/2, ScreenHeight/2 )

		NameInputCharSpriteChar = 999
		MouseButtonLeftWasReleased = FALSE

		NameInputCharSprite = CreateSprite ( 131 )
		SetSpriteDepth ( NameInputCharSprite, 2 )
		SetSpriteOffset( NameInputCharSprite, (GetSpriteWidth(NameInputCharSprite)/2) , (GetSpriteHeight(NameInputCharSprite)/2) ) 
		SetSpritePositionByOffset( NameInputCharSprite, -9999, -9999 )

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "''N E W   H I G H   S C O R E''", 999, 28, 255, 255, 0, 255, 0, 0, 0, 1, ScreenWidth/2, 20-5, 3)

		SetSpritePositionByOffset( ScreenLine[0], ScreenWidth/2, 41-10 )
		SetSpriteColor(ScreenLine[0], 255, 255, 0, 255)

		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "You Achieved A New High Score!", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 70, 3)
		CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, "Enter Your Name!", 999, 20, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 70+25, 3)

		SetSpritePositionByOffset( ScreenLine[1], ScreenWidth/2, 130 )
		SetSpriteColor(ScreenLine[1], 255, 255, 255, 255)

		NewHighScoreCurrentName = ""
		NewHighScoreNameIndex = 0

		NewNameText = CreateAndInitializeOutlinedText(TRUE, CurrentMinTextIndex, " ", 999, 30, 255, 255, 255, 255, 0, 0, 0, 1, ScreenWidth/2, 185, 3)
		SetTextStringOutlined ( NewNameText, NewHighScoreCurrentName )

		SetSpritePositionByOffset( ScreenLine[2], ScreenWidth/2, 240 )
		SetSpriteColor(ScreenLine[2], 255, 255, 255, 255)

		screenX as integer
		screenX = 18
		screenY as integer
		screenY = 310
		indexX as integer
		indexY as integer
		index as integer
		index = 10
		for indexY = 0 to 4
			for indexX = 0 to 12
				CreateIcon( index, (screenX+(indexX*27)), (screenY+(indexY*48)) )
				
				inc index, 1
			next indexX
		next indexY

		SetSpritePositionByOffset( ScreenLine[9], ScreenWidth/2, ScreenHeight-65+13 )
		SetSpriteColor(ScreenLine[9], 255, 255, 0, 255)

		CreateButton( 5, (ScreenWidth / 2), (ScreenHeight-40+15) )

		NextScreenToDisplay = HighScoresScreen

		ScreenIsDirty = TRUE
	endif

	for index = 0 to 63
		if ThisIconWasPressedAndroid(index)
			SetDelayAllUserInput()
			inc NewHighScoreNameIndex, 1
			NewHighScoreCurrentName = NewHighScoreCurrentName + IconText[10+index]
		endif
	next index

	if ThisIconWasPressedAndroid(64)
		SetDelayAllUserInput()
		if NewHighScoreNameIndex > 0 then dec NewHighScoreNameIndex, 1
		NewHighScoreCurrentName = left( NewHighScoreCurrentName, len(NewHighScoreCurrentName) -1 )
	endif

	if NewHighScoreNameIndex > 9
		NewHighScoreNameIndex = 9
		NewHighScoreCurrentName= left( NewHighScoreCurrentName, len(NewHighScoreCurrentName) -1 )
	endif

	shiftAddition as integer
	shiftAddition = 0
	if ShiftKeyPressed = FALSE then inc shiftAddition, 26
		if DelayAllUserInput = 0
			
		for index = 65 to 90
			if LastKeyboardChar = index
				IconAnimationTimer[ (index-65) + shiftAddition ] = 10
				PlaySoundEffect(1)
				SetDelayAllUserInput()
			endif
		next index

		for index = 48 to 57
			if LastKeyboardChar = index
				IconAnimationTimer[ (index+4) ] = 10
				PlaySoundEffect(1)
				SetDelayAllUserInput()
			endif
		next index

		if LastKeyboardChar = 107
			IconAnimationTimer[26+36] = 10
			PlaySoundEffect(1)
			SetDelayAllUserInput()
		elseif LastKeyboardChar = 32
			IconAnimationTimer[26+37] = 10
			PlaySoundEffect(1)
			SetDelayAllUserInput()

		elseif LastKeyboardChar = 8
			IconAnimationTimer[26+38] = 10
			PlaySoundEffect(1)
			SetDelayAllUserInput()
		endif
	endif

	if ThisButtonWasPressed(5) = TRUE
		NextScreenToDisplay = HighScoresScreen
		ScreenFadeStatus = FadingToBlack
	endif

	SetTextStringOutlined ( NewNameText, NewHighScoreCurrentName )

	AnimateStaticBG()

	if FadingToBlackCompleted = TRUE
		HighScoreName [ GameMode, PlayerRankOnGameOver ] = NewHighScoreCurrentName
		SaveOptionsAndHighScores()
	endif
endfunction
	
//------------------------------------------------------------------------------------------------------------

function DisplayCutSceneScreen( )
	if ScreenFadeStatus = FadingFromBlack and ScreenFadeTransparency = 255
		ClearScreenWithColor ( 0, 0, 0 )
		
		BlackBG = CreateSprite ( 1 )
		SetSpriteDepth ( BlackBG, 4 )
		SetSpriteOffset( BlackBG, (GetSpriteWidth(BlackBG)/2) , (GetSpriteHeight(BlackBG)/2) ) 
		SetSpritePositionByOffset( BlackBG, ScreenWidth/2, ScreenHeight/2 )


		if (Level = 1)
			LoadImage ( 50000, "\media\images\story\Story-1.png" )
		elseif (Level = 2)
			LoadImage ( 50001, "\media\images\story\Story-2.png" )
		elseif (Level = 3)
			LoadImage ( 50002, "\media\images\story\Story-3.png" )
		elseif (Level = 4)
			LoadImage ( 50003, "\media\images\story\Story-4.png" )
		elseif (Level = 5)
			LoadImage ( 50004, "\media\images\story\Story-5.png" )
		elseif (Level = 6)
			LoadImage ( 50005, "\media\images\story\Story-6.png" )
		elseif (Level = 7)
			LoadImage ( 50006, "\media\images\story\Story-7.png" )
		elseif (Level = 8)
			LoadImage ( 50007, "\media\images\story\Story-8.png" )
		elseif (Level = 9)
			LoadImage ( 50008, "\media\images\story\Story-9.png" )
		endif

		StoryImage = CreateSprite ( 50000 + (Level-1) )
		
		SetSpriteOffset( StoryImage, (GetSpriteWidth(StoryImage)/2) , (GetSpriteHeight(StoryImage)/2) ) 
		SetSpriteDepth( StoryImage, 4 )
		SetSpritePositionByOffset( StoryImage, ScreenWidth/2, ScreenHeight/2 )
		
		ScreenDisplayTimer = 200
		NextScreenToDisplay = PlayingScreen

		if (PlayerLostALife = TRUE)
			ScreenFadeStatus = FadingToBlack
			PlayerLostALife = FALSE
		endif

		ScreenIsDirty = TRUE
	endif

	if (ScreenFadeStatus = FadingIdle)
		if ScreenDisplayTimer > 0
			dec ScreenDisplayTimer, 1
		elseif ScreenDisplayTimer = 0
			ScreenFadeStatus = FadingToBlack
		endif
		
		if ScreenDisplayTimer > 0
			if MouseButtonLeft = ON or LastKeyboardChar = 32 or LastKeyboardChar = 13 or LastKeyboardChar = 27
				PlaySoundEffect(1)
				SetDelayAllUserInput()
				ScreenDisplayTimer = 0
			endif
		endif
	endif

	if FadingToBlackCompleted = TRUE
		if (Level < 5)
			DeleteImage( 50000+(Level-1) )
		else
			DeleteImage(71111)
		endif

		DeleteImage(50001)
		DeleteImage(50002)
		DeleteImage(50003)
		DeleteImage(50004)
		DeleteImage(50005)
		DeleteImage(50006)
		DeleteImage(50007)
		DeleteImage(50008)
		DeleteImage(50009)
	endif
endfunction
