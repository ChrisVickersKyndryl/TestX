param(
  $SourcePath,
  $Destination,
  $PasswordFile,
  $StorageUser
)

# Variables
$destinationPath = "$Destination\$($env:computername)\"
          
# Read the encrypted password from the text file
$securePassword = Get-Content -Path $PasswordFile | ConvertTo-SecureString -AsPlainText -Force
          
# Create a PSCredential object with the network credentials
$credential = New-Object System.Management.Automation.PSCredential($StorageUser, $securePassword)
         
# Get all files in folder than end with .evtv
Get-ChildItem -Path $SourcePath -Filter "*.evtx" | ForEach-Object {
  # Create folder of server name, if it doesn't exist.
  If(!(test-path -PathType container $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath
  }
  # Copy file to remote folder as user
  Move-Item -Path $_.FullName -Destination "$destinationPath$($_.Name)" -Credential $credential
}
