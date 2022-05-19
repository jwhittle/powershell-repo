#Written by: Jason Whittle
#Date: 4/4/2022
#History
#1.0 first version
#------------------------------------
#Set your Params

#App server info
$App_server = @{
    HostName = 'LVwmsAppProd'
    ip = '192.168.40.112'
    Username = "ExactaService"
    password = "3x@ct@Srv"
    services = @('ExactaApplicationService','ExactaAutoStoreTaskReconciliation','ExactaBatchMonitor','ExactaCicm','ExactaCubing','ExactaCycleCountScheduler','ExactaDockDoorManagementService','ExactaElasticSearchService','ExactaEventDirector','ExactaExport','ExactaExportAdapter','ExactaImport','ExactaImportAdapter','ExactaJobRunner','ExactaKitting','ExactaLightController','ExactaManifest','ExactaNaming','ExactaPreProcessor','ExactaPurgeLog','ExactaPutwallService','ExactaReceiving','ExactaReplenishment','ExactaResourceLock','ExactaServiceManagement','ExactaUserAuthorization','ExactaVoice','ExactaWorkAcquire')
}
$print_server = @{
    HostName = 'LVwmsPrint'
    ip = '192.168.40.113'
    Username = "herculesbulldog\exactaadmin"
    password = "3x@ct@"
    services = @('ExactaLabelPrintServer')
}



$as_apps = ('ASDriver','ASPlanner','RPsim')
$app_services = ('ExactaApplicationService','ExactaAutoStoreTaskReconciliation','ExactaBatchMonitor','ExactaCicm','ExactaCubing','ExactaCycleCountScheduler','ExactaDockDoorManagementService','ExactaElasticSearchService','ExactaEventDirector','ExactaExport','ExactaExportAdapter','ExactaImport','ExactaImportAdapter','ExactaJobRunner','ExactaKitting','ExactaLightController','ExactaManifest','ExactaNaming','ExactaPreProcessor','ExactaPurgeLog','ExactaPutwallService','ExactaReceiving','ExactaReplenishment','ExactaResourceLock','ExactaServiceManagement','ExactaUserAuthorization','ExactaVoice','ExactaWorkAcquire')
$touch_services = ('ExactaAutomationService')
$report = "C:\temp\report.html"
$autostore_test_server = "192.168.40.117"
$ASHttp = "http://192.168.40.117/ASinterfaceHttp/hostinterface.aspx"
#------------------------------------




function Server_status
{
    Param([Array[]] $server, [string] $section) 

    if (Test-Connection $server.ip -Quiet)
    {        
        Add-Content $report '<div class="container">'
        Add-Content $report "<h2>$section</h2>"
        Add-Content $report '<p>Exacta Services</p>' 
        Add-Content $report '<table class="table table-striped">'
        Add-Content $report '<thead>'
        Add-Content $report '     <tr>'
        Add-Content $report '          <TH>Service</TH>'
        Add-Content $report '          <TH>Status</TH>'
        Add-Content $report '     </tr>'
        Add-Content $report '</thead>'
        Add-Content $report '<tbody>'
        
        foreach ($service in $server.Services)
        {
            $status = Get-Service -ComputerName $server.hostname -Name $service | %{$_.Status}
            if ($status -eq "Running")
            {
                Add-Content $report "<TR><TD>$service</TD><TD>Running</TD></TR>"
            }
            else
            {
                Add-Content $report "<TR class='danger'><TD>$service</td><TD>Stopped</TD></TR>"
            }
            
        }
        Add-Content $report "</tbody></TABLE></div>"
    }
    Else 
    {
        Add-Content $report '<div class="container">'
        Add-Content $report "<h2>$section</h2>"
        Add-Content $report '<h2>Can Not Connect</h2>'

    }  
   
}




function Touch
{

    Add-Content $report '<div class="container">'
    Add-Content $report '<h2>Touch Services Status</h2>'
    Add-Content $report '<p>Services required for Touch</p>' 
    Add-Content $report '<table class="table table-striped">'
    Add-Content $report '<thead>'
    Add-Content $report '     <tr>'
    Add-Content $report '          <TH>Service</TH>'
    Add-Content $report '          <TH>Status</TH>'
    Add-Content $report '     </tr>'
    Add-Content $report '</thead>'
    Add-Content $report '<tbody>'
    
    foreach ($service in $touch_services)
    {
        $status = Get-Service -Name $service | %{$_.Status}
        if ($status -eq "Running")
        {
            Add-Content $report "<TR><TD>$service</TD><TD>Running</TD></TR>"
        }
        else
        {
            Add-Content $report "<TR class='danger'><TD>$service</td><TD>Stopped</TD></TR>"
        }
        
    }
   
   Add-Content $report "</tbody></TABLE></div>"
}


function AS_Status
{
    Add-Content $report '<div class="container">'
    Add-Content $report '<h2>AutoStore Applications status</h2>'
    Add-Content $report '<p>AutoStore Appls</p>' 
    Add-Content $report '<table class="table table-striped">'
    Add-Content $report '<thead>'
    Add-Content $report '     <tr>'
    Add-Content $report '          <TH>Process</TH>'
    Add-Content $report '          <TH>Status</TH>'
    Add-Content $report '     </tr>'
    Add-Content $report '</thead>'
    Add-Content $report '<tbody>'
    
    foreach ($app in $as_apps)
    {
        if (Get-Process $app -ComputerName $autostore_test_server)
        {
            Add-Content $report "<TR><TD>$app</TD><TD>RUNNING</TD></TR>"
        }
        else
        {
            Add-Content $report "<TR class='danger'><TD>$app</td><TD>Stopped</TD></TR>"
        }
    }
   
   Add-Content $report "</tbody></TABLE></div>"
}



function ASConsole_status
{
    $ContentType = "text/xml";
    $RequestBody  = '<?xml version="1.0" encoding="utf-8"?>'
    $RequestBody += '<methodcall>'
    $RequestBody += '    <name>getsystemstatus</name>'
    $RequestBody += '</methodcall>'

    $response = Invoke-WebRequest -Uri $ASHttp -Method Post -Body $RequestBody -ContentType $ContentType -UseBasicParsing;
    Add-Content $report '<div class="container">'
    Add-Content $report '<h2>AutoStore Console status</h2>'
    Add-Content $report '<p>AutoStore Appls</p>' 
    Add-Content $report '<table class="table table-striped">'
    Add-Content $report '<thead>'
    Add-Content $report '     <tr>'
    Add-Content $report '          <TH>Console</TH>'
    Add-Content $report '          <TH>Status</TH>'
    Add-Content $report '     </tr>'
    Add-Content $report '</thead>'
    Add-Content $report '<tbody>'
    if (select-string -pattern "RUNNING" -InputObject $response)
    {
        Add-Content $report "<TR><TD>CONSOLE</TD><TD>RUNNING</TD></TR>"
    }
    else
    {
        Add-Content $report "<TR class='danger'><TD>CONSOLE</td><TD>Stopped</TD></TR>"
    }   
    Add-Content $report "</tbody></TABLE></div>"
}


function Page_Expire
{  
    #create HTML
    Add-Content $report '<!DOCTYPE html>
    <html lang="en">
    <head>
    <title>Test Server Status Check</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jSquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </head>
    <body>'
    
    Add-Content $report '<CENTER><H1>This page has expired. Please close the browser tab and re-run the script'
}


function main
{
    if (Test-Path $report){Remove-Item $report}
    
    #create HTML
    Add-Content $report '<!DOCTYPE html>
    <html lang="en">
    <head>
    <title>Test Server Status Check</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jSquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </head>
    <body>'

    #APP_status
    Server_status -server $App_server -section "Application Server Status"
    Server_status -server $print_server -section "Print Server Status"
    #Touch
    #AS_Status
    #ASConsole_status
        
    
    #open the report
    Invoke-Item $report
    Start-Sleep -s 3
    Remove-Item $report
    if (Test-Path $report){Remove-Item $report}
    Page_Expire
}


main