# Conventions de code

## Vue 3

- **Composition API uniquement** (pas d'Options API)
- `<script setup lang="ts">` pour tous les composants
- Props typées avec `defineProps<PropsType>()`
- Emits typés avec `defineEmits<EmitsType>()`

## TypeScript

- **Mode strict activé**
- Types explicites pour les fonctions publiques
- Éviter `any`, utiliser `unknown` si nécessaire
- Types générés depuis Supabase pour la base de données

## Imports

- Imports absolus avec alias `@/` (`@/components`, `@/composables`)
- Grouper les imports : Vue → Bibliothèques → Locaux
- Ordre alphabétique dans chaque groupe

## Formatage

- Utiliser Prettier (si configuré)
- 2 espaces pour l'indentation
- Point-virgule optionnel (cohérence dans le projet)

## Commentaires

- Commentaires en français pour la documentation métier
- Commentaires en anglais pour la documentation technique
- JSDoc pour les fonctions publiques complexes

