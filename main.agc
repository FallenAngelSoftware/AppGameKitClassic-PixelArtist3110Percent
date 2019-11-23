// "main.agc"...

remstart
---------------------------------------------------------------------------------------------------
                                           JeZxLee's
                                                                   TM
                             AppGameKit Classic "NightRider" Engine
                                        (Version 1.9.1)
           ____  _          _      _         _   _     _     _____   _ _  ___ _  __TM
          |  _ \(_)_  _____| |    / \   _ __| |_(_)___| |_  |___ /  / / |/ _ (_)/ /
          | |_) | \ \/ / _ \ |   / _ \ | '__| __| / __| __|   |_ \  | | | | | |/ / 
          |  __/| |>  <  __/ |  / ___ \| |  | |_| \__ \ |_   ___) | | | | |_| / /_ 
          |_|   |_/_/\_\___|_| /_/   \_\_|   \__|_|___/\__| |____/  |_|_|\___/_/(_)                                                                    

                                     Retail2 110% - v3.3.3              "Turbo!"

---------------------------------------------------------------------------------------------------     

           Google Android SmartPhones/Tablets & HTML5 Desktop/Notebook Internet Browsers

---------------------------------------------------------------------------------------------------                       

                     (C)opyright 2019, By Team "www.FallenAngelSoftware.com"

---------------------------------------------------------------------------------------------------
remend

#include "audio.agc"
#include "data.agc"
#include "input.agc"
#include "interface.agc"
#include "logic.agc"
#include "screens.agc"
#include "visuals.agc"

global GameVersion as string
GameVersion = "''Retail2 110% - Turbo! - v3.3.3''"
global DataVersion as string
DataVersion = "PA3-Retail2-110-Turbo-v3_3_3.cfg"
global HTML5DataVersion as String
HTML5DataVersion = "PA3-v3_3_3-"

global MaximumFrameRate as integer
MaximumFrameRate = 0

global PerformancePercent as float

#option_explicit
SetErrorMode(2)

global ScreenWidth = 360
global ScreenHeight = 640
global ExitGame as integer
ExitGame = 0

SetWindowTitle( "Pixel Artist 3 110%[TM]" )
SetWindowSize( ScreenWidth, ScreenHeight, 0 )
SetWindowAllowResize( 1 )

SetScreenResolution( ScreenWidth, ScreenHeight ) 
SetVirtualResolution( ScreenWidth, ScreenHeight )
SetOrientationAllowed( 1, 0, 0, 0 )

#constant FALSE		0
#constant TRUE		1

#constant Web		0
#constant Android	1
#constant iOS		2
#constant Windows	3
#constant Linux		4
global Platform as integer

global OnMobile as integer
global ShowCursor as integer
if ( GetDeviceBaseName() = "android" or GetDeviceBaseName() = "ios" )
	if ( GetDeviceBaseName() = "android" )
		Platform = Android
	elseif ( GetDeviceBaseName() = "ios" )
		Platform = iOS
	endif

	SetSyncRate( 30, 0 )
	SetScissor( 0,0,0,0 )
	OnMobile = TRUE
	ShowCursor = FALSE
else
	Platform = Web
	SetSyncRate( 30, 1 )
	SetScissor( 0, 0, ScreenWidth, ScreenHeight )
	OnMobile = FALSE
	ShowCursor = TRUE
endif

if (GetDeviceBaseName() = "windows")
	Platform = Windows
elseif (GetDeviceBaseName() = "linux")
	Platform = Linux
endif

global LoadPercent as float
global LoadPercentFixed as integer

// Uncomment below three lines to test Android version on desktop																			
// Platform = Android
// OnMobile = TRUE
// ShowCursor = FALSE

SetClearColor( 0, 0, 0 ) 
ClearScreen()

global MouseScreenX = 0
global MouseScreenY = 0
#constant OFF			0
#constant ON			1
global MouseButtonLeft = OFF
global MouseButtonLeftJustClicked as integer

global ShiftKeyPressed as integer
ShiftKeyPressed = FALSE

#constant JoyCENTER			0
#constant JoyUP				1
#constant JoyRIGHT			2
#constant JoyDOWN     		3
#constant JoyLEFT			4
global JoystickDirection as integer
JoystickDirection = JoyCENTER

global LastKeyboardChar = -1

global DelayAllUserInput as integer
DelayAllUserInput = 0

#constant FadingIdle		-1
#constant FadingFromBlack 	 0
#constant FadingToBlack 	 1
global ScreenFadeStatus as integer
ScreenFadeStatus = FadingFromBlack
global ScreenFadeTransparency as integer
ScreenFadeTransparency = 255

global StoryImage as integer

global StoryTemp as integer

global BlackBG as integer
global FadingBlackBG as integer
LoadImage ( 1, "\media\images\backgrounds\FadingBlackBG.png" )
FadingBlackBG = CreateSprite ( 1 )
SetSpriteDepth ( FadingBlackBG, 1 )
SetSpriteOffset( FadingBlackBG, (GetSpriteWidth(FadingBlackBG)/2) , (GetSpriteHeight(FadingBlackBG)/2) ) 
SetSpritePositionByOffset( FadingBlackBG, ScreenWidth/2, ScreenHeight/2 )
SetSpriteTransparency( FadingBlackBG, 1 )
global FadingToBlackCompleted as integer
FadingToBlackCompleted = FALSE

global MatchLeft as integer
global MatchRight as integer

UseNewDefaultFonts( 1 )
LoadFont( 999, "\media\fonts\Akashi.ttf" )
global CurrentMinTextIndex = 1

LoadImage ( 3, "\media\images\backgrounds\FadingBlackBG.png" )
global Resume as integer

global AppGameKitLogo as integer

global TitleTwoBGAngle as integer
TitleTwoBGAngle = 0
global TitleBG as integer

global SixteenBitSoftLogo as integer

global PA3Logo as integer

global NewNameText as integer
global NewHighScoreCurrentName as String
NewHighScoreCurrentName = " "
global NewHighScoreNameIndex as integer
NewHighScoreNameIndex = 1

#constant SteamOverlayScreen						0
#constant AppGameKitScreen							1
#constant SixteenBitSoftScreen						2
#constant TitleScreen								3
#constant OptionsScreen								4
#constant HowToPlayScreen							5
#constant HighScoresScreen							6
#constant AboutScreen								7
#constant PlayingScreen								9
#constant NewHighScoreNameInputScreen				11
#constant NewHighScoreNameInputAndroidScreen		12
#constant MusicPlayerScreen							13
#constant CutSceneScreen							14

global ScreenToDisplay = 0
global NextScreenToDisplay = 1
global ScreenDisplayTimer = 0

if (Platform <> Windows)
	ScreenToDisplay = 3
	NextScreenToDisplay = 4
endif

global MusicPlayerScreenIndex as integer
MusicPlayerScreenIndex = 0

global LeftArrow
LoadImage ( 100, "\media\images\gui\ButtonSelectorLeft.png" )
global RightArrow
LoadImage ( 101, "\media\images\gui\ButtonSelectorRight.png" )

LoadImage ( 103, "\media\images\gui\Button.png" )
global ButtonText as string[8]
ButtonText[0] = "START!"
ButtonText[1] = "Options"
ButtonText[2] = "How To Play"
ButtonText[3] = "High Scores"
ButtonText[4] = "About"
ButtonText[5] = "Exit"
ButtonText[6] = "Back"
ButtonText[7] = "Clear Scores"

global ButtonSprite as integer[8]
for index = 0 to 7
	ButtonSprite[index] = 680+index
next index

global ButtonIndex as integer[8]
global ButtonScreenX as integer[8]
global ButtonScreenY as integer[8]
global ButtonAnimationTimer as integer[8]
global ButtonScale as float[8]
global NumberOfButtonsOnScreen = 0
global ButtonSelectedByKeyboard = 0
index as integer
for index = 0 to 7
    ButtonIndex[index] = -1
    ButtonScreenX[index] = (ScreenWidth/2)
    ButtonScreenY[index] = (ScreenHeight/2)
    ButtonAnimationTimer[index] = 0
    ButtonScale[index] = 1
next index

LoadImage ( 120, "\media\images\gui\ButtonSelectorRight.png" )
LoadImage ( 121, "\media\images\gui\ButtonSelectorLeft.png" )
global LeftArrowSet as integer[10]
global RightArrowSet as integer[10]

LoadImage ( 122, "\media\images\gui\SelectorLine.png" )
global SelectorLine as integer

LoadImage ( 130, "\media\images\gui\NameInputButton.png" )

LoadImage ( 131, "\media\images\gui\NameInputChar.png" )
global NameInputCharSprite as integer
global NameInputCharSpriteChar as integer
global MouseButtonLeftWasReleased as integer

global NumberOfArrowSetsOnScreen as integer = 0
global ArrowSetSelectedByKeyboard as integer = 0
global ArrowSetScreenY as integer[10]
global ArrowSetLeftAnimationTimer as integer[10]
global ArrowSetRightAnimationTimer as integer[10]
global ArrowSetLeftScale as float[10]
global ArrowSetRightScale as float[10]
global ArrowSetTextStringIndex as integer[10]
for index = 0 to 9
    ArrowSetScreenY[index] = (ScreenHeight/2)
    ArrowSetLeftAnimationTimer[index] = 0
    ArrowSetRightAnimationTimer[index] = 0
    ArrowSetLeftScale[index] = 1
    ArrowSetRightScale[index] = 1
    ArrowSetTextStringIndex[index] = -1
next index

LoadImage ( 140, "\media\images\gui\ScreenLine.png" )
global ScreenLine as integer[10]

LoadImage ( 61, "\media\images\gui\HowToPlayFingerTouch.png" )
global HowToPlayFingerTouch as integer

global Icon as integer[100]
LoadImage ( 300, "\media\images\gui\SpeakerOFF.png" )
LoadImage ( 301, "\media\images\gui\SpeakerON.png" )
LoadImage ( 302, "\media\images\logos\GooglePlayLogo.png" )
LoadImage ( 303, "\media\images\logos\ReviewGooglePlayLogo.png" )
LoadImage ( 304, "\media\images\gui\Exit.png" )
LoadImage ( 305, "\media\images\gui\Pause.png" )
LoadImage ( 306, "\media\images\gui\Play.png" )
LoadImage ( 307, "\media\images\logos\OptionsBanner.png" )

global IconIndex as integer[100]
global IconSprite as integer[100]
global IconScreenX as integer[100]
global IconScreenY as integer[100]
global IconAnimationTimer as integer[100]
global IconScale as float[100]
global IconText as string[100]
global NumberOfIconsOnScreen as integer
NumberOfIconsOnScreen = 0
for index = 0 to 99
	IconIndex[index] = -1
    IconSprite[index] = -1
    IconScreenX[index] = (ScreenWidth/2)
    IconScreenY[index] = (ScreenHeight/2)
    IconAnimationTimer[index] = 0
    IconScale[index] = 1
    IconText[index] = " "
next index

LoadInterfaceSprites()
PreRenderButtonsWithTexts()

global CurrentlyPlayingMusicIndex = -1
#constant MusicTotal 						10
global MusicTrack as integer[MusicTotal]
LoadAllMusic()

#constant EffectsTotal						6
global SoundEffect as integer[EffectsTotal]
LoadAllSoundEffects()

global MusicSoundtrack	as integer
MusicSoundtrack = 0

#constant ChildStoryMode				0
#constant TeenStoryMode					1
#constant AdultStoryMode				2
global GameMode = AdultStoryMode

global MusicVolume as integer
MusicVolume = 100
global EffectsVolume as integer
EffectsVolume = 100

global SecretCode as integer[4]
SecretCode[0] = 0
SecretCode[1] = 0
SecretCode[2] = 0
SecretCode[3] = 0
global SecretCodeCombined as integer
SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )

global PlayerRankOnGameOver as integer
PlayerRankOnGameOver = 999

mode as integer
global HighScoreName as string[3, 10]
global HighScoreLevel as integer[3, 10]
global HighScoreScore as integer[3, 10]

global LevelSkip as integer[3]
LevelSkip[0] = 1
LevelSkip[1] = 1
LevelSkip[2] = 1
global StartingLevel as integer
StartingLevel = 1

ClearHighScores()

global AboutTexts as string[99999]
global AboutTextsScreenY as float[99999]
global AboutTextsBlue as integer[99999]
global AboutTextVisable as integer[99999]
for index = 0 to 99998
	AboutTexts[index] = "Should Not See"
	AboutTextsScreenY[index] = 99999
	AboutTextsBlue[index] = 255
	AboutTextVisable[index] = 0
next index

global ATindex = 0

global NumberOfAboutScreenTexts
NumberOfAboutScreenTexts = ATindex
global StartIndexOfAboutScreenTexts
StartIndexOfAboutScreenTexts = 0

global AboutScreenOffsetY as float
global AboutScreenBackgroundY as float
global AboutScreenFPSY as float
AboutScreenFPSY = -200

global AboutScreenTextFrameSkip as integer

global ChangingBackground as integer
ChangingBackground = FALSE
global SelectedBackground as integer
SelectedBackground = 0

global GamePausedSprite as integer

global PlayerLostALife as integer
PlayerLostALife = FALSE

global GameOver as integer
GameOver = 0

global GameWon as integer
GameWon = FALSE

global PlayerPosX as integer
PlayerPosX = 3
global PlayerPosY as integer
PlayerPosY = 3

global KeyboardMovementTimer as float
KeyboardMovementTimer = 0.0

global PixelBG as integer
LoadImage ( 299980, "\media\images\backgrounds\PixelBG.png" )

LoadImage ( 299990, "\media\images\gui\SquareMove.png" )
global PlayfieldMove as integer[13]
global PlayfieldMoveNext as integer

global PlayfieldPixels as integer[9, 50]
global PlayfieldPixelsNext as integer[9]
global MapPixels as integer[9, 50]
global MapPixelsNext as integer[9]

global AboutScreenPlayfield as integer [3, 3]
global AboutScreenMoveDelay as integer
global AboutScreenMoveIndex as integer

LoadImage ( 700000, "\media\images\polygons\PolygonFlat.png" )
LoadImage ( 700001, "\media\images\polygons\PolygonHorizontalOne.png" )
LoadImage ( 700002, "\media\images\polygons\PolygonHorizontalTwo.png" )
LoadImage ( 700003, "\media\images\polygons\PolygonHorizontalThree.png" )
LoadImage ( 700004, "\media\images\polygons\PolygonVerticalOne.png" )
LoadImage ( 700005, "\media\images\polygons\PolygonVerticalTwo.png" )
LoadImage ( 700006, "\media\images\polygons\PolygonVerticalThree.png" )
global AddPolygonTimer as float
AddPolygonTimer = 0.0
global AddPolygonTime as float
AddPolygonTime = 25.0
global AddPolygonTimeOriginal as float
AddPolygonTimeOriginal = 25.0

global MovePolygonsTimer as float
MovePolygonsTimer = 0.0
global MovePolygonsTime as float
MovePolygonsTime = 25.0
global MovePolygonsTimeOriginal as float
MovePolygonsTimeOriginal = 25.0

global PolygonActive as integer[25]
global PolygonPlayfieldX as integer[25]
global PolygonPlayfieldY as integer[25]
global PolygonScreenX as integer[25]
global PolygonScreenY as integer[25]
global PolygonDirection as integer[25]
global PolygonStep as integer[25]
global PolygonScale as float[25]
global PolygonScaleDirection as integer[25]
global PolygonTransparency as float[25]
global PolygonSpriteHorizontal as integer[25, 5]
global PolygonSpriteVertical as integer[25, 5]
for index = 0 to 24
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
next index

global MapLevelOne as integer[7, 7]
MapLevelOne[0] = [8,2,2,2,2,2,8]
MapLevelOne[1] = [2,2,2,2,2,2,2]
MapLevelOne[2] = [2,2,2,2,2,2,2]
MapLevelOne[3] = [2,2,2,2,2,2,2]
MapLevelOne[4] = [2,2,2,2,2,2,2]
MapLevelOne[5] = [2,2,2,2,2,2,2]
MapLevelOne[6] = [0,2,2,2,2,2,8]

global MapLevelTwo as integer[7, 7]
MapLevelTwo[0] = [8,8,3,3,3,8,8]
MapLevelTwo[1] = [8,3,3,3,3,3,8]
MapLevelTwo[2] = [3,3,3,3,3,3,3]
MapLevelTwo[3] = [3,3,3,3,3,3,3]
MapLevelTwo[4] = [3,3,3,3,3,3,3]
MapLevelTwo[5] = [8,3,3,3,3,3,8]
MapLevelTwo[6] = [0,8,3,3,3,8,8]

global MapLevelThree as integer[7, 7]
MapLevelThree[0] = [8,8,8,4,8,8,8]
MapLevelThree[1] = [8,8,4,4,4,8,8]
MapLevelThree[2] = [8,4,4,4,4,4,8]
MapLevelThree[3] = [4,4,4,4,4,4,4]
MapLevelThree[4] = [8,4,4,4,4,4,8]
MapLevelThree[5] = [8,8,4,4,4,8,8]
MapLevelThree[6] = [0,8,8,4,8,8,8]

global MapLevelFour as integer[7, 7]
MapLevelFour[0] = [5,5,8,8,8,5,5]
MapLevelFour[1] = [5,5,8,8,8,5,5]
MapLevelFour[2] = [8,8,5,5,5,8,8]
MapLevelFour[3] = [8,8,5,5,5,8,8]
MapLevelFour[4] = [8,8,5,5,5,8,8]
MapLevelFour[5] = [5,5,8,8,8,5,5]
MapLevelFour[6] = [0,5,8,8,8,5,5]

global MapLevelFive as integer[7, 7]
MapLevelFive[0] = [6,6,6,8,6,6,6]
MapLevelFive[1] = [6,8,6,8,6,8,6]
MapLevelFive[2] = [6,6,6,6,6,6,6]
MapLevelFive[3] = [8,8,6,0,6,8,8]
MapLevelFive[4] = [6,6,6,6,6,6,6]
MapLevelFive[5] = [6,8,6,8,6,8,6]
MapLevelFive[6] = [6,6,6,8,6,6,6]

global MapLevelSix as integer[7, 7]
MapLevelSix[0] = [8,6,8,8,8,6,0]
MapLevelSix[1] = [6,7,6,8,6,7,6]
MapLevelSix[2] = [8,6,7,6,7,6,8]
MapLevelSix[3] = [8,8,6,7,6,8,8]
MapLevelSix[4] = [8,6,7,6,7,6,8]
MapLevelSix[5] = [6,7,6,8,6,7,6]
MapLevelSix[6] = [8,6,8,8,8,6,8]

global MapLevelSeven as integer[7, 7]
MapLevelSeven[0] = [8,8,4,4,4,8,8]
MapLevelSeven[1] = [8,4,8,4,8,4,8]
MapLevelSeven[2] = [4,4,8,4,8,4,4]
MapLevelSeven[3] = [4,4,4,4,4,4,4]
MapLevelSeven[4] = [4,8,4,4,4,8,4]
MapLevelSeven[5] = [8,4,8,8,8,4,8]
MapLevelSeven[6] = [0,8,4,4,4,8,8]

global MapLevelEight as integer[7, 7]
MapLevelEight[0] = [0,2,8,8,8,7,8]
MapLevelEight[1] = [2,4,2,8,7,4,7]
MapLevelEight[2] = [8,2,8,6,8,7,8]
MapLevelEight[3] = [8,5,6,4,6,5,8]
MapLevelEight[4] = [8,5,8,6,8,5,8]
MapLevelEight[5] = [8,5,8,5,8,5,8]
MapLevelEight[6] = [8,5,8,5,8,5,8]

global MapLevelNine as integer[7, 7]
MapLevelNine[0] = [2,2,2,2,2,2,2]
MapLevelNine[1] = [3,3,3,3,3,3,3]
MapLevelNine[2] = [4,4,4,4,4,4,4]
MapLevelNine[3] = [5,5,5,5,5,5,5]
MapLevelNine[4] = [6,6,6,6,6,6,6]
MapLevelNine[5] = [7,7,7,7,7,7,7]
MapLevelNine[6] = [0,8,8,8,8,8,8]

global Playfield as integer[7, 7]
global PlayfieldBlocked as integer[7, 7]
pfX as integer
pfY as integer
for pfY = 0 to 6
	for pfX = 0 to 6
		Playfield[ pfX, pfY] = 0
		PlayfieldBlocked[ pfX, pfY ] = 0
	next pfX
next pfY

global PlayfieldMap as integer[7, 7]
for pfY = 0 to 6
	for pfX = 0 to 6
		PlayfieldMap[ pfX, pfY] = 0
	next pfX
next pfY

global Score as integer
global ScoreText as integer
global Bonus as integer
global BonusText as integer
global Level as integer
global LevelText as integer
global Lives as integer
global LivesText as integer

global BlockedText as integer[7, 7]

global PlayfieldChangedSoDrawIt as integer
PlayfieldChangedSoDrawIt = FALSE

global GUIchanged as integer
GUIchanged = TRUE

global FirstFrame as integer
FirstFrame = 0

global DisablePolygonDraws as integer
DisablePolygonDraws = FALSE

global FrameCount as integer
FrameCount = 0
global SecondsSinceStart as integer
SecondsSinceStart = 0

global PauseGame as integer
PauseGame = FALSE

global QuitPlaying as integer
QuitPlaying = FALSE

global roundedFPS as float

SetPrintColor ( 255, 255, 255 )
SetPrintSize(17)

global PrintColor as integer
PrintColor = 255
global PrintColorDir as integer
PrintColorDir = 0

global FPSChangeDelay as integer

global FramesPerSecond as integer
FramesPerSecond = 30

LoadOptionsAndHighScores()
SetVolumeOfAllMusicAndSoundEffects()
SecretCodeCombined = ( (SecretCode[0]*1000) + (SecretCode[1]*100) + (SecretCode[2]*10) + (SecretCode[3]) )

global ScreenIsDirty as integer
ScreenIsDirty = TRUE

global LoadPercentText as integer

global PositionToMoveToX as integer
global PositionToMoveToY as integer

LoadAboutScreenTexts()

PlayNewMusic(0, 1)

global CurrentIconBeingPressed as integer
CurrentIconBeingPressed = -1
global CurrentKeyboardKeyPressed as integer
CurrentKeyboardKeyPressed = -1

global multiplier as float
/*
Score = 5555
Level = 5
ScreenToDisplay = NewHighScoreNameInputScreen
*/
do
	inc FrameCount, 1
		
	GetAllUserInput()
	
	select ScreenToDisplay
		case SteamOverlayScreen:
			DisplaySteamOverlayScreen()
		endcase

		case AppGameKitScreen:
			DisplayAppGameKitScreen()
		endcase

		case SixteenBitSoftScreen:
			DisplaySixteenBitSoftScreen()
		endcase

		case TitleScreen:
			DisplayTitleScreen()
		endcase

		case OptionsScreen:
			DisplayOptionsScreen()
		endcase

		case HowToPlayScreen:
			DisplayHowToPlayScreen()
		endcase

		case HighScoresScreen:
			DisplayHighScoresScreen()
		endcase

		case AboutScreen:
			DisplayAboutScreen()
		endcase

		case PlayingScreen:
			DisplayPlayingScreen()
		endcase

		case NewHighScoreNameInputScreen:
			DisplayNewHighScoreNameInputScreen()
		endcase

		case NewHighScoreNameInputAndroidScreen:
			DisplayNewHighScoreNameInputAndroidScreen()
		endcase

		case MusicPlayerScreen:
			DisplayMusicPlayerScreen()
		endcase

		case CutSceneScreen:
			DisplayCutSceneScreen()
		endcase
	endselect

	if (GUIchanged = TRUE or ScreenToDisplay = NewHighScoreNameInputAndroidScreen)
		if NumberOfButtonsOnScreen > 0 then DrawAllButtons()
		if NumberOfIconsOnScreen > 0 then DrawAllIcons()
	
		ScreenIsDirty = TRUE
		GUIchanged = FALSE
	endif

	if ScreenFadeStatus <> FadingIdle
		ScreenIsDirty = TRUE
		ApplyScreenFadeTransition()
	endif

	roundedFPS = Round( ScreenFPS() )

	if (roundedFPS > 0)
		PerformancePercent = (30 / roundedFPS)
	else
		PerformancePercent = 1
	endif

	if (FrameCount > roundedFPS)
		FrameCount = 0
		inc SecondsSinceStart, 1
	endif

	if (SecretCodeCombined = 2777 and ScreenIsDirty = TRUE)
		if (ScreenFadeStatus = FadingIdle)
			if (ScreenToDisplay = AboutScreen)
				SetSpritePositionByOffset( FadingBlackBG,  -80, AboutScreenFPSY )
			else
				SetSpritePositionByOffset( FadingBlackBG,  -80, -200 )
			endif			
			SetSpriteColorAlpha( FadingBlackBG, 200 )
		else
			SetSpritePositionByOffset( FadingBlackBG,  ScreenWidth/2, ScreenHeight/2 )
		endif

		if (PrintColorDir = 0)
			if (PrintColor > 0)
				dec PrintColor, 51
			else
				PrintColor = 0
				PrintColorDir = 1
			endif
		elseif (PrintColorDir = 1)
			if (PrintColor < 255)
				inc PrintColor, 51
			else
				PrintColor = 255
				PrintColorDir = 0
			endif
		endif
		
		SetPrintColor (PrintColor, PrintColor, PrintColor)
		Print (  "FPS="+str( floor(roundedFPS) )  )
		print (  "Sprite(s): "+str( GetManagedSpriteCount() )  )
		print (  "AddPoly="+str( floor(AddPolygonTime) )  )
		print (  "MovePoly="+str( floor(MovePolygonsTime) )  )
	endif

	if (ScreenIsDirty = TRUE)
		Sync()
		ScreenIsDirty = TRUE
	endif

	if ExitGame = 1
		exit
	endif
loop
rem                                      [TM]
rem "A 110% By Team Fallen Angel Software!"
