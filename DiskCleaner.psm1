Function Add-CleanupRegistryValues {
    <#
        .NAME

        Add-CleanupRegistryValues
        .DESCRIPTION
        
        This function is used to generate the registry values needed in order for disk cleanup to be run without user interraction in the GUI.
        .Example

        Add-CleanupRegistryValues
        .Example

        Add-CleanupRegistryValues -regValueName "0095"
        .registryValue

        Enter a number from 0001-9999 here. For more information, see the related links.
        .RELATED LINKS

        https://support.microsoft.com/en-us/help/253597/automating-disk-cleanup-tool-in-windows
    #>

    [CmdletBinding()]
    PARAM(
        [string]$registryValue = "0099"
    )

    BEGIN {
        $regValueName = "StateFlags" + $($registryValue)
    }

    PROCESS {
        $parentRegPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches'
        Get-ChildItem -Path $parentRegPath -Force | ForEach-Object -Process {
            New-ItemProperty -Path $_.PSPath -Name $regValueName -Value 2 -PropertyType "DWord" -Force
        }
    }
}


Function Enter-CleanupSession {
    <#
        .NAME
        
        Enter-CleanupSession
        .DESCRIPTION

        This is meant to be used after the Add-CleanupRegistryValues function in order to launch an automated version of Disk Cleanup.
        .EXAMPLE

        Enter-CleanupSession
        .RELATED LINKS

        https://support.microsoft.com/en-us/help/253597/automating-disk-cleanup-tool-in-windows     
    #>

    [CmdletBinding()]
    PARAM (
        [string]$sageRunInput = "99",
        [parameter(ValueFromPipelineByPropertyName=$True)]
        [string]$path = 'C:\Windows\System32\cleanmgr.exe'
    )

    BEGIN {
        $sageRunValue = '/sagerun:' + $($sageRunInput)
    }

    PROCESS {
        try {
            Start-Process -FilePath $path -ArgumentList $sageRunValue -Verb RunAs -ErrorAction Stop
        }
        catch {
            Write-Host "Could not start process. You likely need to set a path for cleanmgr.exe"
        }
    }
}