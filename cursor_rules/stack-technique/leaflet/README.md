# Leaflet

## Configuration

- Bibliothèque : `leaflet` + `@types/leaflet`
- Tiles : OpenStreetMap (gratuit)
- CSS importé dans `index.html`

## Usage

- Composant principal : `src/components/map/RestaurantMap.vue`
- Marqueurs personnalisés avec icônes
- Popups avec informations restaurant et deals

## Bonnes pratiques

- Initialiser la carte dans `onMounted`
- Nettoyer les marqueurs dans `onUnmounted`
- Gérer les erreurs de géolocalisation
- Optimiser les performances avec clustering si nécessaire

## Personnalisation

- Marqueurs : icône personnalisée 🍽️
- Popups : HTML personnalisé avec styles
- Contrôles : zoom, attribution

