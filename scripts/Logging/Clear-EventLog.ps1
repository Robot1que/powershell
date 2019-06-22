Get-CimInstance `
    -ClassName Win32_NTEventlogFile `
    -Filter "FileName = 'Application'" `
    | Invoke-CimMethod -MethodName ClearEventLog