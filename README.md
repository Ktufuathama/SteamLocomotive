# SteamLocomotive
Simple PowerShell implementation of the Linux SL command.

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

**You will need to override the build in alias 'SL'. Example below could be placed in your profile.**
```powershell
Set-Alias -name 'sl' -value Start-SteamLocomotive -option 'AllScope' -scope 'Global' -force
```
