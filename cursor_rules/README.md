# Cursor Rules - LA DALLE

Ce dossier contient toutes les règles et conventions pour guider l'IA de Cursor dans le développement du projet LA DALLE.

## Structure

```
cursor_rules/
├── design/              # Règles de design et UI/UX
│   ├── typographie/     # Polices, tailles, hiérarchie
│   ├── couleurs/        # Palette de couleurs, thème
│   ├── icones/          # Système d'icônes, bibliothèque
│   ├── spacing/         # Grille, espacements, padding/margin
│   └── composants/      # Guidelines pour chaque type de composant
│       ├── forms/
│       ├── navigation/
│       ├── cards/
│       ├── buttons/
│       └── modals/
├── stack-technique/     # Documentation technique des outils utilisés
│   ├── supabase/        # Règles Supabase, schéma, RLS
│   └── leaflet/         # Configuration Leaflet, marqueurs, popups
├── accessibilite/        # RGAA, WCAG, bonnes pratiques d'accessibilité
├── conventions/         # Conventions de code et nommage
│   ├── nommage/         # Conventions de nommage (fichiers, variables, etc.)
│   ├── code/            # Standards de code, patterns
│   └── git/             # Conventions Git (commits, branches)
└── architecture/        # Architecture et structure du projet
    ├── composables/     # Patterns pour les composables
    ├── stores/          # Patterns pour les stores Pinia
    └── router/          # Configuration et patterns du router
```

## Utilisation

Chaque dossier contient des fichiers markdown avec les règles spécifiques. Le fichier `.cursorrules` à la racine du projet référence cette structure.

## Ajout de nouvelles règles

1. Créer un fichier `.md` dans le dossier approprié
2. Documenter la règle de manière claire et concise
3. Mettre à jour ce README si nécessaire

