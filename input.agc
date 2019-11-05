// "input.agc"...

function GetAllUserInput ( )
	MouseButtonLeft = OFF
	LastKeyboardChar = -1
	ShiftKeyPressed = FALSE
	JoystickDirection = JoyCENTER
	
	if (DelayAllUserInput > 0)
		dec DelayAllUserInput, 1
		exitfunction
	endif

	if GetRawKeyState(16) = 1 then ShiftKeyPressed = TRUE

	if (OnMobile = FALSE)
		MouseScreenX = GetRawMouseX()
		MouseScreenY = GetRawMouseY()

		if ( GetRawMouseLeftState() = 1 )
			MouseButtonLeft = ON
			MouseButtonLeftJustClicked = 0
		else
			MouseButtonLeft = OFF
		endif
	else
		MouseScreenX = GetPointerX()
		MouseScreenY = GetPointerY()

		if ( GetPointerState() = 1 )
			MouseButtonLeft = ON
			MouseButtonLeftJustClicked = 0
		else
			MouseButtonLeft = OFF
		endif
	endif

	if (MouseButtonLeft = OFF and MouseButtonLeftJustClicked = 0)
		MouseButtonLeftJustClicked = 1
	elseif (MouseButtonLeft = OFF and MouseButtonLeftJustClicked = 1)
		MouseButtonLeftJustClicked = -1
	endif

	index as integer
	for index = 1 to 255
		if GetRawKeyState(index) = 1
			LastKeyboardChar = index
		endif
	next index

	select LastKeyboardChar
		case 38:
			JoystickDirection = JoyUP
		endcase
		case 39:
			JoystickDirection = JoyRIGHT
		endcase
		case 40:
			JoystickDirection = JoyDOWN
		endcase
		case 37:
			JoystickDirection = JoyLEFT
		endcase
	endselect
	
	if LastKeyboardChar = 27
		SetDelayAllUserInput()
		PlayNewMusic(0, 1)
		QuitPlaying = TRUE
		NextScreenToDisplay = TitleScreen
		ScreenFadeStatus = FadingToBlack
	endif
endfunction
