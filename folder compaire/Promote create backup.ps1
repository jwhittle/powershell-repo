# Written By: Jason Whittle
# Version: 1.0
# Description: Create Promote folders


# Parameters
$SourcePath = "C:\Users\whitt\Desktop\Test\A\ExactaAppServer\"
$PromotefolderPath = "C:\temp\Promote\"

function Get-WorkitemNumber {
    return (Read-Host "Enter Workitem number")
}

function Create-FolderStructure {
    param(
        [string]$WorkitemNumber,
        [string]$PromotefolderPath
    )

    $CurrentDate = Get-Date -Format "yyyyMMdd"
    $FolderName = "$CurrentDate - Workitem $WorkitemNumber"
    Write-Host $PromotefolderPath
    $FolderPath = "$PromotefolderPath$FolderName\"
    Write-Host $FolderPath
    New-Item -ItemType Directory -Path $FolderPath | Out-Null

    $BackupFolderPath = Join-Path -Path $FolderPath -ChildPath "backup"
    New-Item -ItemType Directory -Path $BackupFolderPath | Out-Null

    return $BackupFolderPath
}

function Copy-FilesToBackup {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )

    $FilesToCopy = Get-ChildItem $SourcePath -Exclude "*.log" -Recurse
    $TotalFiles = $FilesToCopy.Count
    $CopiedFiles = 0

    foreach ($File in $FilesToCopy) {
        $CopiedFiles++
        $ProgressPercentage = ($CopiedFiles / $TotalFiles) * 100

        Write-Progress -Activity "Copying Files" -Status "Copying file $($File.Name)" -PercentComplete $ProgressPercentage

        Copy-Item -Path $File.FullName -Destination $DestinationPath -Force
    }

    Write-Progress -Activity "Copying Files" -Completed
}

# Main script

$WorkitemNumber = Get-WorkitemNumber
$BackupFolder = Create-FolderStructure -WorkitemNumber $WorkitemNumber -PromotefolderPath $PromotefolderPath


Copy-FilesToBackup -SourcePath $SourcePath -DestinationPath $BackupFolder

Write-Host "Files copied successfully."
