[CmdletBinding()]
Param(
    [string]$DockerHostName,
    [string]$DockerHostIp,
    [string]$DockerClientName,
    [string]$DockerClientIp
)

$InformationPreference = "Continue"

Write-Host "Generating CA certificates" -ForegroundColor Green
openssl genrsa -aes256 -out ca-key.pem 4096
openssl req -new -x509 -days 730 -key ca-key.pem -sha256 -out ca.pem

Write-Host "Generating Docker host certificates" -ForegroundColor Green
openssl genrsa -out daemon-key.pem 4096
openssl req -subj "/CN=$DockerHostName" `
   -sha256 -new -key daemon-key.pem -out daemon.csr

@"
subjectAltName = DNS:$($DockerHostName),IP:$($DockerHostIp)
extendedKeyUsage = serverAuth
"@ | Out-File extfile.cnf -Encoding ascii

openssl x509 -req -days 730 -sha256 `
   -in daemon.csr -CA ca.pem -CAkey ca-key.pem `
   -CAcreateserial -out daemon-cert.pem -extfile extfile.cnf

Remove-Item daemon.csr, extfile.cnf

Write-Host "Generating Docker client certificates" -ForegroundColor Green
openssl genrsa -out client-key.pem 4096
openssl req -subj "/CN=$DockerClientName" -new -key client-key.pem -out client.csr

@"
subjectAltName = DNS:$($DockerClientName),IP:$($DockerClientIp)
extendedKeyUsage = clientAuth
"@ | Out-File extfile.cnf -Encoding ascii

openssl x509 -req -days 730 -sha256 `
   -in client.csr -CA ca.pem -CAkey ca-key.pem `
   -CAcreateserial -out client-cert.pem -extfile extfile.cnf

Remove-Item client.csr, extfile.cnf