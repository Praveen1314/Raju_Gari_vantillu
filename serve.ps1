# Tiny local web server for this folder (no Python needed).
# Started by start-site.bat. Close the window to stop it.
param([int]$Port = 8090)

$root = (Resolve-Path $PSScriptRoot).Path.TrimEnd('\')
$mime = @{
  '.html' = 'text/html; charset=utf-8'; '.htm' = 'text/html; charset=utf-8'
  '.css'  = 'text/css; charset=utf-8';  '.js'  = 'application/javascript; charset=utf-8'
  '.json' = 'application/json; charset=utf-8'; '.md' = 'text/plain; charset=utf-8'
  '.webp' = 'image/webp'; '.png' = 'image/png'; '.jpg' = 'image/jpeg'; '.jpeg' = 'image/jpeg'
  '.gif'  = 'image/gif';  '.svg' = 'image/svg+xml'; '.ico' = 'image/x-icon'
  '.woff2' = 'font/woff2'; '.txt' = 'text/plain; charset=utf-8'
}

# find a free port, starting at $Port
$listener = $null
for ($p = $Port; $p -lt $Port + 20; $p++) {
  try {
    $l = New-Object System.Net.HttpListener
    $l.Prefixes.Add("http://localhost:$p/")
    $l.Start()
    $listener = $l; $Port = $p; break
  } catch { }
}
if (-not $listener) { Write-Host "Could not start a server on ports $Port-$($Port+19)." -ForegroundColor Red; exit 1 }

$url = "http://localhost:$Port/"
Write-Host ""
Write-Host "  Raju Gari Pindi Vantalu is running" -ForegroundColor Yellow
Write-Host "  Folder : $root"
Write-Host "  Open   : $url" -ForegroundColor Green
Write-Host "  Keep this window open. Close it to stop the server."
Write-Host ""
Start-Process ($url + "?v=" + (Get-Random))

while ($listener.IsListening) {
  try { $ctx = $listener.GetContext() } catch { break }
  $res = $ctx.Response
  try {
    $rel = [System.Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath).TrimStart('/').Replace('/', '\')
    if ($rel -eq '') { $rel = 'index.html' }
    $full = [System.IO.Path]::GetFullPath((Join-Path $root $rel))
    if ((Test-Path $full -PathType Container)) { $full = Join-Path $full 'index.html' }
    if (-not $full.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path $full -PathType Leaf)) {
      $res.StatusCode = 404
      $bytes = [System.Text.Encoding]::UTF8.GetBytes("404 - not found: /$rel")
      $res.ContentType = 'text/plain; charset=utf-8'
    } else {
      $ext = [System.IO.Path]::GetExtension($full).ToLower()
      $res.ContentType = $(if ($mime.ContainsKey($ext)) { $mime[$ext] } else { 'application/octet-stream' })
      $bytes = [System.IO.File]::ReadAllBytes($full)
    }
    $res.Headers.Add('Cache-Control', 'no-store')
    $res.ContentLength64 = $bytes.Length
    $res.OutputStream.Write($bytes, 0, $bytes.Length)
    Write-Host ("  {0}  {1}  /{2}" -f (Get-Date -Format 'HH:mm:ss'), $res.StatusCode, $rel.Replace('\', '/'))
  } catch {
    try { $res.StatusCode = 500 } catch { }
  } finally {
    try { $res.OutputStream.Close() } catch { }
  }
}
