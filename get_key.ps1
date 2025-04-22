$key = (Get-WmiObject -Query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
if ($key) {
    slmgr.vbs /ipk $key
    slmgr.vbs /ato
} else {
    Write-Host 'No key found' -ForegroundColor Red
}