# Composants Links - Style de la Charte Graphique

## Principes

Les liens dans l'application suivent un style cohérent avec la charte graphique :
- **Visibilité** : Les liens doivent être clairement identifiables comme des éléments cliquables
- **Cohérence** : Style uniforme avec le lien d'adresse dans le header
- **Accessibilité** : Contraste suffisant, underline pour identifier les liens
- **Interactivité** : États hover et active distincts

## Style Standard

### Structure HTML Recommandée

```vue
<router-link to="/path" class="app-link">
  <span class="link-icon">›</span>
  <span class="link-text body-text">Texte du lien</span>
</router-link>
```

### Styles CSS

```css
.app-link {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--foreground);
  text-decoration: none;
  transition: color 0.2s;
  cursor: pointer;
}

.app-link:hover {
  color: var(--primary);
}

.link-text {
  font-weight: 500;
  text-decoration: underline;
  text-decoration-color: var(--gray-500);
  text-underline-offset: 2px;
}

.link-icon {
  font-size: 1.2rem;
  color: var(--gray-500);
  transition: transform 0.2s, color 0.2s;
  margin-right: 0.25rem; /* ou margin-left selon la position */
}

.app-link:hover .link-icon {
  color: var(--primary);
  transform: translateX(2px); /* ou translateX(-2px) selon la direction */
}
```

## Types de Liens

### 1. Lien avec Chevron à Droite (›)

Pour les liens qui mènent vers une page suivante ou une action :

```vue
<router-link to="/path" class="app-link">
  <span class="link-text body-text">Texte du lien</span>
  <span class="link-icon">›</span>
</router-link>
```

### 2. Lien avec Chevron à Gauche (‹)

Pour les liens de retour ou de navigation arrière :

```vue
<router-link to="/path" class="app-link">
  <span class="link-icon">‹</span>
  <span class="link-text body-text">Retour</span>
</router-link>
```

### 3. Lien Simple (sans icône)

Pour les liens dans le contenu :

```vue
<router-link to="/path" class="app-link">
  <span class="link-text body-text">Texte du lien</span>
</router-link>
```

## Espacement

### Liens de Retour

⚠️ **OBLIGATOIRE** : Les liens "Retour" et "Retour à l'accueil" doivent avoir un espacement minimum de **40px** au-dessus et en-dessous.

```css
.back-link {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--foreground);
  text-decoration: none;
  transition: color 0.2s;
  cursor: pointer;
  margin-top: 40px;
  margin-bottom: 40px;
}
```

## Couleurs Utilisées

- **Couleur par défaut** : `var(--foreground)` (#1A1A1A - Noir)
- **Couleur au hover** : `var(--primary)` (#FF6B00 - Orange)
- **Couleur de l'underline** : `var(--gray-500)` (#666666 - Gris)
- **Couleur de l'icône** : `var(--gray-500)` (#666666 - Gris)
- **Couleur de l'icône au hover** : `var(--primary)` (#FF6B00 - Orange)

## États Interactifs

### Hover

- **Texte** : Change de noir à orange (`var(--primary)`)
- **Icône** : Change de gris à orange et se translate légèrement
- **Transition** : `0.2s` pour une animation fluide

### Active

- Pas de style spécifique nécessaire (géré par le navigateur)

## Responsive

### Mobile (< 640px)

```css
@media (max-width: 640px) {
  .link-icon {
    font-size: 1rem; /* Réduire légèrement la taille de l'icône */
  }
}
```

## Règles Obligatoires

1. ✅ **Tous les liens doivent avoir un underline** avec `text-decoration-color: var(--gray-500)`
2. ✅ **Les liens de retour doivent avoir 40px d'espacement** au-dessus et en-dessous
3. ✅ **Les icônes doivent être en gris** par défaut et devenir orange au hover
4. ✅ **Les transitions doivent être fluides** (0.2s)
5. ✅ **Le texte doit être en noir** par défaut et devenir orange au hover
6. ✅ **Les liens doivent utiliser `router-link`** pour la navigation Vue Router

## Exemples d'Utilisation

### Lien de Retour

```vue
<template>
  <router-link to="/" class="back-link">
    <span class="chevron-icon">‹</span>
    <span class="back-text body-text">Retour</span>
  </router-link>
</template>

<style scoped>
.back-link {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--foreground);
  text-decoration: none;
  transition: color 0.2s;
  cursor: pointer;
  margin-top: 40px;
  margin-bottom: 40px;
}

.back-link:hover {
  color: var(--primary);
}

.back-text {
  font-weight: 500;
  text-decoration: underline;
  text-decoration-color: var(--gray-500);
  text-underline-offset: 2px;
}

.chevron-icon {
  font-size: 1.2rem;
  color: var(--gray-500);
  transition: transform 0.2s, color 0.2s;
  margin-right: 0.25rem;
}

.back-link:hover .chevron-icon {
  color: var(--primary);
  transform: translateX(-2px);
}
</style>
```

### Lien avec Chevron à Droite

```vue
<template>
  <router-link to="/addresses" class="app-link">
    <span class="link-text body-text">Ajouter une adresse</span>
    <span class="link-icon">›</span>
  </router-link>
</template>

<style scoped>
.app-link {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--foreground);
  text-decoration: none;
  transition: color 0.2s;
  cursor: pointer;
}

.app-link:hover {
  color: var(--primary);
}

.link-text {
  font-weight: 500;
  text-decoration: underline;
  text-decoration-color: var(--gray-500);
  text-underline-offset: 2px;
}

.link-icon {
  font-size: 1.2rem;
  color: var(--gray-500);
  transition: transform 0.2s, color 0.2s;
  margin-left: 0.25rem;
}

.app-link:hover .link-icon {
  color: var(--primary);
  transform: translateX(2px);
}
</style>
```

