主板温度

```powershell
function Get-Temperature {
    $t = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
    $returntemp = @()

    foreach ($temp in $t.CurrentTemperature)
    {


    $currentTempKelvin = $temp / 10
    $currentTempCelsius = $currentTempKelvin - 273.15

    $currentTempFahrenheit = (9/5) * $currentTempCelsius + 32

    $returntemp += $currentTempCelsius.ToString() + " C : " + $currentTempFahrenheit.ToString() + " F : " + $currentTempKelvin + "K"  
    }
    return $returntemp
}

Get-Temperature
```

CPU温度
```powershell
"CPU: $(((Get-CimInstance -Namespace root/WMI -ClassName MSAcpi_ThermalZoneTemperature)[0].CurrentTemperature - 2731.5) / 10) C"
```