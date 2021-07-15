[CmdletBinding()]
param (
    $SolutionFolder
)


if(-not [string]::IsNullOrEmpty($SolutionFolder))
{ 

$root = 'D:\a\1\s\5.0\Source\'

$path = -join($root, "", $SolutionFolder)


$IsValid = Test-Path $path

if($IsValid) {

$regexExcludeFolders="bin|obj|Properties|BuildFiles|Service References|packages";
 
$diagnostics = Get-ChildItem -Path $path -Exclude BuildFiles,'Install Packages',packages,*.sln,*.md -Recurse | Where-Object {($_.FullName -notmatch $regexExcludeFolders) -and $_.Extension -eq ".cs"} | foreach {Select-String -Path $_.FullName -Pattern 'System.Diagnostics.Debugger.Launch()'}

Write-Host "##[debug] Looking for diagnostics lines in this path: $path";

IF($diagnostics.Count -gt 0) {

$diagnostics | Format-List -Property Filename, Line, LineNumber,Path
Write-Error -Message "##[error] Please REMOVE diagnostic lines! 😡 👎👎👎" -ErrorAction Stop

}
else 
{
Write-Host "##[section] No diagnostic lines were found 😁😁👌👌"
}
}


else 
{
Write-Host "##[warning] This directory $path does not exists. Configure the right solution folder name."
}

}
else 
{
Write-host "##[warning] No soultion folder name was found after this path D:\a\1\s\5.0\Source\. The provided value is empty."
}


