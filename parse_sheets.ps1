# Written By: Jason Whittle
# Version: 1.0
# Description: Parse Excel Sheets

#grabe all of the excel files in the directory
$files = Get-ChildItem -Path "C:\Users\whitt\Desktop\Test\A\" -Filter *.xlsx
 #then pull the data from the excel files and trhow it into an array
$sheetDataArray = @() # Initialize an empty array to store the sheet data
foreach ($file in $files) {
    $excel = New-Object -ComObject Excel.Application
    $workbook = $excel.Workbooks.Open($file.FullName)
    $sheet = $workbook.Sheets.Item(1)
    $sheetData = @()
    for ($i = 1; $i -le $sheet.UsedRange.Rows.Count; $i++) {
        $row = New-Object PSObject
        for ($j = 1; $j -le $sheet.UsedRange.Columns.Count; $j++) {
            $row | Add-Member -MemberType NoteProperty -Name $sheet.Cells.Item(1, $j).Text -Value $sheet.Cells.Item($i, $j).Text
        }
        $sheetData += $row
    }
    $sheetDataArray += $sheetData # Add the sheet data to the array
    $sheetData | Export-Csv -Path "C:\Users\whitt\Desktop\Test\A\output.csv" -NoTypeInformation
    $excel.Quit()
}
