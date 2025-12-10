# Typographie - Charte Graphique

## Police Principale

**Font-family** : `'Inter', system-ui, sans-serif`

Inter est la police principale du projet. Elle est utilisée pour tous les textes de l'application.

## Poids de Police (Font Weights)

### Black (900)
- **Usage** : Titres principaux, slogans
- **Exemples** : Hero titles, section titles, titres de pages

### Bold (700)
- **Usage** : Sous-titres, labels importants
- **Exemples** : Sous-titres de sections, labels de formulaires importants

### Medium (500)
- **Usage** : Corps de texte important
- **Exemples** : Textes mis en avant, descriptions importantes

### Regular (400)
- **Usage** : Corps de texte standard
- **Exemples** : Paragraphes, textes de contenu standard

## Tailles et Styles

### Hero Title

```css
.hero-title {
  font-family: 'Inter', system-ui, sans-serif;
  font-size: 3rem; /* 48px mobile */
  font-size: 4.5rem; /* 72px desktop */
  font-weight: 900;
  line-height: 1.1;
  text-transform: uppercase;
}
```

**Usage** : Titres principaux de pages hero, slogans principaux

### Section Title

```css
.section-title {
  font-family: 'Inter', system-ui, sans-serif;
  font-size: 2rem; /* 32px */
  font-weight: 900;
  line-height: 1.1;
  text-transform: uppercase;
}
```

**Usage** : Titres de sections, titres de pages importantes

### Body Text

```css
.body-text {
  font-family: 'Inter', system-ui, sans-serif;
  font-size: 1rem; /* 16px mobile */
  font-size: 1.125rem; /* 18px desktop */
  font-weight: 400;
  line-height: 1.4; /* Line-height normal pour le corps de texte */
}
```

**Usage** : Paragraphes, textes de contenu standard

## Règles Obligatoires

### 1. Titres en MAJUSCULES

⚠️ **OBLIGATOIRE** : Tous les titres doivent être en **MAJUSCULES**

- Utiliser `text-transform: uppercase` en CSS
- Ou écrire directement en majuscules dans le HTML/Vue

**Exemples** :
- ✅ "DÉCOUVRIR LES DEALS"
- ✅ "MES RESTAURANTS"
- ❌ "Découvrir les deals"
- ❌ "Mes restaurants"

### 2. Pas d'Italique

⚠️ **OBLIGATOIRE** : Ne jamais utiliser l'italique sauf pour emphase dans le texte

- Éviter `font-style: italic` sur les titres
- Éviter `<em>` ou `<i>` sur les titres
- L'italique peut être utilisé uniquement pour mettre en emphase un mot ou une phrase dans un paragraphe de texte

### 3. Line-height Serré sur les Titres

⚠️ **OBLIGATOIRE** : Les titres doivent avoir un line-height serré (1.1)

- Hero titles : `line-height: 1.1`
- Section titles : `line-height: 1.1`
- Body text : `line-height: 1.4` (normal)

### 4. Taille Minimale de Police

⚠️ **OBLIGATOIRE** : La taille de police des textes ne peut pas être inférieure à 14px (0.875rem)

- Tous les textes lisibles par l'utilisateur doivent respecter cette taille minimale
- Exception : les icônes et éléments décoratifs peuvent être plus petits

### 5. Couleur des Textes

⚠️ **OBLIGATOIRE** : Tous les textes doivent être en noir par défaut

- **Couleur par défaut** : `var(--foreground)` (#1A1A1A) ou `var(--black)` (#1A1A1A)
- Tous les textes lisibles doivent utiliser cette couleur
- Les textes sur fond blanc doivent être en noir
- Exception : Les messages d'erreur peuvent utiliser `var(--primary)` pour attirer l'attention
- Exception : Les textes de succès peuvent utiliser `var(--lime)` pour indiquer le succès

### 6. Majuscules sur les Textes Utilisateur

⚠️ **OBLIGATOIRE** : Tous les textes affichés à l'utilisateur doivent commencer par une majuscule

- Labels de formulaires : "Email", "Mot de passe", "Adresse"
- Messages d'erreur : "Erreur lors de la connexion"
- Boutons : "Se connecter", "Retour à l'accueil"
- Titres et sous-titres : "Mon Profil", "Tous les Deals"
- Messages de succès : "Note enregistrée avec succès"
- Placeholders : "Votre@email.com", "Commencez à taper..."

## Hiérarchie Typographique

### Niveau 1 - Hero Title
- **Taille** : 3rem (48px) mobile / 4.5rem (72px) desktop
- **Poids** : 900 (Black)
- **Transform** : uppercase
- **Line-height** : 1.1

### Niveau 2 - Section Title
- **Taille** : 2rem (32px)
- **Poids** : 900 (Black)
- **Transform** : uppercase
- **Line-height** : 1.1

### Niveau 3 - Sous-titre
- **Taille** : 1.5rem (24px) mobile / 2rem (32px) desktop
- **Poids** : 700 (Bold)
- **Transform** : uppercase (si titre) / normal (si sous-titre descriptif)
- **Line-height** : 1.2

### Niveau 4 - Body Important
- **Taille** : 1rem (16px) mobile / 1.125rem (18px) desktop
- **Poids** : 500 (Medium)
- **Line-height** : 1.4

### Niveau 5 - Body Standard
- **Taille** : 1rem (16px) mobile / 1.125rem (18px) desktop
- **Poids** : 400 (Regular)
- **Line-height** : 1.4

## Classes Tailwind Recommandées

Pour faciliter l'utilisation, voici les classes Tailwind équivalentes :

```html
<!-- Hero Title -->
<h1 class="text-5xl md:text-9xl font-black uppercase leading-tight">
  TITRE PRINCIPAL
</h1>

<!-- Section Title -->
<h2 class="text-4xl md:text-7xl font-black uppercase leading-tight">
  TITRE DE SECTION
</h2>

<!-- Sous-titre -->
<h3 class="text-2xl md:text-3xl font-bold uppercase leading-snug">
  SOUS-TITRE
</h3>

<!-- Body Important -->
<p class="text-base md:text-lg font-medium leading-normal">
  Texte important
</p>

<!-- Body Standard -->
<p class="text-base md:text-lg font-normal leading-normal">
  Texte standard
</p>
```

## Responsive

### Mobile First

Toutes les tailles de police suivent une approche mobile-first :

```css
/* Mobile (par défaut) */
font-size: 3rem; /* 48px */

/* Desktop (md et plus) */
@media (min-width: 768px) {
  font-size: 4.5rem; /* 72px */
}
```

### Breakpoints

- **Mobile** : < 768px
- **Desktop** : ≥ 768px

## Exemples d'Utilisation

### Hero Section
```vue
<h1 class="hero-title">
  LA DALLE
</h1>
<p class="body-text">
  Food Deals à Paris
</p>
```

### Section
```vue
<h2 class="section-title">
  MES RESTAURANTS
</h2>
<p class="body-text">
  Découvrez les meilleures offres du moment
</p>
```

### Formulaire
```vue
<label class="font-bold text-base">
  Email
</label>
<input 
  type="email" 
  placeholder="Votre@email.com"
  class="body-text"
/>
```

## Récapitulatif des Règles Obligatoires

1. ✅ Font-family : `'Inter', system-ui, sans-serif`
2. ✅ Titres en MAJUSCULES (`text-transform: uppercase`)
3. ✅ Pas d'italique sauf emphase dans le texte
4. ✅ Line-height serré sur titres (1.1)
5. ✅ Taille minimale : 14px (0.875rem)
6. ✅ Tous les textes utilisateur commencent par une majuscule
7. ✅ **Tous les textes doivent être en noir par défaut** (`var(--foreground)` ou `var(--black)`)
8. ✅ Mobile-first pour les tailles responsive
