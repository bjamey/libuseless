// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Test if a sound card is installed or not
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* ----------------------------------------------------
   If you write multimedia software that requires an
   installed sound card, of course you must check if
   some sound card is installed

   You may do so with this function:
---------------------------------------------------- *)


function waveOutGetNumDevs: UINT; stdcall; external 'winmm.dll' name
                       'waveOutGetNumDevs';

function SoundCardInstalled() : boolean;
begin
     (*
     waveOutGetNumDevs function will return a number of
     installed sound cards.
     // *)
     Result := (waveOutGetNumDevs > 0);
end;
