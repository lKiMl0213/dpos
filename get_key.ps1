# This script retrieves the original product key from the system's Software Licensing Service
# and attempts to activate Windows using the retrieved key.
#
# Steps:
# 1. Queries the SoftwareLicensingService WMI object to get the OA3xOriginalProductKey.
# 2. Checks if a product key is found:
#    - If a key is found, it runs the following commands:
#      a. `slmgr.vbs /ipk $key` - Installs the retrieved product key.
#      b. `slmgr.vbs /ato` - Activates Windows using the installed key.
#    - If no key is found, it outputs a message in red text indicating that no key was found.
#
# Note:
# - This script requires administrative privileges to execute successfully.
# - Ensure that the system has a valid product key in the Software Licensing Service.

$key = (Get-WmiObject -Query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
if ($key) {
    slmgr.vbs /ipk $key
    slmgr.vbs /ato
} else {
    Write-Host 'No key found' -ForegroundColor Red
}