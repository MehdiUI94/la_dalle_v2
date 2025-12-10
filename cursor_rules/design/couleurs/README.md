# Couleurs

## Variables CSS

Toutes les couleurs sont définies via des variables CSS dans `src/style.css` :

### Background
- `--background`: #FFFFFF (Fond principal - BLANC)
- `--foreground`: #1A1A1A (Texte - NOIR)

### Accent Colors
- `--primary`: #FF6B00 (Orange électrique - CTA, highlights)
- `--lime`: #00FF88 (Vert lime - Badges positifs, succès)
- `--yellow`: #FFE500 (Jaune vif - Badges, attention)

### Neutrals
- `--black`: #1A1A1A (Bordures, texte)
- `--white`: #FAFAFA (Fond, texte sur dark)
- `--gray-100`: #F5F5F5 (Fond secondaire)
- `--gray-500`: #666666 (Texte muted)

## Utilisation

### En CSS
```css
color: var(--primary);
background: var(--background);
```

### En Tailwind
Les couleurs sont disponibles via Tailwind :
- `bg-background`, `text-foreground`
- `bg-primary`, `text-primary`
- `bg-lime`, `text-lime`
- `bg-yellow`, `text-yellow`
- `bg-black`, `text-black`
- `bg-white`, `text-white`
- `bg-gray-100`, `bg-gray-500`, `text-gray-500`

## États

- **Succès** : `--lime` (#00FF88)
- **Attention** : `--yellow` (#FFE500)
- **Primary/CTA** : `--primary` (#FF6B00)
