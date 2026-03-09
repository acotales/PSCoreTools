function Test-InternetConnection {
    [CmdletBinding()]
    param()

    try {
        return Test-NetConnection -InformationLevel Quiet
    }
    catch {
        Write-Error "An error occured while testing the connection: $_"
        return $false
    }

}
