# Shadows & Borders - Style Brutaliste

## Classes CSS disponibles

### Standard Border

```css
.brutalist-border {
  border: 3px solid #1A1A1A;
  box-shadow: 4px 4px 0 0 #1A1A1A;
}
```

### Small Border

```css
.brutalist-border-sm {
  border: 2px solid #1A1A1A;
  box-shadow: 3px 3px 0 0 #1A1A1A;
}
```

### Hover Effect

```css
.brutalist-hover:hover {
  transform: translate(-2px, -2px);
  box-shadow: 6px 6px 0 0 #1A1A1A;
}
```

## Règles d'utilisation

### Obligatoires

- **Toujours** des bordures noires (`#1A1A1A`) sur les cards/boutons
- **Toujours** une ombre décalée (pas de blur)
- Pas de `border-radius > 0` (sauf badges arrondis)

### Bonnes pratiques

- Utiliser `.brutalist-border` pour les cards principales
- Utiliser `.brutalist-border-sm` pour les éléments plus petits (badges, tags)
- Ajouter `.brutalist-hover` aux éléments interactifs pour l'effet hover
- Combiner avec les classes Tailwind pour le background et le texte

## Exemples d'utilisation

### Card avec border standard

```html
<div class="brutalist-border bg-white p-4">
  <h3>Ma Card</h3>
  <p>Contenu de la card</p>
</div>
```

### Bouton avec hover effect

```html
<button class="brutalist-border brutalist-hover bg-primary text-white px-4 py-2">
  Cliquer ici
</button>
```

### Badge avec small border

```html
<span class="brutalist-border-sm bg-lime text-black px-2 py-1">
  Nouveau
</span>
```

## Implémentation

Ces classes sont définies dans `src/style.css` et utilisent la variable CSS `--black` (#1A1A1A).

