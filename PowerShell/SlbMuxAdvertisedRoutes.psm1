
Function Get-SlbMuxAdvertisedRoutes {
    <#
        .SYNOPSIS
        Connect to a switch and get the routes for each SLBMux.  Thess commands are intended for a Cisco Nexus using 7.x.

        .DESCRIPTION
        Using Posh-SSH connect to a switch using the switch credentials.
        Using 'Show ip bgp summary' identify the SlbMux addresses, and determine the number of routes for each SlbMux.
        Return an array with the SLBMux address and route addresses.

        .EXAMPLE
        Get-SlbMuxAdvertisedRoutes -SwitchAddress $torIP -Credential $mycreds | fl

        This will return a PSCustom Object with SLBMux Address, RoutesRecieved and TotalRecievedRotues
        SlbMux              : 100.68.93.12
        RecievedRoutes      : {*|e100.64.245.1/32    100.68.93.12                                   0 64628 i, *|e100.64.245.3/32    100.68.93.12                                   0 64628 i, *|e100.64.245.4/32    
                      100.68.93.12                                   0 64628 i, *|e100.64.245.5/32    100.68.93.12                                   0 64628 i...}
        TotalRecievedRoutes : 26

        .INPUTS
        System.Net.IPAddress
        System.Management.Automation.PSCredential

        .OUTPUTS
        PSCustomObject

        .NOTES

        .LINK
        https://www.powershellgallery.com/packages/Posh-SSH/2.0.2
    #>

    [CmdLetBinding()]
    [OutputType([OutputType])]
    Param(

        # Switch IP address
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Net.IPAddress]
        $SwitchAddress,

        # Switch Credential
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    try {
        $session = New-SSHSession -ComputerName $SwitchAddress.ToString() -Credential $Credential -AcceptKey -Force -ErrorAction Stop
        $slbRegEx = '\d+.\d+.\d+.1[2|3]'
        $SlbMuxSum = Invoke-SSHCommandStream -Command "show ip bgp summary" -SessionId (get-sshsession).SessionId | Where-Object { $_ -match $slbRegEx }

        foreach ($slbNeig in $SlbMuxSum) {
            $slbAddr = $slbNeig.split("", 2)[0]
            $routesCommand = ("show ip bgp neighbor {0} route" -f $slbAddr)
            $advertisedRoutesRegex = '\d+.\d+.\d+.\d+/32'
            $recievedRoutes = Invoke-SSHCommandStream -Command $routesCommand -SessionId (get-sshsession).SessionId | where-Object { $_ -match $advertisedRoutesRegex }
            [PSCustomObject]@{
                SlbMux              = $slbAddr
                RecievedRoutes      = $recievedRoutes
                TotalRecievedRoutes = ($recievedRoutes).Count
            }
        }
        Remove-SSHSession -SessionId $session.SessionId | Out-Null
    }
    catch { 
        Write-Error -Message ("Unable to Login to {0}" -f $SwitchAddress.ToString())
    }
}
