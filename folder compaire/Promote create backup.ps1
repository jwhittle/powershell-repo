# Written By: Jason Whittle
# Version: 1.0
# Description: Create Promote folders

<#
.SYNOPSIS
    This script creates a folder structure for promoting files and copies files from a source path to a backup folder.

.DESCRIPTION
    The script prompts the user to enter a work item number and creates a folder structure in the specified promote folder path.
    It then copies files from the source path to a backup folder within the created folder structure.

.PARAMETER SourcePath
    Specifies the source path from where files will be copied.

.PARAMETER PromotefolderPath
    Specifies the promote folder path where the folder structure will be created.

.INPUTS
    None. You will be prompted to enter the work item number.

.OUTPUTS
    None. The script copies files to the backup folder.

.EXAMPLE
    .\Promote create backup.ps1
    - Prompts the user to enter a work item number.
    - Creates a folder structure in the specified promote folder path.
    - Copies files from the source path to a backup folder within the created folder structure.

.NOTES
    Version: 1.0
    Author: Jason Whittle
#>

# Parameters
$SourcePath = "C:\Users\whitt\Desktop\Test\A\ExactaAppServer\"
$PromotefolderPath = "C:\temp\Promote\"

function Get-WorkitemNumber {
    <#
    .SYNOPSIS
        Prompts the user to enter a work item number.

    .DESCRIPTION
        This function prompts the user to enter a work item number and returns the entered value.

    .INPUTS
        None.

    .OUTPUTS
        System.String. The work item number entered by the user.

    .EXAMPLE
        $WorkitemNumber = Get-WorkitemNumber
        - Prompts the user to enter a work item number.
        - Returns the entered work item number.

    .NOTES
        None.
    #>

    return (Read-Host "Enter Workitem number")
}

function Create-FolderStructure {
    <#
    .SYNOPSIS
        Creates a folder structure in the specified promote folder path.

    .DESCRIPTION
        This function creates a folder structure in the specified promote folder path based on the current date and the work item number.

    .PARAMETER WorkitemNumber
        Specifies the work item number.

    .PARAMETER PromotefolderPath
        Specifies the promote folder path where the folder structure will be created.

    .INPUTS
        System.String. The work item number.

    .OUTPUTS
        System.String. The path of the backup folder.

    .EXAMPLE
        $BackupFolder = Create-FolderStructure -WorkitemNumber "12345" -PromotefolderPath "C:\temp\Promote\"
        - Creates a folder structure in the specified promote folder path.
        - Returns the path of the backup folder.

    .NOTES
        None.
    #>

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
    <#
    .SYNOPSIS
        Copies files from a source path to a destination path.

    .DESCRIPTION
        This function copies files from a source path to a destination path, excluding files with the extension ".log".

    .PARAMETER SourcePath
        Specifies the source path from where files will be copied.

    .PARAMETER DestinationPath
        Specifies the destination path where files will be copied.

    .INPUTS
        System.String. The source path and destination path.

    .OUTPUTS
        None.

    .EXAMPLE
        Copy-FilesToBackup -SourcePath "C:\Users\whitt\Desktop\Test\A\ExactaAppServer\" -DestinationPath "C:\temp\Promote\20220101 - Workitem 12345\backup\"
        - Copies files from the source path to the destination path.

    .NOTES
        None.
    #>

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
