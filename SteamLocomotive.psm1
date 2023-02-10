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
    | ________|___H__/__|_____/[][]~\\_______|       |   -|   PowerShell Express   |   
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

  #Bug: Does not return multidimensional array?
  static [system.management.automation.host.buffercell[,]] Deserialize([serializedbuffercellarray[]]$inputObject)
  {
    $Coord = @{X=($inputObject[0].Cells.Count - 1); Y=($inputObject.Count - 1)}
    $BCA = [system.management.automation.host.buffercell[,]]::new(($Coord.Y + 1), ($Coord.X + 1))
    for ($y = 0; $y -le $Coord.Y; $y++) {
      for ($x = 0; $x -le $Coord.X; $x++) {
        if ($y -eq $Coord.Y) {
          $BCA[$y, $x] = [system.management.automation.host.buffercell]$inputObject[$y].Cells[$x]
        }
        else {
          $BCA[$y, $x] = [system.management.automation.host.buffercell]$inputObject[$y].Cells[$x]
        }
      }
    }
    return ,$BCA
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

function Get-BufferCellArrayFromScreen {
  [cmdletbinding()]
  param(
    [int]$X1 = 0,
    [int]$Y1 = 1,
    [int]$X2 = $host.UI.RawUI.BufferSize.Width,
    [int]$Y2 = $host.UI.RawUI.BufferSize.Height - 1
  )
  $Rect = [system.management.automation.host.rectangle]::new(@{X=$X1; Y=$Y1}, @{X=$X2; Y=$Y2})
  $BCA = $host.UI.RawUI.getBufferContents($Rect)
  return ,$BCA
}

function ConvertTo-SerializedBufferCellArray {
  #Bug: Pipeline input not working until I figure out how to cast to multidimensional... 
  # Unable to cast object of type 'System.Management.Automation.Host.BufferCell[]' to type 'System.Management.Automation.Host.BufferCell[,]'.
  [cmdletbinding()]
  param(
      [parameter(valuefrompipeline)]
    [system.management.automation.host.buffercell[,]]$BufferCellArray,
      [validateset("Json", "Object", "Xml")]
    [string]$ExportAs = "Object"
  )
  process {
    $BCA += $BufferCellArray
  }
  end {
    Write-Verbose "X:$($BCA.getUpperBound(1)); Y:$($BCA.getUpperBound(0))"
    for ($y = 0; $y -le $BCA.getUpperBound(0); $y++) {
      Write-Verbose "Y=$($y)"
      $SBCA = [serializedbuffercellarray]::new($y)
      for ($x = 0; $x -le $BCA.getUpperBound(1); $x++) {
        $SBCA.Cells += [system.management.automation.host.buffercell]($BCA[$y, $x])
      }
      Write-Debug "$($SBCA.toString())"
      [serializedbuffercellarray[]]$SBCAs += $SBCA
    }
    switch ($ExportAs) {
      "Json" {
        return $($SBCAs | ConvertTo-Json -depth 3 -compress)
      }
      "Object" {
        return $SBCAs
      }
      "Xml" {
        return [system.management.automation.psserializer]::serialize($SBCAs, 3)
      }
    }
  }
}

function ConvertFrom-SerializedBufferCellArray {
  [cmdletbinding()]
  param(
      [parameter(valuefrompipeline)]
    [object[]]$SerializedBufferCellArray
  )
  process {
    $SBCA += $SerializedBufferCellArray
  }
  end {
    if ($SBCA.Length -eq 1 -and [regex]::match($SBCA, '<T>SerializedBufferCellArray\[\]<\/T>').Success) {
      Write-Verbose "Match: Xml"
      $SBCA = [system.management.automation.psserializer]::deserialize($SBCA)
    }
    if ([regex]::match($SBCA, '\[{Index:').Success) {
      Write-Verbose "Match: Json"
      $SBCA = ConvertFrom-Json ($SBCA | Out-String)
    }
    $Coord = @{X=($SBCA[0].Cells.Count - 1); Y=($SBCA.Count - 1)}
    Write-Verbose "X:$($Coord.X); Y:$($Coord.Y)"
    $BCA = [system.management.automation.host.buffercell[,]]::new(($Coord.Y + 1), ($Coord.X + 1))
    for ($y = 0; $y -le $Coord.Y; $y++) {
      Write-Verbose "Y=$($y)"
      for ($x = 0; $x -le $Coord.X; $x++) {
        if ($y -eq $Coord.Y) {
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

function Compress-JsonBufferCellArray {
  [cmdletbinding()]
  param(
      [parameter(valuefrompipeline)]
    [string[]]$InputObject
  )
  process {
    $Object += $InputObject
  }
  end {
    $Object = [regex]::replace($Object, '"Character"',         '~1')
    $Object = [regex]::replace($Object, '"ForegroundColor"',   '~2')
    $Object = [regex]::replace($Object, '"BackgroundColor"',   '~3')
    $Object = [regex]::replace($Object, '"BufferCellType"',    '~4')
    $Object = [regex]::replace($Object, '"Index"',             '~5')
    $Object = [regex]::replace($Object, '"Cells"',             '~6')
    $Object = [regex]::replace($Object, '~2:7,~3:0,~4:0',      '~7')
    $Object = [regex]::replace($Object, '~1:" ",~7',           '~8')
    return $Object
  }
}

function Expand-JsonBufferCellArray {
  [cmdletbinding()]
  param(
      [parameter(valuefrompipeline)]
    [string[]]$InputObject
  )
  process {
    $Object += $InputObject
  }
  end {
    $Object = [regex]::replace($Object, '~8', '~1:" ",~7')
    $Object = [regex]::replace($Object, '~7', '~2:7,~3:0,~4:0')
    $Object = [regex]::replace($Object, '~6', "Cells")
    $Object = [regex]::replace($Object, '~5', "Index")
    $Object = [regex]::replace($Object, '~4', "BufferCellType")
    $Object = [regex]::replace($Object, '~3', "BackgroundColor")
    $Object = [regex]::replace($Object, '~2', "ForegroundColor")
    $Object = [regex]::replace($Object, '~1', "Character")
    return $Object
  }
}

function Import-JsonBufferCellArray {
  [cmdletbinding()]
  param(
    [string]$Path
  )
  $BCA = Get-Content -path $Path -raw -errorAction 'Stop' `
    | Expand-JsonBufferCellArray `
    | ConvertFrom-SerializedBufferCellArray
  return ,$BCA
}

function Export-JsonBufferCellArray {
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
    ConvertTo-SerializedBufferCellArray -bufferCellArray $BCA -ExportAs Json `
      | Compress-JsonBufferCellArray `
      | Set-Content -path $Path
  }
}

function Start-SteamLocomotive {
  $SL1 = Import-JsonBufferCellArray -path "$($PSScriptRoot)\SL1.sbca"
  $SL2 = Import-JsonBufferCellArray -path "$($PSScriptRoot)\SL2.sbca"
  $SL3 = Import-JsonBufferCellArray -path "$($PSScriptRoot)\SL3.sbca"
  $SL4 = Import-JsonBufferCellArray -path "$($PSScriptRoot)\SL4.sbca"
  $SL5 = Import-JsonBufferCellArray -path "$($PSScriptRoot)\SL5.sbca"
  $SL6 = Import-JsonBufferCellArray -path "$($PSScriptRoot)\SL6.sbca"
  $SLE = Import-JsonBufferCellArray -path "$($PSScriptRoot)\SLE.sbca"

  $y = $host.UI.RawUI.CursorPosition.Y + 1
  $x = $host.UI.RawUI.WindowSize.Width - 1
  $c = @{X=$x; Y=$y}
  $a = $true
  while ($true) {
    $c.X = ($c.X - 2)
    if ($c.X -eq 0 -or $c.X -eq 1) {
      $host.UI.RawUI.setBufferContents($c, $SLE)
      break
    }
    switch (($c.X % 3)) {
      0 {
        if ($a) {
          $host.UI.RawUI.setBufferContents($c, $SL2)
        }
        else {
          $host.UI.RawUI.setBufferContents($c, $SL5)
        }
      }
      1 {
        if ($a) {
          $host.UI.RawUI.setBufferContents($c, $SL1)
        }
        else {
          $host.UI.RawUI.setBufferContents($c, $SL4)
        }
      }
      2 {
        if ($a) {
          $host.UI.RawUI.setBufferContents($c, $SL6)
          $a = $false
        }
        else {
          $host.UI.RawUI.setBufferContents($c, $SL3)
          $a = $true
        }
      }
    }
    Start-Sleep -m 1
  }
}
