param(
    [Parameter(Mandatory=$true)]
    [ValidateScript({Test-Path -Path $_})]
    [string] $CertPath,

    [switch] $CopyToClipboard
)


if( $host.Version -ge [Version]::New(7,0,0) ) {
    $data = Get-Content -AsByteStream -Path $CertPath
} else {
    $data = Get-Content -Encoding byte -Raw -Path $CertPath
}

$pfx = [convert]::ToBase64String($data)

if($CopyToClipboard) {
    $pfx | Set-Clipboard
}

return $pfx

