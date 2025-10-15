param(
  [Parameter(Mandatory = $true)]
  [string]$Image
)

$ErrorActionPreference = "Stop"

$container = "land_devops"
Write-Host "Deploy image: $Image"


if ($env:DOCKERHUB_USERNAME -and $env:DOCKERHUB_TOKEN) {
  echo $env:DOCKERHUB_TOKEN | docker login -u $env:DOCKERHUB_USERNAME --password-stdin
}


try { docker rm -f $container | Out-Null } catch {}


docker pull $Image


docker run -d --name $container -p 8080:80 $Image

Write-Host "Container '$container' is running ✔"
