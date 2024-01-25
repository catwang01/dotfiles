;SpaceFn
#inputlevel,2
$CapsLock::
    SetMouseDelay -1 
    Send {Blind}{F24 DownR}
    KeyWait, CapsLock
    Send {Blind}{F24 up}
    ; MsgBox, %A_ThisHotkey%-%A_TimeSinceThisHotkey%
    if(A_ThisHotkey="$CapsLock" and A_TimeSinceThisHotkey<1000)
        ; Send {Blind}{CapsLock DownR}
    	; MsgBox, CapsLock is disabled
        Send {Blind}{F23 DownR}
    return

#inputlevel,1
F24 & h::Left
F24 & j::Down
F24 & k::Up
F24 & l::Right

F24 & y::Home
F24 & o::End
F24 & u::PgUp
F24 & i::PgDn
F24 & [::ESC

F24 & b::_
F24 & n::-
F24 & m::=
F24 & ,::+
F24 & '::`
F24 & `;::Backspace
F24 & /::\

F24 & 1::F1
F24 & 2::F2
F24 & 3::F3
F24 & 4::F4
F24 & 5::F5
F24 & 6::F6
F24 & 7::F7
F24 & 8::F8
F24 & 9::F9
F24 & 0::F10
F24 & -::F11
F24 & =::F12

F24 & Enter::^Enter

;Ctrl+S
; ~^s::
; sleep 500
; Reload
; return
