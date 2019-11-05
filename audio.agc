// "audio.agc"...

function LoadAllSoundEffects ( )
	SoundEffect[0] = LoadSoundOGG("\media\sound\MenuMove.ogg")
	SoundEffect[1] = LoadSoundOGG("\media\sound\MenuClick.ogg")
	SoundEffect[2] = LoadSoundOGG("\media\sound\NewCube.ogg")
	SoundEffect[3] = LoadSoundOGG("\media\sound\PlayerMove.ogg")
	SoundEffect[4] = LoadSoundOGG("\media\sound\LifeLost.ogg")
	SoundEffect[5] = LoadSoundOGG("\media\sound\GameOver.ogg")
endfunction

//------------------------------------------------------------------------------------------------------------

function LoadAllMusic ( )
	MusicTrack[0] = LoadMusicOGG( "\media\music\Title01BGM.ogg" )
	MusicTrack[1] = LoadMusicOGG( "\media\music\InGame0to3BGM.ogg" )
	MusicTrack[2] = LoadMusicOGG( "\media\music\InGame4to5BGM.ogg" )
	MusicTrack[3] = LoadMusicOGG( "\media\music\InGame6BGM.ogg" )
	MusicTrack[4] = LoadMusicOGG( "\media\music\InGame7BGM.ogg" )
	MusicTrack[5] = LoadMusicOGG( "\media\music\InGame8BGM.ogg" )
	MusicTrack[6] = LoadMusicOGG( "\media\music\InGame9BGM.ogg" )
	MusicTrack[7] = LoadMusicOGG( "\media\music\HighScoreSadBGM.ogg" )
	MusicTrack[8] = LoadMusicOGG( "\media\music\HighScoreHappyBGM.ogg" )
	MusicTrack[9] = LoadMusicOGG( "\media\music\EndingBGM.ogg" )
endfunction

//------------------------------------------------------------------------------------------------------------

function SetVolumeOfAllMusicAndSoundEffects()
	SetSoundSystemVolume(EffectsVolume) 	
	
	index as integer
	for index = 0 to (MusicTotal-1)
		SetMusicVolumeOGG( MusicTrack[index], MusicVolume )
	next index
endfunction

//------------------------------------------------------------------------------------------------------------

function PlayNewMusic ( index as integer, loopMusic as integer )
	if ( index > (MusicTotal-1) ) then exitfunction
	
	if CurrentlyPlayingMusicIndex > -1 then StopMusicOGG(MusicTrack[CurrentlyPlayingMusicIndex])
		
	PlayMusicOGG( MusicTrack[index], loopMusic )
	CurrentlyPlayingMusicIndex = index
endfunction

//------------------------------------------------------------------------------------------------------------

function PlaySoundEffect ( index as integer )
	if ( index > (EffectsTotal-1) ) then exitfunction
	
	PlaySound(SoundEffect[index])
endfunction
