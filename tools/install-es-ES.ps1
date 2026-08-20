<#
    Instalador de la traduccion al castellano de Espana para How Many Dudes.
    No necesita nada instalado: PowerShell viene con Windows.

    Uso normal:  doble clic en Instalar.bat
    Uso manual:  powershell -ExecutionPolicy Bypass -File install-es-ES.ps1 ["ruta\l10n.json"]
#>
param([string]$Ruta)

$ErrorActionPreference = 'Stop'
$LOCALE = 'es-ES'
$UTF8   = New-Object System.Text.UTF8Encoding($false)
$bs     = [string][char]92          # barra invertida, sin lios de escapado

function Escribe($texto, $color = 'Gray') { Write-Host $texto -ForegroundColor $color }

function Busca-Juego {
    $candidatas = New-Object System.Collections.Generic.List[string]
    $bases = New-Object System.Collections.Generic.List[string]

    foreach ($clave in @('HKCU:\Software\Valve\Steam', 'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam', 'HKLM:\SOFTWARE\Valve\Steam')) {
        try {
            $p = Get-ItemProperty -Path $clave -ErrorAction Stop
            foreach ($v in @($p.SteamPath, $p.InstallPath)) {
                if ($v) { $bases.Add($v.Replace('/', $bs)) }
            }
        } catch { }
    }
    foreach ($d in @('C:\Program Files (x86)\Steam', 'C:\Steam', 'D:\Steam', 'E:\Steam')) { $bases.Add($d) }

    # Bibliotecas adicionales declaradas por Steam
    foreach ($b in @($bases)) {
        $vdf = Join-Path $b 'steamapps\libraryfolders.vdf'
        if (Test-Path $vdf) {
            foreach ($linea in (Get-Content $vdf)) {
                if ($linea -match '"path"\s+"(.+?)"') { $bases.Add($Matches[1].Replace($bs + $bs, $bs)) }
            }
        }
    }

    $vistas = New-Object 'System.Collections.Generic.HashSet[string]'
    foreach ($b in $bases) {
        $f = Join-Path $b 'steamapps\common\How Many Dudes\Localization\l10n.json'
        if (Test-Path $f) {
            $completa = (Resolve-Path $f).Path
            if ($vistas.Add($completa.ToLowerInvariant())) { $candidatas.Add($completa) }
        }
    }
    return $candidatas
}

function Bloque-Traduccion($rutaDatos) {
    $texto  = [System.IO.File]::ReadAllText($rutaDatos, $UTF8)
    $lineas = $texto -split "`r`n|`n"
    $salida = New-Object System.Collections.Generic.List[string]
    $salida.Add('    "' + $LOCALE + '": {')
    for ($i = 1; $i -lt $lineas.Count - 1; $i++) { $salida.Add('    ' + $lineas[$i]) }
    $salida.Add('    }')
    return $salida
}

Escribe ''
Escribe '  How Many Dudes? - Traduccion al castellano de Espana' 'Cyan'
Escribe '  ---------------------------------------------------' 'Cyan'
Escribe ''

# --- 1. Localizar el archivo del juego
if (-not $Ruta) {
    $encontradas = @(Busca-Juego)
    if ($encontradas.Count -eq 1) {
        $Ruta = $encontradas[0]
        Escribe ("  Juego encontrado en:`n    " + $Ruta) 'Green'
    } elseif ($encontradas.Count -gt 1) {
        Escribe '  Se han encontrado varias instalaciones:'
        for ($i = 0; $i -lt $encontradas.Count; $i++) { Escribe ("    [$($i+1)] " + $encontradas[$i]) }
        $sel = 0
        while ($sel -lt 1 -or $sel -gt $encontradas.Count) {
            $r = Read-Host '  Elige el numero'
            [int]::TryParse($r, [ref]$sel) | Out-Null
        }
        $Ruta = $encontradas[$sel - 1]
    } else {
        Escribe '  No he encontrado el juego automaticamente.' 'Yellow'
        Escribe '  Arrastra aqui el archivo l10n.json del juego y pulsa Intro.'
        Escribe '  Suele estar en: ...\steamapps\common\How Many Dudes\Localization\'
        $Ruta = (Read-Host '  Archivo').Trim('"', ' ')
    }
}

if (-not (Test-Path $Ruta)) { Escribe "  ERROR: no existe el archivo: $Ruta" 'Red'; exit 1 }

# --- 2. Cargar la traduccion (junto a este script)
$datos = Join-Path (Split-Path $PSScriptRoot -Parent) 'translations\es-ES.json'
if (-not (Test-Path $datos)) { Escribe "  ERROR: no encuentro $datos" 'Red'; exit 1 }

# --- 3. Copia de seguridad
$copia = "$Ruta.bak-es-ES"
if (-not (Test-Path $copia)) {
    Copy-Item $Ruta $copia
    Escribe "  Copia de seguridad guardada en:`n    $copia" 'DarkGray'
}

# --- 4. Insertar el idioma
$original = [System.IO.File]::ReadAllText($Ruta, $UTF8)
$salto    = if ($original -match "`r`n") { "`r`n" } else { "`n" }
$lineas   = New-Object System.Collections.Generic.List[string]
$lineas.AddRange([string[]]($original -split "`r`n|`n"))

# 4a. Quitar una instalacion anterior, si la hay
$ini = $lineas.IndexOf('    "' + $LOCALE + '": {')
if ($ini -ge 0) {
    $fin = -1
    for ($i = $ini + 1; $i -lt $lineas.Count; $i++) {
        if ($lineas[$i] -eq '    }' -or $lineas[$i] -eq '    },') { $fin = $i; break }
    }
    if ($fin -lt 0) { Escribe '  ERROR: el archivo tiene un formato inesperado.' 'Red'; exit 1 }
    $lineas.RemoveRange($ini, $fin - $ini + 1)
    if ($ini -gt 0 -and $lineas[$ini] -eq '  }' -and $lineas[$ini - 1] -eq '    },') { $lineas[$ini - 1] = '    }' }
}

# 4b. Insertar al final del bloque de idiomas
$cierre = $lineas.LastIndexOf('  }')
if ($cierre -lt 1) { Escribe '  ERROR: el archivo tiene un formato inesperado.' 'Red'; exit 1 }
if ($lineas[$cierre - 1] -eq '    }') { $lineas[$cierre - 1] = '    },' }
$lineas.InsertRange($cierre, [string[]](Bloque-Traduccion $datos))

# --- 5. Comprobaciones antes de escribir
$resultado = [string]::Join($salto, $lineas)
$ok = ($resultado.TrimStart().StartsWith('{')) -and
      ($resultado.TrimEnd().EndsWith('}')) -and
      (([regex]::Matches($resultado, '(?m)^    "' + $LOCALE + '": \{\r?$')).Count -eq 1)
if (-not $ok) { Escribe '  ERROR: el resultado no cuadra. No se ha modificado nada.' 'Red'; exit 1 }

[System.IO.File]::WriteAllText($Ruta, $resultado, $UTF8)

$n = ([regex]::Matches((Get-Content $datos -Raw), '(?m)^  "')).Count
Escribe ''
Escribe "  Listo. Traduccion instalada ($n textos)." 'Green'
Escribe '  Abre el juego y elige "Spanish (Spain)" en los ajustes de idioma.' 'Green'
Escribe ''
Escribe '  (Cada actualizacion del juego borra el idioma: vuelve a ejecutar esto.)' 'DarkGray'
Escribe ''
