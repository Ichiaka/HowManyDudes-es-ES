# How Many Dudes — Español de España (es-ES)

Traducción **no oficial** de *How Many Dudes* al castellano de España.

Este mod añade el locale `es-ES` que faltaba: 2348 cadenas — personajes, habilidades,
reliquias, baratijas, glosario, interfaz y diálogos.

> Probado con la versión de localización `0.4.58-rc.0`.

---

## Instalación

**Windows: descarga el repo y haz doble clic en `Instalar.bat`.** Ya está.

No hace falta instalar nada: el instalador usa PowerShell, que viene con Windows.
Busca el juego solo (lee dónde tiene Steam sus bibliotecas), hace una copia de seguridad
y añade el idioma. Si no lo encuentra, te deja arrastrar el archivo `l10n.json` a la
ventana.

Luego abre el juego y elige **Spanish (Spain)** en los ajustes de idioma.

<details>
<summary>Otras formas de instalarlo</summary>

Pasándole la ruta a mano:

```powershell
powershell -ExecutionPolicy Bypass -File tools\install-es-ES.ps1 "C:\ruta\l10n.json"
```

En Mac o Linux, con [Node.js](https://nodejs.org):

```bash
node tools/install-es-ES.js "/ruta/a/How Many Dudes/Localization/l10n.json"
```

El archivo del juego está en `...\steamapps\common\How Many Dudes\Localization\l10n.json`.
En Steam: *clic derecho en el juego → Administrar → Ver archivos locales*.

</details>

Los dos instaladores hacen exactamente lo mismo:

- añaden el idioma a **tu** archivo, sin tocar ninguno de los que ya tiene;
- son idempotentes — puedes ejecutarlos las veces que quieras;
- guardan una copia de seguridad `l10n.json.bak-es-ES` la primera vez;
- conservan el formato exacto del archivo;
- avisan de las cadenas nuevas que traiga una actualización del juego y estén pendientes
  de traducir (el juego las mostrará en inglés mientras tanto).

Cada actualización del juego sobrescribe el `l10n.json`, así que habrá que repetirlo.

---

## Criterios de traducción

El término central del juego, *Dude*, se traduce por **tío**:

| Inglés | Español |
| --- | --- |
| Dude / Dudes | tío / tíos |
| Dude Type | clase de tío |
| Dude Ranch | granja |
| Roster | lista |
| Relic | reliquia |
| Trinket | baratija |
| Flyer | folleto |
| Wielder | portador |
| Thrall | esclavo |
| Skeledude | Esqueletío |
| Frankendude | Frankentío |
| Necrodude | Necrotío |
| Necrodudicon | Necrotiozicon |
| Dudiverse | Tíoverso |
| Dude Juice | Zumo para tíos |

Y en el vocabulario general se usa el registro de España: *zumo*, *patatas*, *gafas*,
*ratón*, *pajita*, *cubo*, *fiambrera*, *batido*, *cuenta atrás*, *colega*, *pincho*,
*correo electrónico*, "¡Abrid paso!", "mantén pulsado", "después de", "¿verdad?".

En los diálogos se busca que suene de aquí, no a doblaje neutro: *SWEET!* es **"¡GUAY!"**,
*DANG IT* es **"¡MECACHIS!"** (y el *OH DANG! Button*, **"Botón ¡MECACHIZ!"**), y el
*cash* que mencionan el traficante, el comerciante y el tío gourmet es **pasta** — aunque
en las estadísticas y en la interfaz se mantiene *dinero*.

Un nombre se ha adaptado en vez de traducirse al pie de la letra:

- ***Shiv* → Pincho**, que es la jerga equivalente, y además no se confunde con
  "Cuchilla de muñeca" (*Wrist Blade*) ni "Cuchillo de cazador" (*Hunter's Blade*).

### Consistencia

Las 2348 cadenas están verificadas contra el texto original en inglés:

- las **variables** (`{variables|damage|percent}`, `{round_number}`…) coinciden una a una
  con las del inglés en las 2348 — una discrepancia ahí rompería el juego;
- las **etiquetas de formato** `[c:g]…[/c]` están equilibradas en todas;
- los términos del glosario (*Max HP*, *Attack Power*, *Crit Chance*, *Cooldown*,
  *Taunt*, *Heal*…) se traducen siempre igual;
- 35 cadenas quedan sin traducir por ser nombres propios o siglas: *Wakizashi*, *Bokken*,
  *Aspis*, *Memento Mori*, *Fedora*, *Unga*, *Bunga*, *FPS*…

Quedan seis "tipo" a propósito, en las frases donde el inglés dice *type* o *kind* y no
se refiere a un Dude: "otra criatura **del mismo tipo**", "enemigo **de tipo** gorila",
"¿**Qué tipo** de comercio, dices?"…

---

## Estado

Pull requests bienvenidas. Si ves un giro que chirría, abre una issue con la clave de la
cadena (`tools/install-es-ES.js` y `translations/es-ES.json` van por clave, así que es
fácil de localizar).

## Aviso

Mod de fans, sin relación con los desarrolladores del juego. Este repo contiene
únicamente la traducción al castellano y el instalador que la añade a tu copia del
juego; no redistribuye ningún archivo del juego. *How Many Dudes?* y su texto original
son propiedad de Butterscotch Shenanigans.
