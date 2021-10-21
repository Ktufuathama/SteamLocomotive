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

## Functions
- Start-SteamLocomotive
- ConvertTo-BufferCellArray
- ConvertFrom-SerializedBufferCellArray
- ConvertTo-SerializedBufferCellArray
- Compress-BufferCellArray
- Expand-BufferCellArray
- Export-BufferCellArray
- Import-BufferCellArray
- Invoke-Serializer

**You will need to override the built in alias 'SL'. Example below could be placed in your profile.**
```powershell
Set-Alias -name 'sl' -value Start-SteamLocomotive -option 'AllScope' -scope 'Global' -force
```
