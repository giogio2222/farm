$files = Get-ChildItem -Path . -Filter *.html
foreach ($file in $files) {
    Write-Host "Processing $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    
    # 1. Replace the inner style block with the link tag.
    # regex matches <style> ... </style> including newlines using (?s)
    # We add a newline and indentation to make it look clean
    $content = [regex]::Replace($content, "(?s)\s*<style>.*?</style>", "`n    <link href=""style.css"" rel=""stylesheet"">")
    
    # 2. Replace legacy Bootstrap color classes with Primary (Blue) classes
    $content = $content.Replace("text-success", "text-primary")
    $content = $content.Replace("bg-success", "bg-primary")
    $content = $content.Replace("border-success", "border-primary")
    $content = $content.Replace("btn-success", "btn-primary")
    
    # Special case: badge bg-light bg-opacity-25 -> might want to ensure it looks good.
    # But replacing bg-success with bg-primary generally works for the requested "Blue" theme.
    
    # 3. Save file (using UTF8 to preserve any special chars)
    Set-Content -Path $file.FullName -Value $content -Force -Encoding UTF8
}
Write-Host "All files updated to Blue Theme."
