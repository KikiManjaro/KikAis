# Spec : Amélioration de la page GitHub Pages KikAis

Date : 2026-08-17

## Objectif

Remplacer la page de téléchargement minimaliste de GitHub Pages par une page vitrine complète tout en préservant le système d'update auto (appcast.xml + WinSparkle).

## Contraintes

- Le workflow `release.yml` déploie `build/pages/` sur GitHub Pages → inchangé.
- L'appcast.xml doit rester généré à l'identique → le système d'update auto continue de fonctionner.
- L'ancienne page de download simple reste accessible en `/download.html` pour compatibilité.
- Les screenshots du README (`readme_images/`) sont copiés dans le build.
- Aucune dépendance externe (pas de framework CSS/JS, pas de générateur de site). Tout est inline.
- La version est lue depuis `pubspec.yaml` et injectée (même logique que l'appcast).

## Architecture

### Fichiers modifiés

1. **`scripts/make_setup.ps1`** — ajout de la génération de la page vitrine.
2. **`build/pages/index.html`** — page vitrine (générée par le script).
3. **`build/pages/download.html`** — ancienne page de download (renommée depuis index.html).
4. **`build/pages/appcast.xml`** — inchangé.
5. **`build/pages/readme_images/`** — screenshots copiés depuis la racine `readme_images/`.

### Structure de la page index.html

```
HERO SECTION
- Logo (FireBoat2.png)
- Titre + sous-titre
- Badges (version, license, platforms, CI, Flutter)
- Bouton "Télécharger la dernière version" + lien GitHub

FEATURES SECTION
- Grille responsive
- 6 catégories : Réception, Forwarding, Map, Editor, Tools, Stats
- Chaque catégorie : emoji + titre + 3-4 bullets essentiels
- 8e catégorie Extras (thèmes, updates auto, isolat)

SCREENSHOTS SECTION
- Grille responsive avec légendes
- Reception, Map, Editor, Tools (4 images clés)

FOOTER
- Liens GitHub, Buy Me a Coffee, GitHub Sponsors, License
- Version (depuis pubspec.yaml)
```

### Données injectées

- **Version** : lue depuis `pubspec.yaml`.
- **Screenshots** : copiés depuis `readme_images/` (racine) vers `build/pages/readme_images/`.
- **Download URL** : basée sur `$DownloadBaseUrl` (identique à l'appcast).
- **Liens de download** : setup.exe (primaire), portable.exe, zip, linux tar.gz.

### Style

- Dark mode tech : fond `#0f172a`, texte `#e2e8f0`, accent `#0ea5e9`, secondaire `#38bdf8`.
- CSS inline dans le HTML (aucune dépendance).
- Responsive (media queries, grilles flex/grid).
- Font : system-ui, -apple-system, Segoe UI, Roboto, sans-serif.

### Compatibilité

- L'appcast.xml est généré exactement comme avant.
- L'ancienne page simple est déplacée vers `download.html`.
- Les anciens liens `/` continuent de fonctionner (la vitrine remplace l'ancienne page).
- Le lien "Autres fichiers de cette version" pointe vers `download.html`.

## Comportement du script make_setup.ps1

Après la génération de l'appcast, le script :

1. Lit la version (déjà disponible via `$Version`).
2. Copie le dossier `readme_images` (racine) vers `$AppcastDir/readme_images/` s'il existe.
3. Génère `index.html` avec le design ci-dessus.
4. Écrit l'ancienne page simple dans `download.html` au lieu de `index.html`.

## Critères d'acceptation

- `make_setup.ps1 -Version x.y.z -AppcastDir build/pages -DownloadBaseUrl ...` produit `appcast.xml`, `index.html` (vitrine), `download.html` (simple) et `readme_images/` dans `build/pages`.
- `appcast.xml` conserve exactement le même format qu'avant (le client WinSparkle continue de fonctionner).
- La page vitrine est responsive et dark-mode.
- Les screenshots apparaissent correctement (chemins relatifs valides).
