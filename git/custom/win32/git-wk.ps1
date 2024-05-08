Param(
    $branchName,
    $rootDirectory
)

Set-PSDebug -strict
Set-StrictMode -Version Latest
$errorActionPreference = "Stop"

function ExistsOnRemote
{
    Param($branchName)

    $result = git ls-remote --heads origin "refs/heads/$branchName"
    return $null -ne $result
}

function gitWorkTreeAdd
{
    Param(
        [Parameter(Mandatory=$true)]
        $branchName,
        [Parameter(Mandatory=$true)]
        $rootDirectory
    )

    if ($branchName.Contains("/"))
    {
        $branchNameStem = $branchName.Split("/")[-1]
        $worktreeDirectory = [System.IO.Path]::Combine($rootDirectory, $branchNameStem)
    }
    else
    {
        $worktreeDirectory = [System.IO.Path]::Combine($rootDirectory, $branchName)
    }


    $trackingExisting = ExistsOnRemote $branchName
    if ($trackingExisting)
    {
        Write-Host "Tracking existing branch"
        $command = {
            git worktree add "$worktreeDirectory" "$branchName"
        }
    }
    else
    {
        Write-Host "Not existing branch $branchName, creating new branch"
        $command = {
            git worktree add -b "$branchName" "$worktreeDirectory"
        }
    }
    Write-Host "Creating worktree for branch $branchName at $worktreeDirectory"

    if ($PSCmdlet.ShouldProcess($command, "Run command"))
    {
        Invoke-Command -ScriptBlock $command
        cd "$worktreeDirectory"
    }
}

if ($PSBoundParameters.Count -eq 0) {
    # Write-Host "No parameters are provided, show help message and exit."
    Get-Help $MyInvocation.MyCommand.Definition
    exit 1
}

gitWorkTreeAdd "$branchName" "$rootDirectory"