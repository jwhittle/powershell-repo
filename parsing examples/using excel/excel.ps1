$file = "C:\Users\jwhittle\Desktop\powershell-repo\parsing examples\using excel\test.xlsx"
$sheetName = "Sheet1"

$excel = new-object -com excel.application
$wb = $excel.workbooks.open($file)
$sheet = $wb.Worksheets.Item($sheetName)
$excel.Visible=$false


$rowMax = ($sheet.UsedRange.Rows).count 

$rowWH,$colWH = 2,1         #set first cel for the Warehouse
$rowZONE,$colZONE = 2,2
$rowROW,$colROW = 2,3
$rowBAY,$colBAY = 2,4
$rowSHELF,$colSHELF = 2,5
$rowCELL,$colCELL = 2,6



for ($i=0; $i -le $rowMax-2; $i++)
{
    $WH = $sheet.Cells.Item($rowWH+$i,$colWH).text
    $ZONE = $sheet.Cells.Item($rowZONE+$i,$colZONE).text
    $ROW = $sheet.Cells.Item($rowROW+$i,$colROW).text
    $BAY = $sheet.Cells.Item($rowBAY+$i,$colBAY).text
    $SHELF = $sheet.Cells.Item($rowSHELF+$i,$colSHELF).text
    $CELL = $sheet.Cells.Item($rowCELL+$i,$colCELL).text

Write-Host "UPDATE LOC_HEADER set something = '' where wh_num = '$WH' ZONE = '$ZONE'"

}




$excel.Workbooks.Close()

