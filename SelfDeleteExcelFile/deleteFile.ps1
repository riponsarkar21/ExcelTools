# Define the path to the file
$filePath = "E:\OneDrive - Seven Circle (Bangladesh) Ltd\Desktop\Book1.xlsm"

# Check if the file exists
if (Test-Path -Path $filePath) {
    # Remove the file
    Remove-Item -Path $filePath -Force
    Write-Output "File deleted successfully."
} else {
    Write-Output "File not found."
}
