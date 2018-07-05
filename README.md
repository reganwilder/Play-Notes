# Play-Notes

## Description

A simple PowerShell function that lets you write/play songs in musical notation using the Beep() function in windows.

## Custom Musical Notation

For each note, the script will split your input into 3 parts.

- The Pitch
  - `C,C#,D,Eb,E,F,F#,G,G#,A,Bb,B`
- The Octave
  - `0,1,2,3,4,5,6,7,8`
  - Default = 5
- The Duration (Or NoteType)
  - `W,H,Q,E,S`
  - Default = Q

The line for this looks like..

```PowerShell
$Note -match '(?<Pitch>[A-G][#|b]?|[R])(?<Octave>[0-8])?(?<NoteType>[Ww|Hh|Qq|Ee|Ss][\.]?)?'
```

## Notes

- I recommend making a new line for each line in the sheet music you use.
- No support for tied notes, but you can get creative. ;)
- I made a few song excepts for y'all to get started!
- Including -Output for debugging may add a few ms of pause due to Write-Output
- **If you enjoy this silly script and make your own songs, please share them with me!**

## Usage Examples

### Song: Still Alive Excerpt - Portal

Source: `https://musescore.com/user/12125/scores/21060`

```PowerShell
.\Play-Notes.ps1 -Notes "R0H,G6E,F#6E,E6E,E6E,F#6H,R0H,R0Q,R0E,A5E,G6E,F#6E,E6E,E6E,F#6Q.,D6Q,E6E"
.\Play-Notes.ps1 -Notes "A5H,R5E,R0Q.,A5E,E6Q,F#6E,G6Q.,E6E,C#6Q,D6Q.,E6Q,A5E,A5Q,F#6Q.,R0H"
.\Play-Notes.ps1 -Notes "R0H,G6E,F#6E,E6E,E6E,F#6H,R0H,R0Q,R0E,A5E,G6E,F#6E,E6E,E6Q,F#6E,D6Q.,E6E"
.\Play-Notes.ps1 -Notes "A5H,R5E,R0Q.,E6Q,F#6E,G6Q.,E6E,C#6Q.,D6E,E6Q,A5E,D6E,E6E"
.\Play-Notes.ps1 -Notes "F6E,E6E,D6E,C6E,R0Q,A5E,Bb5E,C6Q,F6Q,E6E,D6E,D6E,C6E,D6E,C6E,C6Q,C6Q,A5E,Bb5E"
.\Play-Notes.ps1 -Notes "C6Q,F6Q,G6E,F6E,E6E,D6E,D6E,E6E,F6Q,F6Q,G6E,A6E,Bb6E,Bb6E,A6Q,G6Q,F6E,G6E"
.\Play-Notes.ps1 -Notes "A6E,A6E,G6Q,F6Q,D6E,C6E,D6E,F6E,F6E,E6Q,E6E,F#6E,F#6Q."
.\Play-Notes.ps1 -Notes "A6E,A6E,G6Q,F6Q,D6E,C6E,D6E,F6E,F6E,E6Q,E6E,F#6E,F#6H"
.\Play-Notes.ps1 -Notes "G6E,A6E,A6Q,R0Q,R0E,G6E,F#6E,F#6Q"
.\Play-Notes.ps1 -Notes "G6E,A6E,A6Q,R0Q,R0E,G6E,F#6E,F#6Q"
```

### Song: Overworld Excerpt - Super Mario Brothers

```PowerShell
.\Play-Notes.ps1 -Notes "E6E,E6E,R0E,E6E,R0E,A5E,E6E,R0E,G6E,R0E,R0Q,G5E,R0E,R0Q" -Tempo 120
```

## Other examples

### All Supported Pitch Frequencies

```PowerShell
@('1','2','3','4','','6','7','8') | %{
    .\Play-Notes.ps1 -Notes ("CN,C#N,DN,EbN,EN,FN,F#N,GN,G#N,AN,BbN,BN" -replace '[N]',$_) -Output
}
```

### Limitation of Tempo/Duration

- There is a fixed amount of time between Beep() calls so you can only go so fast..

```PowerShell
@('5') | %{
    $p = $_
    @('S','S.','E','E.','Q','Q.','H','H.','W') | %{
        .\Play-Notes.ps1 -Notes (
            (
                "CNT,C#NT,DNT,EbNT,ENT,FNT,F#NT,GNT,G#NT,ANT,BbNT,BNT" -replace '[N]',$p
            ) -replace '[T]',$_
        ) -Output
    }
}
```

### Attempt at a Multi-Track example using the PoshRsJobs Module

```PowerShell
Import-Module PoshRSJob
$Track1 = [pscustomobject]@{
    Name = 'Track1'
    Track = 'R0H,G6E,F#6E,E6E,E6E,F#6H,R0H,R0Q,R0E,A5E,G6E,F#6E,E6E,E6E,F#6Q.,D6Q,E6E,A5H'
}
$Track2 = [pscustomobject]@{
    Name = 'Track2'
    Track = "R0H,G5E,F#5E,E5E,E5E,F#5H,R0H,R0Q,R0E,A4E,G5E,F#5E,E5E,E5E,F#5Q.,D5Q,E5E,A4H"
}
@($Track1,$Track2) | Start-RSJob -Name {$_.Name} -ScriptBlock {
    .\Play-Notes.ps1 $_.Track
} | Get-RSJob | Wait-RSJob
Get-RSJob | Remove-RSJob -Force
```

Doesn't work sadly.. The Beep() function only lets one beep happen at a time globally.

To any nerds at MSFT reading this, please create a feature request for this please! XD

Or if anyone can figure it out, please share!