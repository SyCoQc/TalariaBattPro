# Sert la web app sur http://localhost:8080 et la rend accessible au Pixel branché en USB.
# Sur le téléphone : Chrome -> http://localhost:8080
# Ctrl+C pour arrêter.
param([int]$Port = 8080)

$root = $PSScriptRoot
$types = @{ '.html'='text/html; charset=utf-8'; '.js'='text/javascript; charset=utf-8'; '.svg'='image/svg+xml';
            '.webmanifest'='application/manifest+json'; '.json'='application/json'; '.md'='text/plain; charset=utf-8' }

$adb = (Get-Command adb -ErrorAction SilentlyContinue).Source
if ($adb) {
    & $adb reverse "tcp:$Port" "tcp:$Port" | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Host "Téléphone relié : ouvre http://localhost:$Port dans Chrome sur le Pixel." -ForegroundColor Green }
    else { Write-Host "adb : aucun téléphone détecté (débogage USB activé ?)." -ForegroundColor Yellow }
}

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Serveur prêt : http://localhost:$Port  (Ctrl+C pour arrêter)"
try {
    while ($listener.IsListening) {
        $ctx = $listener.GetContext()
        $path = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
        if ($path -eq '') { $path = 'index.html' }
        $file = [IO.Path]::GetFullPath((Join-Path $root $path))
        if ($file.StartsWith($root) -and (Test-Path $file -PathType Leaf)) {
            $bytes = [IO.File]::ReadAllBytes($file)
            $ext = [IO.Path]::GetExtension($file).ToLower()
            $ctx.Response.ContentType = if ($types[$ext]) { $types[$ext] } else { 'application/octet-stream' }
            $ctx.Response.Headers['Cache-Control'] = 'no-cache'
            $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $ctx.Response.StatusCode = 404
        }
        $ctx.Response.Close()
    }
} finally {
    $listener.Stop()
}
