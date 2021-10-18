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

$S1 = @"
                     (  ) (@@) ( ) (@) ()   @@  O   @@    O         @@      o        
                 (@@@)                                                               
            (    )                                                                   
         (@@@@)                                                                      
       (   )                                                                         
"@
$S2 = @"
                     (@@) (  ) (@) ( ) @@   O   @@   O    @@       O      @          
                 (   )                                                               
            (@@@@)                                                                   
         (    )                                                                      
       (@@@)                                                                         
"@
$S3 = @"
                     (   ) (@@@) (  ) (@@) ()   @@  O   @@    O      @@       o      
                (@@@@@)                                                              
            (    )                                                                   
        (@@@@@)                                                                      
       (   )                                                                         
"@
$S4 = @"
                   (@@@) (   ) (@@) (  ) @@   ()   @@   O    @@      O       @       
                (     )                                                              
          (@@@@@@)                                                                   
        (      )                                                                     
       (@@@)                                                                         
"@
$TE = @"
      ====        ________                 ___________                               
  _D _|  |_______/        \__I_I______===__|_________|                               
   |(_)---  |   H\________/ |   |         =|___ ___|                                 
   /     |  |   H  |  |     |   |          ||_| |_||                                 
  |      |  |   H  |__---------------------| [___] |                                 
  | ________|___H__/__|_____/[][]~\\_______|       |                                 
  |/ |   |-----------I_____I [][] []  D    |=======|__                               
"@
$T1 = @"
__/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y____________|__                               
 |/-=|___|=    ||    ||    ||    |_____/~\\___/                                      
   \_/     \O=====O=====O=====O_/      \_/                                           
"@
$T2 = @"
__/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y____________|__                               
 |/-=|___|=O=====O=====O=====O   |_____/~\\___/                                      
   \_/     \__/  \__/  \__/  \__/      \_/                                           
"@
$T3 = @"
__/ =| o |=-O=====O=====O=====O \ ____Y____________|__                               
 |/-=|___|=    ||    ||    ||    |_____/~\\___/                                      
   \_/     \__/  \__/  \__/  \__/      \_/                                           
"@
$T4 = @"
__/ =| o |=- O=====O=====O=====O\ ____Y____________|__                               
 |/-=|___|=    ||    ||    ||    |_____/~\\___/                                      
   \_/     \__/  \__/  \__/  \__/      \_/                                           
"@
$T5 = @"
__/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y____________|__                               
 |/-=|___|=   O=====O=====O=====O|_____/~\\___/                                      
   \_/     \__/  \__/  \__/  \__/      \_/                                           
"@
$T6 = @"
__/ =| o |=-~~\  /~~\  /~~\  /~~\ ____Y____________|__                               
 |/-=|___|=    ||    ||    ||    |_____/~\\___/                                      
   \_/     \_O=====O=====O=====O/      \_/                                           
"@
$C = @"
                              
                              
    _________________         
   _|                \______A 
 =|                        |  
 -|                        |  
__|________________________|_ 
|__________________________|_ 
   |_D__D__D_|  |_D__D__D_|   
    \_/   \_/    \_/   \_/    
"@
