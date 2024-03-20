# ---- DLL Version Scraper ---- 
#
# Script to recursively scrape a folder and all subfolders for all .dll files 
# and output their file versions and paths to a csv
#
#
# Created by Kyle Grant - 8/21/2019 - kgrant@bastiansolutions.com
# Bastian Solutions

# Initialize variables
$dllPathArr = @{}
$csvOutput = {}
$csvData = @{
             Name = "test.dll";
             Path = "C:\temp\";
             Version = "1.0.0.1"
            }

$date = Get-Date -Format "yyyyMMdd_HHmm"

# Generate the output CSV file path
$csvPath = "$PSScriptRoot\" + "$date" +"_dllVersions.csv"

# Check if the CSV file already exists, if so, append a timestamp to the file name
if([System.IO.File]::Exists($csvPath)){
    $date = Get-Date -Format "yyyyMMdd_HHmmss"
    $csvPath = "$PSScriptRoot\" + "$date" +"_dllVersions.csv"
}

# Get all .dll files in the script root directory and its subdirectories
$dllPathArr = Get-Childitem –Path $PSScriptRoot -Include *.dll -File -Recurse -ErrorAction SilentlyContinue | %{ @{Path=$_.fullname} }

# Iterate through each .dll file and retrieve its information
foreach ($path in $dllPathArr) {
    $fileInfo = (Get-Command $path.path)
    $csvData.Name = $fileInfo.Name
    $pathLength = $fileInfo.Path.Length - $fileInfo.Name.Length
    $csvData.Path = $fileInfo.Path.Substring(0,$pathLength)
    $csvData.Version = $fileInfo.Version
    $csvOutput = New-Object PSObject -Property $csvData
    $csvOutput | Select-Object "Name", "Version", "Path" | Export-Csv -Path $csvPath -NoTypeInformation -Append
}

# Sort the CSV data by name
$sortedCSV = Import-Csv $csvPath | Sort-Object Name

# Export the sorted CSV data to the same file
$sortedCSV | Export-Csv -Path $csvPath -NoTypeInformation
