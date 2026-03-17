function Test-InternetConnection {
    [CmdletBinding()]
    param()

    $pingTestParams = @{
        ComputerName = "8.8.8.8"
        Count        = 1
        Quiet        = $true
        ErrorAction  = "SilentlyContinue"
    }

    $httpTestParams = @{
        Uri             = "https://www.google.com/generate_204"
        UseBasicParsing = $true
        TimeoutSec      = 5
        ErrorAction     = "Stop"
    }

    try {
        # Fast ICMP check
        if (Test-Connection @pingTestParams) {
            return $true 
        }

        # HTTP fallback
        $response = Invoke-WebRequest @httpTestParams
        if ($response.StatusCode -eq 204) {
            return $true 
        }   
    }
    catch {
        Write-Error "Test-InternetConnection Error: $_"
    } 
    
    return $false
}
