# Navbar - Design Rules

## Structure

La navbar (BottomNav) est une barre de navigation fixe en bas de l'écran avec un cercle central pour le logo.

## Styles Généraux

### Background
- **Background** : `rgba(255, 255, 255, 0.95)` (blanc presque opaque)
- **Backdrop-filter** : `blur(10px)`
- **Border-top** : `3px solid var(--black)` (bordure noire brutaliste)

### Positionnement
- **Position** : `fixed`
- **Bottom** : `0`
- **Left** : `0`
- **Right** : `0`
- **Z-index** : `100`
- **Padding-bottom** : `max(0, env(safe-area-inset-bottom))` (pour les appareils avec encoche)

## Items de Navigation

### Style Général
- **Display** : `flex`
- **Flex-direction** : `column`
- **Align-items** : `center`
- **Justify-content** : `center`
- **Gap** : `0.125rem`
- **Flex** : `1` (pour répartir l'espace)
- **Padding** : `0`

### Typographie des Textes
- **Font-size** : `1rem` (16px)
- **Font-weight** : `700` (Bold)
- **Color** : `var(--foreground)` (noir)

### États

#### Par Défaut
```css
color: #666;
```

#### Hover
```css
color: var(--primary); /* Orange électrique */
transform: translateY(-2px);
background: rgba(255, 107, 0, 0.1);
```

#### Active
```css
transform: translateY(0);
opacity: 0.8;
background: rgba(255, 107, 0, 0.2);
```

#### Router Link Active
```css
color: var(--primary);
background: rgba(255, 107, 0, 0.15);
```

## Cercle Central (Home Item)

### Positionnement
- **Flex** : `0 0 auto` (ne s'étire pas)
- **Display** : `flex`
- **Align-items** : `flex-end`
- **Overflow** : `visible` (pour permettre le dépassement)

### Style du Cercle
- **Width** : `112.5px` (desktop) / `100px` (mobile)
- **Height** : `112.5px` (desktop) / `100px` (mobile)
- **Border-radius** : `50%`
- **Background** : `rgba(255, 255, 255, 0.95)` (identique à la navbar)
- **Backdrop-filter** : `blur(10px)`
- **Border** : `3px solid rgba(50, 50, 50, 0.9)` (gris très sombre)
- **Box-shadow** : `0 4px 16px rgba(102, 126, 234, 0.4)`
- **Padding** : `12px` (desktop) / `10px` (mobile)
- **Margin-top** : `-30px` (desktop) / `-25px` (mobile) (pour descendre dans la navbar)
- **Margin-bottom** : `0`

### États du Cercle

#### Hover
```css
transform: scale(1.05);
box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
```

#### Active
```css
transform: scale(1.02);
box-shadow: 0 4px 16px rgba(102, 126, 234, 0.4);
```

#### Router Link Active
```css
transform: scale(1.05);
box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
```

## Icônes

### Taille
- **Font-size** : `1.25rem` (20px) desktop / `1.15rem` (18.4px) mobile
- **Line-height** : `1`

## Labels

### Taille
- **Font-size** : `0.875rem` (14px) - taille minimale obligatoire
- **Font-weight** : `500` (Medium)
- **Text-align** : `center`

## Responsive

### Mobile (≤640px)
- Cercle : `100px × 100px`
- Margin-top : `-25px`
- Padding : `10px`
- Border : `3px solid rgba(50, 50, 50, 0.9)`
- Icône : `1.15rem`

## Règles Obligatoires

### 1. Fond du Cercle Identique à la Navbar
⚠️ **OBLIGATOIRE** : Le fond du cercle central doit être identique à celui de la navbar
- **Navbar** : `rgba(255, 255, 255, 0.95)`
- **Cercle** : `rgba(255, 255, 255, 0.95)` (identique)

### 2. Typographie des Textes
⚠️ **OBLIGATOIRE** : Les textes des items de navigation doivent avoir :
- **Font-size** : `1rem` (16px)
- **Font-weight** : `700` (Bold)
- **Color** : `var(--foreground)` (noir)

### 3. Taille Minimale
⚠️ **OBLIGATOIRE** : Les labels doivent respecter la taille minimale de `0.875rem` (14px)

### 4. Transitions
- Tous les éléments doivent avoir des transitions fluides (`transition: all 0.2s`)

## Structure HTML Recommandée

```vue
<nav class="bottom-nav">
  <router-link to="/deals" class="nav-item">
    <span class="icon">🍽️</span>
    <span class="label">Mes Restos</span>
  </router-link>
  <router-link to="/map" class="nav-item">
    <span class="icon">📍</span>
    <span class="label">La Map</span>
  </router-link>
  <router-link to="/" class="nav-item home-item">
    <div class="home-circle">
      <img src="/logo_v2.png" alt="LA DALLE" class="home-logo" />
    </div>
  </router-link>
  <router-link to="/ma-dalle" class="nav-item">
    <span class="icon">⭐</span>
    <span class="label">Ma Dalle</span>
  </router-link>
  <router-link to="/profile" class="nav-item">
    <span class="icon">👤</span>
    <span class="label">Profil</span>
  </router-link>
</nav>
```

## Exemple CSS Complet

```css
.bottom-nav {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-top: 3px solid var(--black);
  display: flex;
  justify-content: space-around;
  align-items: stretch;
  padding: 0;
  padding-bottom: max(0, env(safe-area-inset-bottom));
  z-index: 100;
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.125rem;
  text-decoration: none;
  color: var(--foreground);
  font-size: 1rem;
  font-weight: 700;
  transition: color 0.2s, transform 0.1s, opacity 0.1s, background 0.2s;
  flex: 1;
  padding: 0;
}

.nav-item:hover {
  color: var(--primary);
  transform: translateY(-2px);
  background: rgba(255, 107, 0, 0.1);
}

.home-circle {
  width: 112.5px;
  height: 112.5px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.95); /* Identique à la navbar */
  backdrop-filter: blur(10px);
  border: 3px solid rgba(50, 50, 50, 0.9);
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.4);
  padding: 12px;
  margin-top: -30px;
}
```

