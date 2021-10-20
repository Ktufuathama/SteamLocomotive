
<#
                                                                                     
                                                                                     
                                                                                     
                                                                                     
                                                                                     
      ====        ________                 ___________                               
  _D _|  |_______/        \__I_I______===__|_________|                               
   |(_)---  |   H\________/ |   |         =|___ ___|      _________________          
   /     |  |   H  |  |     |   |          ||_| |_||     _|                \______A  
  |      |  |   H  |__---------------------| [___] |   =|                        |   
  | ________|___H__/__|_____/[][]~\\_______|       |   -|                        |   
  |/ |   |-----------I_____I [][] []  D    |=======|____|________________________|_  
__/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y____________|__|__________________________|_  
 |/-=|___|=    ||    ||    ||    |_____/~\\___/         |_D__D__D_|  |_D__D__D_|     
   \_/     \O=====O=====O=====O_/      \_/               \_/   \_/    \_/   \_/      
#>
function Start-SteamLocomotive {
  <#
    $Coord = @{x=0;y=0}
    while ($true) {
      switch ($host.UI.RawUI.readKey().Character) {
        'd' { if ($Coord.X -le ($host.UI.RawUI.WindowSize.Width - 1)) {$Coord.X++} }
        'a' { if ($Coord.X -gt 0) {$Coord.X--} }
        'w' { if ($Coord.Y -gt 0) {$Coord.Y--} }
        's' { if ($Coord.Y -le $host.UI.RawUI.WindowSize.Height) {$Coord.Y++} }
      }
      #BoundsLogic
      $host.UI.RawUI.setBufferContents($Coord, $B1)
    }
  #>
  $T1 = 
@"
                     (@@@) (   ) (@@) (  ) @@   ()   @@   O    @@      O       @       
                  (     )                                                              
            (@@@@@@)                                                                   
          (      )                                                                     
         (@@@)                                                                         
        ====        ________                 ___________                               
    _D _|  |_______/        \__I_I______===__|_________|                               
     |(_)---  |   H\________/ |   |         =|___ ___|      _________________          
     /     |  |   H  |  |     |   |          ||_| |_||     _|                \______A  
    |      |  |   H  |__---------------------| [___] |   =|                        |   
    | ________|___H__/__|_____/[][]~\\_______|       |   -|                        |   
    |/ |   |-----------I_____I [][] []  D    |=======|____|________________________|_  
  __/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y____________|__|__________________________|_  
   |/-=|___|=    ||    ||    ||    |_____/~\\___/         |_D__D__D_|  |_D__D__D_|     
     \_/     \_O=====O=====O=====O/      \_/               \_/   \_/    \_/   \_/      
"@
  $T2 = 
@"
                       (   ) (@@@) (  ) (@@) ()   @@  O   @@    O      @@       o      
                  (@@@@@)                                                              
              (    )                                                                   
          (@@@@@)                                                                      
         (   )                                                                         
        ====        ________                 ___________                               
    _D _|  |_______/        \__I_I______===__|_________|                               
     |(_)---  |   H\________/ |   |         =|___ ___|      _________________          
     /     |  |   H  |  |     |   |          ||_| |_||     _|                \______A  
    |      |  |   H  |__---------------------| [___] |   =|                        |   
    | ________|___H__/__|_____/[][]~\\_______|       |   -|                        |   
    |/ |   |-----------I_____I [][] []  D    |=======|____|________________________|_  
  __/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y____________|__|__________________________|_  
   |/-=|___|=    O=====O=====O=====O_____/~\\___/         |_D__D__D_|  |_D__D__D_|     
     \_/     \__/  \__/  \__/  \__/      \_/               \_/   \_/    \_/   \_/      
"@
  $T3 = 
@"
                       (@@) (  ) (@) ( ) @@   O   @@   O    @@       O      @          
                   (   )                                                               
              (@@@@)                                                                   
           (    )                                                                      
         (@@@)                                                                         
        ====        ________                 ___________                               
    _D _|  |_______/        \__I_I______===__|_________|                               
     |(_)---  |   H\________/ |   |         =|___ ___|      _________________          
     /     |  |   H  |  |     |   |          ||_| |_||     _|                \______A  
    |      |  |   H  |__---------------------| [___] |   =|                        |   
    | ________|___H__/__|_____/[][]~\\_______|       |   -|                        |   
    |/ |   |-----------I_____I [][] []  D    |=======|____|________________________|_  
  __/ =| o |=-~O=====O=====O=====O\ ____Y____________|__|__________________________|_  
   |/-=|___|=    ||    ||    ||    |_____/~\\___/         |_D__D__D_|  |_D__D__D_|     
     \_/     \__/  \__/  \__/  \__/      \_/               \_/   \_/    \_/   \_/      
"@
  $T4 = 
@"
                       (  ) (@@) ( ) (@) ()   @@  O   @@    O         @@      o        
                   (@@@)                                                               
              (    )                                                                   
           (@@@@)                                                                      
         (   )                                                                         
        ====        ________                 ___________                               
    _D _|  |_______/        \__I_I______===__|_________|                               
     |(_)---  |   H\________/ |   |         =|___ ___|      _________________          
     /     |  |   H  |  |     |   |          ||_| |_||     _|                \______A  
    |      |  |   H  |__---------------------| [___] |   =|                        |   
    | ________|___H__/__|_____/[][]~\\_______|       |   -|                        |   
    |/ |   |-----------I_____I [][] []  D    |=======|____|________________________|_  
  __/ =| o |=-O=====O=====O=====O~\ ____Y____________|__|__________________________|_  
   |/-=|___|=    ||    ||    ||    |_____/~\\___/         |_D__D__D_|  |_D__D__D_|     
     \_/     \__/  \__/  \__/  \__/      \_/               \_/   \_/    \_/   \_/      
"@
  $T5 = 
@"
                       (   ) (@@@) (  ) (@@) ()   @@  O   @@    O      @@       o      
                  (@@@@@)                                                              
              (    )                                                                   
          (@@@@@)                                                                      
         (   )                                                                         
        ====        ________                 ___________                               
    _D _|  |_______/        \__I_I______===__|_________|                               
     |(_)---  |   H\________/ |   |         =|___ ___|      _________________          
     /     |  |   H  |  |     |   |          ||_| |_||     _|                \______A  
    |      |  |   H  |__---------------------| [___] |   =|                        |   
    | ________|___H__/__|_____/[][]~\\_______|       |   -|                        |   
    |/ |   |-----------I_____I [][] []  D    |=======|____|________________________|_  
  __/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y____________|__|__________________________|_  
   |/-=|___|=O=====O=====O=====O   |_____/~\\___/         |_D__D__D_|  |_D__D__D_|     
     \_/     \__/  \__/  \__/  \__/      \_/               \_/   \_/    \_/   \_/      
"@
  $T6 = 
@"
                     (@@@) (   ) (@@) (  ) @@   ()   @@   O    @@      O       @       
                  (     )                                                              
            (@@@@@@)                                                                   
          (      )                                                                     
         (@@@)                                                                         
        ====        ________                 ___________                               
    _D _|  |_______/        \__I_I______===__|_________|                               
     |(_)---  |   H\________/ |   |         =|___ ___|      _________________          
     /     |  |   H  |  |     |   |          ||_| |_||     _|                \______A  
    |      |  |   H  |__---------------------| [___] |   =|                        |   
    | ________|___H__/__|_____/[][]~\\_______|       |   -|                        |   
    |/ |   |-----------I_____I [][] []  D    |=======|____|________________________|_  
  __/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y____________|__|__________________________|_  
   |/-=|___|=    ||    ||    ||    |_____/~\\___/         |_D__D__D_|  |_D__D__D_|     
     \_/     \O=====O=====O=====O_/      \_/               \_/   \_/    \_/   \_/      
"@
  $TD = 
@"
                                        @                                              
          * @       *     ^        *   *                                               
             *@       *        *@ *                                                    
               # @*   *    * *#@*                                                      
            *@  # *@ **# @#*    @*  *                                                  
        ====   *   *_*#_*_*_* @ @     *      ___________                               
    _D _|  |____*__/  *     \*_*_I_*_*__===__|_________|                               
     |(_)---  |    H\#__#___* |   |         =|___ ___|      _________________          
     /     |  |  @   |  |     |   |          ||_| |_||     _|                \______A  
    |      |  |   H  |__---------------------| [___] |   =|                        |   
    | ________|___H__/__|_____/[][]~\\_______|       |   -|                        |   
    |/ |   |-----------I_____I [][] []  D    |=======|____|________________________|_  
  __/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y____________|__|__________________________|_  
   |/-=|___|=    ||    ||    ||    |_____/~\\___/         |_D__D__D_|  |_D__D__D_|     
     \_/     \O=====O=====O=====O_/      \_/               \_/   \_/    \_/   \_/      
"@
  $B1 = ConvertTo-BufferCellArray $T1
  $B2 = ConvertTo-BufferCellArray $T2
  $B3 = ConvertTo-BufferCellArray $T3
  $B4 = ConvertTo-BufferCellArray $T4
  $B5 = ConvertTo-BufferCellArray $T5
  $B6 = ConvertTo-BufferCellArray $T6
  $BD = ConvertTo-BufferCellArray $TD
  Clear-Host
  $c = @{x=($host.UI.RawUI.WindowSize.Width - 1);y=2}
  $a = $true
  while ($true) {
    $c.X = ($c.X - 2)
    if ($c.X -eq 0 -or $c.X -eq 1) {
      $host.UI.RawUI.setBufferContents($c, $BD)
      break
    }
    switch (($c.X % 3)) {
      0 {
        if ($a) {
          $host.UI.RawUI.setBufferContents($c, $B2)
        }
        else {
          $host.UI.RawUI.setBufferContents($c, $B5)
        }
      }
      1 {
        if ($a) {
          $host.UI.RawUI.setBufferContents($c, $B1)
        }
        else {
          $host.UI.RawUI.setBufferContents($c, $B4)
        }
      }
      2 {
        if ($a) {
          $host.UI.RawUI.setBufferContents($c, $B6)
          $a = $false
        }
        else {
          $host.UI.RawUI.setBufferContents($c, $B3)
          $a = $true
        }
      }
    }
    Start-Sleep -m 5
  }
  Clear-Host
}

function Export-BufferCellArray {
  [cmdletbinding()]
  param(
    [system.management.automation.host.buffercell[,]]$BCA,
    [string]$Path
  )
  $Bounds = @{
    X = $BCA.getUpperBound(1)
    Y = $BCA.getUpperBound(0)
  }
  $Data = $Bounds, $BCA | ConvertTo-Json
  Set-Content -path $Path -value $Data
}

function Import-BufferCellArray {
  [cmdletbinding()]
  param(
    [string]$Path
  )
  $Data = Get-Content -path $Path -raw | ConvertFrom-Json
  $BCA = [system.management.automation.host.buffercell[,]]::new($Data[0].Y + 1, $Data[0].X + 1)
  $i = 0
  Write-Verbose "X=$($BCA.getUpperBound(0));Y=$($BCA.getUpperBound(1))"
  for ($y = 0; $y -lt $Data[0].Y + 1; $y++) {
    for ($x = 0; $x -lt $Data[0].X + 1; $x++) {
      Write-Verbose "x=$($x);y=$($y);i=$($i)"
      $D = $Data[1][$i]
      $BCA[$y, $x] = [system.management.automation.host.buffercell]::new(
        $D.Character,
        $D.ForegroundColor,
        $D.BackgroundColor,
        $D.BufferCellType)
      $i++
    }
  }
  return ,$BCA
}

function ConvertTo-BufferCellArray {
  [cmdletbinding()]
  param(
    [string]$InputObject
  )
  $Bounds = @{
    Y = $InputObject.split("`n").Count
    X = $InputObject.split("`n")[0].Length
  }
  $InputObject = $InputObject.replace("`n", "").replace("`r", "")
  $BCA = [system.management.automation.host.buffercell[,]]::new($Bounds.Y, $Bounds.X)
  $i = 0
  Write-Verbose "X=$($Bounds.X);Y=$($Bounds.Y)"
  for ($y = 0; $y -lt $Bounds.Y; $y++) {
    for ($x = 0; $x -lt $Bounds.X; $x++) {
      Write-Verbose "x=$($x);y=$($y);i=$($i)"
      $BCA[$y, $x] = [system.management.automation.host.buffercell]::new(
        $InputObject.toCharArray()[$i],
        $host.UI.RawUI.ForegroundColor,
        $host.UI.RawUI.BackgroundColor,
        [system.management.automation.host.buffercelltype]::Complete)
      $i++
    }
  }
  return ,$BCA
}

#WIP: Second merged object appears almost trimmed before and after.
function Merge-BufferCellArray {
  [cmdletbinding()]
  param(
    [system.management.automation.host.buffercell[,]]$BCA1,
    [system.management.automation.host.buffercell[,]]$BCA2
  )
  $Bounds = @{X=0;Y=0}
  if ($BCA1.getUpperBound(1) -gt $BCA2.getUpperBound(1)) {
    $Bounds.X = $BCA1.getUpperBound(1)
  }
  else {
    $Bounds.X = $BCA2.getUpperBound(1)
  }
  $Bounds.Y = $BCA1.getUpperBound(0) + $BCA2.getUpperBound(0)
  $BCA = [system.management.automation.host.buffercell[,]]::new($Bounds.Y, $Bounds.X)
  $i = 0
  $o = $true
  for ($y = 0; $y -lt $Bounds.Y; $y++) {
    if ($y -le $BCA1.getUpperBound(0)) {
      for ($x = 0; $x -lt $BCA1.getUpperBound(1); $x++) {
        Write-Verbose "OBJ1: x=$($x);y=$($y);i=$($i)"
        $BCA[$y, $x] = $BCA1[$y, $x]
        $i++
      }
    }
    else {
      if ($o = $true) {
        $i = 0
        $o = $false
      }
      for ($x = 0; $x -lt $BCA2.getUpperBound(1); $x++) {
        Write-Verbose "OBJ2: x=$($x);y=$($y);i=$($i)"
        $BCA[$y, $x] = $BCA2[($y - $BCA1.getUpperBound(0)), $x]
        $i++
      }
    }
  }
  <#
    if ($BCA1.getUpperBound(0) -gt $BCA2.getUpperBound(0)) {
      $Bounds.Y = $BCA1.getUpperBound(0)
    }
    else {
      $Bounds.Y = $BCA2.getUpperBound(0)
    }
  #>
  return ,$BCA
}
