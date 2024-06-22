## upload_V3.ps1: 
# this version (V3) will upload the selected file stored in $FilePath variable silently to $Url

## upload_V2.ps1




#############################################################################################################

# Instruction: 

## Open notepad or any text editor, then copy the following code inside *//* *//* mark. ignor the *//* *//* mark.
## Then Save this file as "run_file_uploader.vbs"


## *//* Set objShell = CreateObject("WScript.Shell")*//*
## *//* objShell.Run "powershell -ExecutionPolicy Bypass -File ""E:\OneDrive - Seven Circle (Bangladesh) Ltd\Desktop\upload_V3.ps1""", 1, True*//*


#############################################################################################################


# Define a function to hide the console window
function Hide-ConsoleWindow {
    Add-Type -Name Window -Namespace Console -MemberDefinition '
        [DllImport("Kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();
        [DllImport("User32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    '
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0) # 0 hides the window
}

# Hide the console window
Hide-ConsoleWindow

# Variables for file path and upload URL
$FilePath = "F:\Ripon\Production Report\Production Report 2024 XL\Feb 24 Shun Shing Cement Industries Ltd.xlsm"
$Url = "http://riponsarkar.000webhostapp.com/FileUploadbyVBS/upload.php"
$boundary = [System.Guid]::NewGuid().ToString()
$CRLF = "`r`n"

try {
    Write-Output "Starting file upload..."

    # Open the file as a FileStream for reading
    $FileStream = [System.IO.File]::OpenRead($FilePath)

    # Create the HTTP web request
    $WebRequest = [System.Net.HttpWebRequest]::Create($Url)
    $WebRequest.Method = "POST"
    $WebRequest.ContentType = "multipart/form-data; boundary=$boundary"

    # Create a Stream object to write the request body
    $RequestStream = $WebRequest.GetRequestStream()

    # Write the initial boundary and headers
    $boundaryBytes = [System.Text.Encoding]::ASCII.GetBytes("--$boundary$CRLF")
    $RequestStream.Write($boundaryBytes, 0, $boundaryBytes.Length)

    $header = "Content-Disposition: form-data; name=`"file`"; filename=`"$(Split-Path -Leaf $FilePath)`"$CRLF"
    $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
    $RequestStream.Write($headerBytes, 0, $headerBytes.Length)

    $header = "Content-Type: application/octet-stream$CRLF$CRLF"
    $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
    $RequestStream.Write($headerBytes, 0, $headerBytes.Length)

    # Write the file content in chunks
    $Buffer = New-Object byte[] 8192
    $BytesRead = 0
    do {
        $BytesRead = $FileStream.Read($Buffer, 0, $Buffer.Length)
        $RequestStream.Write($Buffer, 0, $BytesRead)
    } while ($BytesRead -gt 0)

    # Write the closing boundary
    $boundaryBytes = [System.Text.Encoding]::ASCII.GetBytes("$CRLF--$boundary--$CRLF")
    $RequestStream.Write($boundaryBytes, 0, $boundaryBytes.Length)

    # Close the file stream and request stream
    $FileStream.Close()
    $RequestStream.Close()

    # Get the response from the server
    $Response = $WebRequest.GetResponse()
    $ResponseStream = $Response.GetResponseStream()
    $StreamReader = New-Object System.IO.StreamReader($ResponseStream)
    $Result = $StreamReader.ReadToEnd()
    $StreamReader.Close()
    $ResponseStream.Close()
    $Response.Close()

    Write-Output "File upload successful: $Result"
}
catch {
    Write-Output "Error occurred: $_.Exception.Message"
}
