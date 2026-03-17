function Invoke-GitClone {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Url,
        [string]$Destination = (Get-Location).Path
    )

    $pattern = "github\.com[:/](?<owner>[^/]+)/(?<repo>[^/.]+)"

    if ($Url -notmatch $pattern) {
        throw "Invalid Github URL"
    }

    $apiUrl = "https://api.github.com/repos/$($Matches.owner)/$($Matches.repo)"

    try {
        $oldProgress = $ProgressPreference
        $ProgressPreference = "SilentlyContinue"

        $response = Invoke-RestMethod -Uri $apiUrl

        $owner = $response.owner.login
        $repo = $response.name
        $branch = $response.default_branch

        $archive = "https://github.com/$owner/$repo/archive/refs/heads/$branch.zip"
        
        $temp = Join-Path $env:TEMP "$repo.zip"

        Invoke-WebRequest -Uri $archive -OutFile $temp

        $dest = Join-Path -Path $Destination -ChildPath $owner
        $repoPath = Join-Path -Path $dest -ChildPath $repo

        if (Test-Path $repoPath) {
            Remove-Item $repoPath -Recurse -Force -ErrorAction SilentlyContinue
        }

        Expand-Archive -Path $temp -DestinationPath $dest -Force
        Remove-Item $temp -Force -ErrorAction SilentlyContinue

        $extracted = Get-ChildItem $dest -Directory |
        Where-Object { $_.Name -like "$repo-*" }    |
        Select-Object -First 1

        if ($extracted) {
            Rename-Item $extracted.FullName -NewName $repo
        }
        
        return $dest
    }
    catch {
        Write-Error "Failed to download $Url. Error: $_"
        return $null
    }
    finally {
        $ProgressPreference = $oldProgress
    }
}
