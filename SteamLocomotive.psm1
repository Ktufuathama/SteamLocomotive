
<#
 == SteamLocomotive ==
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
#>

class SerializedBufferCellArray
{
  [int]$Index = 0
  [system.management.automation.host.buffercell[]]$Cells

  SerializedBufferCellArray([int]$index)
  {
    $this.Index = $index
  }

  SerializedBufferCellArray([int]$index, [system.management.automation.host.buffercell[]]$bufferCellArray)
  {
    $this.Index = $index
    $this.Cells = $bufferCellArray
  }

  [string] ToString()
  {
    return [string]($this.Cells.Character -join '')
  }

  static [serializedbuffercellarray[]] Serialize([system.management.automation.host.buffercell[,]]$inputObject)
  {
    for ($y = 0; $y -le $inputObject.getUpperBound(0); $y++) {
      $SBCA = [serializedbuffercellarray]::new($y)
      for ($x = 0; $x -le $inputObject.getUpperBound(1); $x++) {
        $SBCA.Cells += [system.management.automation.host.buffercell]($inputObject[$y, $x])
      }
      [serializedbuffercellarray[]]$SBCAs += $SBCA
    }
    return $SBCAs
  }

  #Bug:Does not return multidimensional array?
  static [system.management.automation.host.buffercell[,]] Deserialize([serializedbuffercellarray[]]$inputObject)
  {
    $a = @{X=($inputObject[0].Cells.Count - 1);Y=($inputObject.Count - 1)}
    Write-Verbose "y:$($a.Y); x:$($a.X)"
    $BCA = [system.management.automation.host.buffercell[,]]::new(($a.Y + 1), ($a.X + 1))
    for ($y = 0; $y -le $a.Y; $y++) {
      Write-Verbose "y:$($y)"
      for ($x = 0; $x -le $a.X; $x++) {
        if ($y -eq $a.Y) {
          $BCA[$y, $x] = [system.management.automation.host.buffercell]$inputObject[$y].Cells[$x]
        }
        else {
          $BCA[$y, $x] = [system.management.automation.host.buffercell]$inputObject[$y].Cells[$x]
        }
      }
    }
    return $BCA
  }
}

function ConvertTo-BufferCellArray {
  [cmdletbinding()]
  param(
    [string]$InputObject
  )
  $a = @{
    Y = $InputObject.split("`n").Count
    X = $InputObject.split("`n")[0].Length
  }
  $InputObject = $InputObject.replace("`n", "").replace("`r", "")
  $BCA = [system.management.automation.host.buffercell[,]]::new($a.Y, $a.X)
  $i = 0
  Write-Verbose "X=$($a.X);Y=$($a.Y)"
  for ($y = 0; $y -lt $a.Y; $y++) {
    for ($x = 0; $x -lt $a.X; $x++) {
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

function ConvertTo-SerializedBufferCellArray {
  [cmdletbinding()]
  param(
      [parameter(valuefrompipeline)]
    [system.management.automation.host.buffercell[,]]$BufferCellArray
  )
  process {
    $BCA += $BufferCellArray
  }
  end {
    Write-Verbose "y:$($BCA.getUpperBound(0)); x:$($BCA.getUpperBound(1))"
    for ($y = 0; $y -le $BCA.getUpperBound(0); $y++) {
      Write-Verbose "y:$($y)"
      $SBCA = [serializedbuffercellarray]::new($y)
      for ($x = 0; $x -le $BCA.getUpperBound(1); $x++) {
        $SBCA.Cells += [system.management.automation.host.buffercell]($BCA[$y, $x])
      }
      Write-Debug "$($SBCA.toString())"
      [serializedbuffercellarray[]]$SBCAs += $SBCA
    }
    return $SBCAs
  }
}

function ConvertFrom-SerializedBufferCellArray {
  [cmdletbinding()]
  param(
    #[serializedbuffercellarray[]]
      [parameter(valuefrompipeline)]
    [object[]]$SerializedBufferCellArray
  )
  process {
    $SBCA += $SerializedBufferCellArray
  }
  end {
    $a = @{ X=($SBCA[0].Cells.Count - 1); Y=($SBCA.Count - 1) }
    Write-Verbose "y:$($a.Y); x:$($a.X)"
    $BCA = [system.management.automation.host.buffercell[,]]::new(($a.Y + 1), ($a.X + 1))
    for ($y = 0; $y -le $a.Y; $y++) {
      Write-Verbose "y:$($y)"
      for ($x = 0; $x -le $a.X; $x++) {
        if ($y -eq $a.Y) {
          $BCA[$y, $x] = [system.management.automation.host.buffercell]$SBCA[$y].Cells[$x]
        }
        else {
          $BCA[$y, $x] = [system.management.automation.host.buffercell]$SBCA[$y].Cells[$x]
        }
      }
    }
    return ,$BCA
  }
}

function Compress-BufferCellArray {
  [cmdletbinding()]
  param(
      [parameter(valuefrompipeline)]
    [string[]]$InputObject
  )
  process {
    $Object += $InputObject
  }
  end {
    $Object = [regex]::replace($Object, '"Character":"',        '~1')
    $Object = [regex]::replace($Object, '","ForegroundColor":', '~2')
    $Object = [regex]::replace($Object, ',"BackgroundColor":',  '~3')
    $Object = [regex]::replace($Object, ',"BufferCellType":',   '~4')
    $Object = [regex]::replace($Object, '"Index"',              '~5')
    $Object = [regex]::replace($Object, '"Cells"',              '~6')
    return $Object
  }
}

function Expand-BufferCellArray {
  [cmdletbinding()]
  param(
      [parameter(valuefrompipeline)]
    [string[]]$InputObject
  )
  process {
    $Object += $InputObject
  }
  end {
    $Object = [regex]::replace($Object, '~1', '"Character":"')
    $Object = [regex]::replace($Object, '~2', '","ForegroundColor":')
    $Object = [regex]::replace($Object, '~3', ',"BackgroundColor":')
    $Object = [regex]::replace($Object, '~4', ',"BufferCellType":')
    $Object = [regex]::replace($Object, '~5', '"Index"')
    $Object = [regex]::replace($Object, '~6', '"Cells"')
    return $Object
  }
}

function Export-BufferCellArray {
  [cmdletbinding()]
  param(
      [parameter(valuefrompipeline)]
    [system.management.automation.host.buffercell[,]]$BufferCellArray,
    [string]$Path
  )
  process {
    $BCA += $BufferCellArray
  }
  end {
    [serializedbuffercellarray[]]$SBCA = ConvertTo-SerializedBufferCellArray -bufferCellArray $BCA
    $SBCA `
      | ConvertTo-Json -depth 10 -compress `
      | Compress-BufferCellArray `
      | Set-Content -path $Path
  }
}

function Import-BufferCellArray {
  [cmdletbinding()]
  param(
    [string]$Path
  )
  $BCA = Get-Content -path $Path -raw -errorAction 'Stop' `
    | Expand-BufferCellArray `
    | ConvertFrom-Json `
    | ConvertFrom-SerializedBufferCellArray
  return ,$BCA
}

function Invoke-Serializer {
  [cmdletbinding()]
  param(
    [parameter(valuefrompipeline)]
    [object]$InputObject,
    [switch]$Deserialize
  )
  process {
    if ($Deserialize) {
      $Return = [system.management.automation.psserializer]::deserialize($InputObject)
    }
    else {
      $Return = [system.management.automation.psserializer]::serialize($InputObject)
    }
  }
  end {
    return $Return
  }
}

function Start-SteamLocomotive {
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
  $TE = 
@"
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
                                                                                       
"@
  $B1 = ConvertTo-BufferCellArray $T1
  $B2 = ConvertTo-BufferCellArray $T2
  $B3 = ConvertTo-BufferCellArray $T3
  $B4 = ConvertTo-BufferCellArray $T4
  $B5 = ConvertTo-BufferCellArray $T5
  $B6 = ConvertTo-BufferCellArray $T6
  $BE = ConvertTo-BufferCellArray $TE
  $y = $host.UI.RawUI.CursorPosition.Y + 1
  $x = $host.UI.RawUI.WindowSize.Width - 1
  $c = @{ x = $x; y = $y }
  $a = $true
  while ($true) {
    $c.X = ($c.X - 2)
    if ($c.X -eq 0 -or $c.X -eq 1) {
      $host.UI.RawUI.setBufferContents($c, $BE)
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
    Start-Sleep -m 1
  }
}

<#
  $Coord = @{x=0;y=0}
  while ($true) {
    switch ($host.UI.RawUI.readKey().Character) {
      'd' { if ($Coord.X -le ($host.UI.RawUI.WindowSize.Width - 1)) {$Coord.X++} }
      'a' { if ($Coord.X -gt 0) {$Coord.X--} }
      'w' { if ($Coord.Y -gt 0) {$Coord.Y--} }
      's' { if ($Coord.Y -le $host.UI.RawUI.WindowSize.Height) {$Coord.Y++} }
    }
  }
#>
