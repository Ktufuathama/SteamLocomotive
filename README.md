# SteamLocomotive
Simple PowerShell implementation of the Linux SL command.

```
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
```

**You will need to override the built in alias 'SL'. Example below could be placed in your profile.**
```powershell
Set-Alias -name 'sl' -value Start-SteamLocomotive -option 'AllScope' -scope 'Global' -force
```

## Function(s)
- Start-SteamLocomotive
- Compress-JsonBufferCellArray
- ConvertFrom-SerializedBufferCellArray
- ConvertTo-BufferCellArray
- ConvertTo-SerializedBufferCellArray
- Expand-JsonBufferCellArray
- Export-JsonBufferCellArray
- Get-BufferCellArrayFromScreen
- Import-JsonBufferCellArray

## Class(es)
- SerializedBufferCellArray

## Example
#### Example getting and setting the buffer.
![2023-01-19_BCA_1](https://user-images.githubusercontent.com/31010254/213634094-946dac6c-e760-420b-8768-7d05fa61ac89.png)

#### Example serializing and deserializing the BufferCell array. This is a simple way to save the buffercell for later use.
![2023-01-19_BCA_2](https://user-images.githubusercontent.com/31010254/213637639-dbd5c2e1-1c7c-4825-bcce-457e3ec80936.png)
