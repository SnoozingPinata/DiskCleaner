function Add-CleanupRegistryValues {
    <#
        .SYNOPSIS
        Adds the registry values needed to use disk cleaner without the GUI.

        .DESCRIPTION        
        This function is used to generate the registry values needed in order for disk cleanup to be run without user interraction in the GUI.

        .Example
        Add-CleanupRegistryValues

        .Example
        Add-CleanupRegistryValues -regValueName "0095"

        .PARAMETER registryValue
        Enter a number from 0001-9999 here. For more information, see the related links.

        .LINK
        https://support.microsoft.com/en-us/help/253597/automating-disk-cleanup-tool-in-windows

        .LINK
        Github source: https://github.com/SnoozingPinata/DiskCleaner

        .LINK
        Author's website: www.samuelmelton.com
    #>

    [CmdletBinding()]
    Param(
        [string]$registryValue = "0099"
    )

    Begin {
    }

    Process {
        $regValueName = "StateFlags" + $($registryValue)

        $parentRegPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches'
        Get-ChildItem -Path $parentRegPath -Force | ForEach-Object -Process {
            New-ItemProperty -Path $_.PSPath -Name $regValueName -Value 2 -PropertyType "DWord" -Force
        }
    }

    End {
    }
}


Function Enter-CleanupSession {
    <#
        .SYNOPSIS
        Runs disk cleaner without requiring GUI interraction.
        
        .DESCRIPTION
        This is meant to be used after the Add-CleanupRegistryValues function in order to launch an automated version of Disk Cleanup.

        .EXAMPLE
        Enter-CleanupSession

        .LINK
        https://support.microsoft.com/en-us/help/253597/automating-disk-cleanup-tool-in-windows

        .LINK
        Github source: https://github.com/SnoozingPinata/DiskCleaner

        .LINK
        Author's website: www.samuelmelton.com
    #>

    [CmdletBinding()]
    Param (
        [Parameter()]
        [string]$SageRunInput = "99",

        [Parameter(
            ValueFromPipelineByPropertyName=$True)]
        [string]$Path = 'C:\Windows\System32\cleanmgr.exe'
    )

    Begin {
    }

    Process {
        $sageRunValue = '/sagerun:' + $($SageRunInput)

        try {
            Start-Process -FilePath $Path -ArgumentList $sageRunValue -Verb RunAs -ErrorAction Stop
        }
        catch {
            Write-Verbose "Could not start process. You likely need to set a path for cleanmgr.exe"
        }
    }

    End {
    }
}