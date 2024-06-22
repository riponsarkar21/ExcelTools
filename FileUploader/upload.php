<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['file'])) {
    $uploadDirectory = 'FileUploadRemotely/';
    $uploadFile = $uploadDirectory . basename($_FILES['file']['name']);

    // Ensure the upload directory exists
    if (!is_dir($uploadDirectory)) {
        mkdir($uploadDirectory, 0755, true);
    }

    if (move_uploaded_file($_FILES['file']['tmp_name'], $uploadFile)) {
        echo 'File uploaded successfully: ' . $uploadFile;
    } else {
        echo 'File upload failed.';
    }
} else {
    echo 'No file uploaded.';
}
?>
