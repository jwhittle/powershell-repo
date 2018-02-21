#Written By: Jason Whittle
#version: 2.0


#create spreadsheet for input

#parse sheet

#generate html with instructions


############################
$data = '{
    "Sheetname":"Enter_Your_Data",
    "columns":[
        {"column":1, "Heading":"WH"},
        {"column":2, "Heading":"ZONE"},
        {"column":3, "Heading":"ROW"},
        {"column":4, "Heading":"BAY"},
        {"column":5, "Heading":"SHELF"},
        {"column":6, "Heading":"CELL"}
    ]}'

####################




function Create-Sheet{


$columns = ConvertFrom-Json -InputObject $data

$excel = New-Object -ComObject excel.application 
$excel.visible = $True
$workbook = $excel.Workbooks.Add()
$uregwksht= $workbook.Worksheets.Item(1) 
$uregwksht.Name = $columns.Sheetname



foreach ($column in $columns.columns){
    $uregwksht.Cells.Item(1,$column.column) = $column.Heading

}

#saving & closing the file 
#$workbook.SaveAs('test.xlsx') 
#$excel.Quit()
}

function Parse-Sheet{
}

function Create-Html{

}


function Main{
    Create-Sheet
    

}

Main