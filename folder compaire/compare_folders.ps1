# Written By: Jason Whittle
# Version: 3.0
# Description: File Comparison script


# Parameters
$dir1 = 'C:\Users\whitt\Desktop\Test\A\'   #backup
$dir2 = 'C:\Users\whitt\Desktop\Test\B\'   #prod
$LogFilePath = "C:\Users\whitt\Desktop\file.log"


function Write-Log {
    param(
        [string]$Message
    )

    # Add the log entry to the array
    $LogEntries += "[" + (Get-Date).ToString() + "] " + $Message
}

function Compare-FolderVersions {
    param(
        [string]$folderPath1,
        [string]$folderPath2
    )

    Write-Host "Folder Comparison Report"
    Write-Log "Starting Folder Comparison Report"
    # Get all files recursively from both folders
    $files1 = Get-ChildItem -Path $folderPath1 -Recurse | Where-Object {!$_.PSIsContainer}
    $files2 = Get-ChildItem -Path $folderPath2 -Recurse | Where-Object {!$_.PSIsContainer}

    $totalFiles = $files1.Count
    $currentFile = 0

    # Iterate through each file and compare versions
    foreach ($file1 in $files1) {
        $currentFile++
        Write-Progress -Activity "Comparing files" -Status "$currentFile of $totalFiles" -PercentComplete (($currentFile / $totalFiles) * 100)

        $relativePath = $file1.FullName.Substring($folderPath1.Length + 0)
        
        $file2 = $files2 | Where-Object {$_.FullName -eq (Join-Path -Path $folderPath2 -ChildPath $relativePath)}

        $fileVersion1 = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($file1.FullName).FileVersion
        if (-not $fileVersion1) {
            $fileContent1 = Get-Content $file1.FullName -Raw
        }

        if ($file2 -ne $null) {
            $fileVersion2 = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($file2.FullName).FileVersion
            if (-not $fileVersion2) {
                $fileContent2 = Get-Content $file2.FullName -Raw
            }

            if ($fileVersion1 -ne $null -and $fileVersion2 -ne $null) {
                if ($fileVersion1 -ne $fileVersion2) {
                    Write-Host "Mismatch detected for file Version: $relativePath" -ForegroundColor Green
                    Write-Host "Version in folder 1: $fileVersion1" -ForegroundColor Green
                    Write-Host "Version in folder 2: $fileVersion2" -ForegroundColor Green
                }
            } elseif ($fileContent1 -ne $fileContent2) {
                Write-Host "Mismatch detected for file content: $relativePath" -ForegroundColor Green
            }
        } else {
            Write-Host "File not found in folder 2: $relativePath" -ForegroundColor Green
        }
    }
    Write-Progress -Activity "Comparing files" -Completed
    # Check for new files in folder 2 not present in folder 1
    foreach ($file2 in $files2) {
        $relativePath = $file2.FullName.Substring($folderPath2.Length + 0)
        $file1 = $files1 | Where-Object {$_.FullName -eq (Join-Path -Path $folderPath1 -ChildPath $relativePath)}

        if ($file1 -eq $null) {
            Write-Host "New file found in folder 2: $relativePath" -ForegroundColor Green
        }
    }
}


# Example usage:

Compare-FolderVersions -folderPath1 $dir1 -folderPath2 $dir2
$LogEntries | Out-File -FilePath $LogFilePath

