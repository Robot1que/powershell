Get-CimInstance Win32_PnPEntity -Filter "Description = 'USB Input Device'" `
    | Invoke-CimMethod `
        -MethodName GetDeviceProperties `
        -Arguments @{ devicePropertyKeys = @("DEVPKEY_Device_BusReportedDeviceDesc") } `
    | Select-Object -ExpandProperty deviceProperties