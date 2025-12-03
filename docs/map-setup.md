# Configuration de la carte (OpenStreetMap)

## Carte gratuite avec Leaflet

L'application utilise **Leaflet** avec **OpenStreetMap**, une solution 100% gratuite et open source.

### Avantages

✅ **100% gratuit** - Aucune clé API nécessaire  
✅ **Open source** - Pas de limites d'utilisation  
✅ **Performant** - Légère et rapide  
✅ **Personnalisable** - Facile à styliser  

### Fonctionnalités

- Carte interactive avec OpenStreetMap
- Marqueurs personnalisés pour chaque restaurant
- Popups avec informations des restaurants et deals
- Ajustement automatique de la vue pour afficher tous les restaurants
- Responsive et adapté mobile

### Aucune configuration requise

Contrairement à Google Maps, **aucune clé API n'est nécessaire**. La carte fonctionne immédiatement après l'installation des dépendances.

### Installation

Les dépendances sont déjà installées :
- `leaflet` - Bibliothèque de cartes
- `@types/leaflet` - Types TypeScript

### Utilisation

La carte est automatiquement disponible sur la page `/map` de l'application.

Elle affiche :
- Tous les restaurants avec des coordonnées (`lat` et `lng`)
- Uniquement les restaurants ayant des deals actifs
- Des marqueurs personnalisés avec des popups informatifs

### Personnalisation

Pour modifier le style de la carte, éditez `src/components/map/RestaurantMap.vue` :

- **Changer le style des tuiles** : Modifiez l'URL dans `L.tileLayer()`
- **Modifier les marqueurs** : Changez le HTML dans `customIcon`
- **Ajuster les popups** : Modifiez la fonction `createPopupContent()`

### Alternatives de tuiles gratuites

Vous pouvez utiliser d'autres fournisseurs de tuiles gratuites :

```javascript
// OpenStreetMap (par défaut)
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png')

// CartoDB Positron (style clair)
L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png')

// CartoDB Dark Matter (style sombre)
L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png')
```

### Support

Pour plus d'informations sur Leaflet :
- [Documentation officielle](https://leafletjs.com/)
- [Exemples](https://leafletjs.com/examples.html)

