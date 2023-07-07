param(
  $SourcePath,
  $Destination,
  $PasswordFile,
  $StorageUser
)

# Read the encrypted password from the text file
$securePassword = $(Get-Content -Path $PasswordFile | ConvertTo-SecureString)
          
# Create a PSCredential object with the network credentials
$credential = New-Object System.Management.Automation.PSCredential($StorageUser, $securePassword)

# Temporarily map drive
New-PSDrive -Name "A" -PSProvider FileSystem -Root $Destination -Credential $credential

# Get all files in folder than end with .evtv
Get-ChildItem -Path $SourcePath -Filter "*.evtx" | ForEach-Object {
  # Create folder of server name, if it doesn't exist.
  If(!(test-path -PathType container "A:\$($env:computername)\")) {
    New-Item -ItemType Directory -Path "A:\$($env:computername)\"
  }
  # Copy file to remote folder as user
  Move-Item -Path $_.FullName -Destination "A:\$($env:computername)\$($_.Name)"
}

Get-PSDrive "A" | Remove-PSDrive -Force -Verbose
