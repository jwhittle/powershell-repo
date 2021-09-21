##Written by: Jason Whittle
##Description:  Parse data from an excel spreadsheet,  and generate queries 
##Version: 1.0
##Date: 2018-02-28


#REQIRED INFO##
#Set Path to the spreadsheet
$file = "C:\Users\jwhittle\Desktop\J&J VLM\New VLM Data base 14-Feb-2018.xlsx"

#SET the name of the Worksheet your pulling data from
$sheetName = "Sheet1"




Clear-Host
$excel = new-object -com excel.application
$wb = $excel.workbooks.open($file)
$sheet = $wb.Worksheets.Item($sheetName)
$excel.Visible=$false


$rowMax = ($sheet.UsedRange.Rows).count 

#SET the starting cell of each column

$rowmaterial,$colmaterial = 2,1         #set first cel for the Warehouse
$rowUPC12,$colUPC12 = 2,2
$rowUPC11,$colUPC11 = 2,3
$rowdesc,$coldesc = 2,4
$rowSi_loc,$colSi_loc = 2,5
$rowSAP_loc,$colSAP_loc = 2,6
$rowPack_size,$colPack_size = 2,7
$rowStorage_area,$colStorage_Area = 2,9


#Create the arrays for each query
$prod_header_query = @()
$prod_zone_query = @()
$prod_uom_query = @()
$prod_uom_zone_query = @()
$prod_header_detail = @()

for ($i=0; $i -le $rowMax-2; $i++){
    Write-Host "$i of $rowMax" #Counter show progress
    $material = $sheet.Cells.Item($rowmaterial+$i,$colmaterial).text
    $UPC12 = $sheet.Cells.Item($rowUPC12+$i,$colUPC12).text
    $UPC11 = $sheet.Cells.Item($rowUPC11+$i,$colUPC11).text
    $desc = $sheet.Cells.Item($rowdesc+$i,$coldesc).text
    $Si_loc = $sheet.Cells.Item($rowSi_loc+$i,$colSi_loc).text
    $SAP_loc = $sheet.Cells.Item($rowSAP_loc+$i,$colSAP_loc).text
    $Pack_size = $sheet.Cells.Item($rowPack_size+$i,$colPack_size).text
    $Storage_area = $sheet.Cells.Item($rowStorage_area+$i,$colStorage_area).text

    $Pack_sizedesc = 'Lens - '+$Pack_size+'P'

    if ($UPC11 -ne ''){ #if $UPC11 is not blank Do something!!   
        $prod_header_query += "insert into prod_header values (newid(), '$UPC11','$desc','3F5DF70F-AF78-4A31-A2A7-E3018ACC984D',0,0,'',9,0,1,0,2,0,0,0,NULL,0,1,0,0,0,0,0,0,0,NULL)"
    
        $prod_zone_query += "insert into prod_zone select prod_id, '001', 200 ,'5','99999' from prod_header where prod_name = '$UPC11'"
    
        $prod_uom_query += "insert into prod_uom select prod_id, '200' ,'0','$Pack_size','1','1','1','1','0','1','0','0','0','0','0' from prod_header where prod_name = '$UPC11'"
        $prod_uom_query += "insert into prod_uom select prod_id, '100' ,'0','$Pack_size','1','1','1','1','0','1','0','0','0','0','0' from prod_header where prod_name = '$UPC11'"

        $prod_uom_zone_query += "insert into prod_uom_zone select prod_id, 200, '001', 0,1,1,0,0,0,0 from  prod_header where prod_name = '$UPC11'"
        $prod_uom_zone_query += "insert into prod_uom_zone select prod_id, 100, '001', 0,1,1,0,0,0,0 from  prod_header where prod_name = '$UPC11'"
    
        $prod_header_detail += "insert into prod_header_detail select prod_id, 1002, '$Pack_sizedesc' from prod_header where prod_name = '$UPC11'"
        $prod_header_detail += "insert into prod_header_detail select prod_id, 1001, '$material' from prod_header where prod_name = '$UPC11'"
    
    }else{
        Write-Host "--"
    }
}

$excel.Workbooks.Close()

#delete existing report.html
if (Test-Path report.html){Remove-Item report.html}


#create HTML
Add-Content 'report.html' '<!DOCTYPE html>
<html lang="en">
<head>
  <title>File Compare</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>'
#CSS examples here   https://www.w3schools.com/bootstrap/bootstrap_collapse.asp
#Section 1 #NOTES Go HERE
Add-Content 'report.html' "<div class='container'>
<div class='panel-group' id='accordion'>
    <div class='panel panel-default'>
      <div class='panel-heading'>
        <h4 class='panel-title'>
          <a data-toggle='collapse' data-parent='#accordion' href='#collapse1'><H1>NOTES</H1></a>
        </h4>
      </div>
      <div id='collapse1' class='panel-collapse collapse in'>"
#Add-Content 'report.html' "<TH><h1>--Product Header updates!!</h1></TH>"
Add-Content 'report.html' "<div class='panel-body'>Copy and paste the queries below and run them.</div>"
Add-Content 'report.html' "</div></div>"



#Section 2
Add-Content 'report.html' "
    <div class='panel panel-default'>
      <div class='panel-heading'>
        <h4 class='panel-title'>
          <a data-toggle='collapse' data-parent='#accordion' href='#collapse2'>--Product Header updates!!</a>
        </h4>
      </div>
      <div id='collapse2' class='panel-collapse collapse'>"
#Add-Content 'report.html' "<TH><h1>--Product Header updates!!</h1></TH>"
foreach ($query in $prod_header_query){Add-Content 'report.html' "<div class='panel-body'>$query </div>"}
Add-Content 'report.html' "</div></div>"

#Section 3
Add-Content 'report.html' "
    <div class='panel panel-default'>
      <div class='panel-heading'>
        <h4 class='panel-title'>
          <a data-toggle='collapse' data-parent='#accordion' href='#collapse3'>--Product Zone updates!!</a>
        </h4>
      </div>
      <div id='collapse3' class='panel-collapse collapse'>"
#Add-Content 'report.html' "<TH><h1>--Product Header updates!!</h1></TH>"
foreach ($query in $prod_zone_query){Add-Content 'report.html' "<div class='panel-body'>$query </div>"}
Add-Content 'report.html' "</div></div>"


#Section 4
Add-Content 'report.html' "
    <div class='panel panel-default'>
      <div class='panel-heading'>
        <h4 class='panel-title'>
          <a data-toggle='collapse' data-parent='#accordion' href='#collapse4'>--Product UOM updates!!</a>
        </h4>
      </div>
      <div id='collapse4' class='panel-collapse collapse'>"
#Add-Content 'report.html' "<TH><h1>--Product Header updates!!</h1></TH>"
foreach ($query in $prod_uom_query){Add-Content 'report.html' "<div class='panel-body'>$query </div>"}
Add-Content 'report.html' "</div></div>"

#Section 5
Add-Content 'report.html' "
    <div class='panel panel-default'>
      <div class='panel-heading'>
        <h4 class='panel-title'>
          <a data-toggle='collapse' data-parent='#accordion' href='#collapse5'>--Product Header Detail updates!!</a>
        </h4>
      </div>
      <div id='collapse5' class='panel-collapse collapse'>"
#Add-Content 'report.html' "<TH><h1>--Product Header updates!!</h1></TH>"
foreach ($query in $prod_uom_query){Add-Content 'report.html' "<div class='panel-body'>$query </div>"}
Add-Content 'report.html' "</div></div>"



#open the report
Invoke-Item report.html