#!/usr/bin/env node
/**
 * install-es-ES.js — instala la traducción al castellano de España en el
 * l10n.json de How Many Dudes.
 *
 * Uso:
 *   node tools/install-es-ES.js "C:/.../How Many Dudes/Localization/l10n.json"
 *
 * - Inserta (o actualiza) el locale es-ES con el contenido de translations/es-ES.json.
 * - No modifica ningún otro idioma del archivo.
 * - Es idempotente: puedes ejecutarlo tantas veces como quieras.
 * - Guarda una copia de seguridad l10n.json.bak-es-ES la primera vez.
 * - Conserva el formato original del archivo (indentación de 2 espacios y CRLF).
 * - Avisa de las claves que el juego tenga y a la traducción le falten, para que
 *   se vea qué texto ha añadido una actualización y está pendiente de traducir.
 */
const fs = require('fs');
const path = require('path');

const LOCALE = 'es-ES';
const DATA = path.join(__dirname, '..', 'translations', LOCALE + '.json');

function main() {
  const target = process.argv[2];
  if (!target) {
    console.error('Uso: node tools/install-es-ES.js "<ruta a l10n.json>"');
    process.exit(1);
  }

  const raw = fs.readFileSync(target, 'utf8');
  const data = JSON.parse(raw);
  const translation = JSON.parse(fs.readFileSync(DATA, 'utf8'));

  if (!data.translations) throw new Error('El archivo no tiene un bloque "translations": ' + target);

  if (!fs.existsSync(target + '.bak-es-ES')) {
    fs.writeFileSync(target + '.bak-es-ES', raw, 'utf8');
    console.log('Copia de seguridad: ' + target + '.bak-es-ES');
  }

  // Claves que el juego espera, según los idiomas que ya trae el archivo
  const esperadas = new Set();
  for (const [loc, obj] of Object.entries(data.translations)) {
    if (loc !== LOCALE) Object.keys(obj).forEach(k => esperadas.add(k));
  }
  const faltan = [...esperadas].filter(k => !(k in translation));
  const sobran = Object.keys(translation).filter(k => esperadas.size && !esperadas.has(k));

  // El locale va al final para no alterar el orden de los que ya están
  const rebuilt = {};
  for (const loc of Object.keys(data.translations)) {
    if (loc !== LOCALE) rebuilt[loc] = data.translations[loc];
  }
  rebuilt[LOCALE] = translation;
  data.translations = rebuilt;

  let out = JSON.stringify(data, null, 2);
  if (raw.includes('\r\n')) out = out.replace(/\n/g, '\r\n');
  fs.writeFileSync(target, out, 'utf8');

  console.log(LOCALE + ' instalado: ' + Object.keys(translation).length + ' cadenas.');
  console.log('Idiomas en el archivo: ' + Object.keys(data.translations).join(', '));
  if (faltan.length) {
    console.log('\nAviso: ' + faltan.length + ' cadenas nuevas del juego aún sin traducir');
    console.log('(el juego mostrará el texto en inglés en su lugar):');
    faltan.slice(0, 20).forEach(k => console.log('  - ' + k));
    if (faltan.length > 20) console.log('  … y ' + (faltan.length - 20) + ' más');
  }
  if (sobran.length) {
    console.log('\nAviso: ' + sobran.length + ' cadenas traducidas que el juego ya no usa.');
  }
}

main();
