SlbMuxAdvertisedRoutes file depends on Posh-SSH.
```
Install-Module Posh-SSH
Import-Module .\SlbMuxAdvertisedRoutes.psm1
Get-SlbMuxAdvertisedRoutes -SwitchAddress $torIP -Credential $mycreds
```

# NAME

Get-SlbMuxAdvertisedRoutes

# SYNOPSIS

Connect to a switch and get the routes for each SLBMux.  Thess commands are intended for a Cisco Nexus using 7.x.


# SYNTAX

    Get-SlbMuxAdvertisedRoutes [-SwitchAddress] <IPAddress> [-Credential] <PSCredential> [<CommonParameters>]


# DESCRIPTION
Using Posh-SSH connect to a switch using the switch credentials.
Using 'Show ip bgp summary' identify the SlbMux addresses, and determine the number of routes for each SlbMux.
Return an array with the SLBMux address and route addresses.


# PARAMETERS
    -SwitchAddress <IPAddress>
        Switch IP address

        Required?                    true
        Position?                    1
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Credential <PSCredential>
        Switch Credential

        Required?                    true
        Position?                    2
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

# INPUTS

System.Net.IPAddress

System.Management.Automation.PSCredential

# OUTPUTS
PSCustomObject

-------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-SlbMuxAdvertisedRoutes -SwitchAddress $torIP -Credential $mycreds
    
    This will return a PSCustom Object with SLBMux Address, RoutesRecieved and TotalRecievedRotues
    SlbMux              : 100.68.93.12
    RecievedRoutes      : {*|e100.64.245.1/32    100.68.93.12                                   0 64628 i, *|e100.64.245.3/32
    100.68.93.12                                   0 64628 i, *|e100.64.245.4/32
                  100.68.93.12                                   0 64628 i, *|e100.64.245.5/32    100.68.93.12
               0 64628 i...}
    TotalRecievedRoutes : 26

RELATED LINKS

https://www.powershellgallery.com/packages/Posh-SSH/2.0.2