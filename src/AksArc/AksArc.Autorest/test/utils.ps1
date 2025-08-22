function RandomString([bool]$allChars, [int32]$len) {
    if ($allChars) {
        return -join ((33..126) | Get-Random -Count $len | % {[char]$_})
    } else {
        return -join ((48..57) + (97..122) | Get-Random -Count $len | % {[char]$_})
    }
}
function Start-TestSleep {
    [CmdletBinding(DefaultParameterSetName = 'SleepBySeconds')]
    param(
        [parameter(Mandatory = $true, Position = 0, ParameterSetName = 'SleepBySeconds')]
        [ValidateRange(0.0, 2147483.0)]
        [double] $Seconds,

        [parameter(Mandatory = $true, ParameterSetName = 'SleepByMilliseconds')]
        [ValidateRange('NonNegative')]
        [Alias('ms')]
        [int] $Milliseconds
    )

    if ($TestMode -ne 'playback') {
        switch ($PSCmdlet.ParameterSetName) {
            'SleepBySeconds' {
                Start-Sleep -Seconds $Seconds
            }
            'SleepByMilliseconds' {
                Start-Sleep -Milliseconds $Milliseconds
            }
        }
    }
}

$env = @{}
if ($UsePreviousConfigForRecord) {
    $previousEnv = Get-Content (Join-Path $PSScriptRoot 'env.json') | ConvertFrom-Json
    $previousEnv.psobject.properties | Foreach-Object { $env[$_.Name] = $_.Value }
}
# Add script method called AddWithCache to $env, when useCache is set true, it will try to get the value from the $env first.
# example: $val = $env.AddWithCache('key', $val, $true)
$env | Add-Member -Type ScriptMethod -Value { param( [string]$key, [object]$val, [bool]$useCache) if ($this.Contains($key) -and $useCache) { return $this[$key] } else { $this[$key] = $val; return $val } } -Name 'AddWithCache'
function setupEnv() {
    # Load environment JSON file.
    $loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
    if (-Not (Test-Path -Path $loadEnvPath)) {
        $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
    }
    . ($loadEnvPath)
    # Create a provisioned cluster to be used by all tests if it doesn't already exist.
    $cluster = Get-AzAksArcCluster `
        -ClusterName $env.clusterName `
        -ResourceGroupName $env.resourceGroupName
    if ($null -eq $cluster) {
        $path = Join-Path -Path $PSScriptRoot -ChildPath "test-rsa"
        ssh-keygen -t rsa -b 4096 -f $path -C "" -N ""
        $ssh = Get-Content -Path "${path}.pub"
        New-AzAksArcCluster `
            -ClusterName $env.clusterName`
            -ResourceGroupName $env.resourceGroupName  `
            -CustomLocationName $env.customLocationName `
            -VnetId $env.lnetID `
            -SshKeyValue $ssh
    }
}
function cleanupEnv() {
    # Please clean up your test resources manually. 
    # This is so we can use the same provisioned cluster every time we run test-module.ps1 and to prevent having to 
    # recreate the provisioned cluster for every test-module.ps1 call.
}

