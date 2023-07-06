param(
  $Password,
  $SaveLocation
)

# Convert text to secure string
$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
        
# Save the secure password to a text file
$securePassword | ConvertFrom-SecureString | Out-File -FilePath $SaveLocation
