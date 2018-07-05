<#
.SYNOPSIS
  Helps the user create songs calling the Beep() function easter than trying to guess the frequencies and durrations.

.DESCRIPTION
  Simple funciton that plays an array of comma seperated notes in a custom musical notation.

.NOTES
  Author:  Duelr
  Version: 1.0
  Last Modified: NA
  Modified By: Duelr
  Changes: NA
  To Do:
    - Add Key Change Support
    - Do the real math on tempo

.PARAMETER Notes
  A comma seperated string of notes to play in sequence.
  This is a required parameter.

.PARAMETER Tempo
  An integrer that when supplied will augment the tempo of the song.
  For reference, the Q NoteType (Quarter Note) Defaults to about ~140 BPM  
  NOT a required parameter.
  
.PARAMETER Output
  Switch that will cause the command to display the debug info for the command.
  NOT a required parameter.

.EXAMPLE
  PS> # This example shows 4 QuarterNotes being plays on the 5th Octave.
  PS> .\Play-Notes.ps1 -Notes "C5Q,C5Q,C5Q,C5Q"

.EXAMPLE
  PS> # This example shows 4 QuarterNotes being plays on the 5th Octave with a tempo of 80
  PS> .\Play-Notes.ps1 -Notes "C5Q,C5Q,C5Q,C5Q" -Tempo 80
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory = $true)]
    [string]$Notes,
    [Parameter(Mandatory = $false)]
    [int]$Tempo,
    [Parameter(Mandatory = $false)]
    [switch]$Output = $false
)

$NoteTypes = [pscustomobject]@{
    # W = Whole, H = Half, Q = Quarter, E = Eighth, S = Sixteenth
    'W'=1600;'W.'=2000;'H'=800;'H.'=1000;'Q'=400;'Q.'=600;'E'=200;'E.'=300;'S'=100;'S.'=150
}
$NoteIndex = [pscustomobject]@{
    'C'  = @(16.35,32.7,65.41,130.8,261.6,523.3,1047,2093,4186)
    'C#' = @(17.32,34.65,69.3,138.6,277.2,554.4,1109,2217,4435)
    'D'  = @(18.35,36.71,73.42,146.8,293.7,587.3,1175,2349,4699)
    'Eb' = @(19.45,38.89,77.78,155.6,311.1,622.3,1245,2489,4978)
    'E'  = @(20.6,41.2,82.41,164.8,329.6,659.3,1319,2637,5274)
    'F'  = @(21.83,43.65,87.31,174.6,349.2,698.5,1397,2794,5588)
    'F#' = @(23.12,46.25,92.5,185,370,740,1480,2960,5920)
    'G'  = @(24.5,49,98,196,392,784,1568,3136,6272)
    'G#' = @(25.96,51.91,103.8,207.7,415.3,830.6,1661,3322,6645)
    'A'  = @(27.5,55,110,220,440,880,1760,3520,7040)
    'Bb' = @(29.14,58.27,116.5,233.1,466.2,932.3,1865,3729,7459)
    'B'  = @(30.87,61.74,123.5,246.9,493.9,987.8,1976,3951,7902)
    'R'  = '0'
}
foreach ($Note in ($Notes -split ',')){
    $Note -match '(?<Pitch>[A-G][#|b]?|[R])(?<Octave>[0-8])?(?<NoteType>[Ww|Hh|Qq|Ee|Ss][\.]?)?' | Out-Null
    $Pitch = $matches['Pitch']
    if($matches['NoteType'] -eq $null){
        if($Tempo){
            [int]$Durration = 100/$Tempo*400
        }else{
            [int]$Durration = 400
        }
    }else{
        if($Tempo){
            [int]$Durration = 100/$Tempo*($NoteTypes.$($matches['NoteType']))
        }else{
            [int]$Durration = $NoteTypes.$($matches['NoteType'])
        }
    }
    [int]$Frequency = switch ($matches['Octave']) {
        0 {$NoteIndex.$Pitch} # Beep() does not support any frequencies lower than 38
        1 {$NoteIndex.$Pitch | Where-Object {$_ -ge 32 -and $_ -le 62}} # using <38 for Rests
        2 {$NoteIndex.$Pitch | Where-Object {$_ -ge 65 -and $_ -le 124}}
        3 {$NoteIndex.$Pitch | Where-Object {$_ -ge 130 -and $_ -le 247}}
        4 {$NoteIndex.$Pitch | Where-Object {$_ -ge 261 -and $_ -le 494}}
        5 {$NoteIndex.$Pitch | Where-Object {$_ -ge 523 -and $_ -le 988}}
        6 {$NoteIndex.$Pitch | Where-Object {$_ -ge 1047 -and $_ -le 1978}}
        7 {$NoteIndex.$Pitch | Where-Object {$_ -ge 2093 -and $_ -le 3952}}
        8 {$NoteIndex.$Pitch | Where-Object {$_ -ge 4186 -and $_ -le 7902}}
        default {$NoteIndex.$Pitch | Where-Object {$_ -ge 523 -and $_ -le 988}}
    }
    if($Output){
        ($Pitch+$matches['Octave']+$matches['NoteType']+' - '+"${Durration}"+' - '+"${Frequency}")
    }
    if($Pitch -eq 'R'){
        Start-Sleep -Milliseconds $Durration
    }
    else{
        [console]::beep($Frequency,$Durration)
    }
    $Note = $null
    $Pitch = $null
    $Durration = $null
    $Frequency = $null
}
$Tempo = $null