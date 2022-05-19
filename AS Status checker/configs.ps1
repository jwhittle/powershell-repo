#write-host "Hello World"
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
    services = @('ExactaLabelPrintService')
}

$connectship_server = @{
    HostName = 'ConnectShip'
    ip = '192.168.40.136'
    Username = "herculesbulldog\exactaadmin"
    password = "3x@ct@"
    services = @('AMPService')
}
