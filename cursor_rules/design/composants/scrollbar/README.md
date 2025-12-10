# Scrollbar - Règles Obligatoires

## Format de Scrollbar Personnalisée

### Positionnement

La scrollbar personnalisée doit respecter les règles suivantes :

#### Marges Obligatoires

1. **Bord droit** : `16px` de marge depuis le bord droit
2. **Header** : `40px` d'espace entre le bas du header et le début de la scrollbar
3. **Footer** : `120px` de marge depuis le bas (pour décoller du footer et raccourcir la scrollbar)

#### Dimensions

- **Largeur** : `12px`
- **Border radius** : `6px`
- **Background** : `rgba(255, 255, 255, 0.1)`
- **Thumb background** : `rgba(255, 255, 255, 0.3)`
- **Thumb border** : `2px solid rgba(255, 255, 255, 0.1)`

#### Comportement

- La scrollbar doit être décollée du bord droit (`right: 16px`)
- La scrollbar doit commencer à `40px` du top quand le header est présent
- La scrollbar doit se terminer à `120px` du bottom quand le footer est présent
- La scrollbar doit s'adapter automatiquement selon la présence du header et du footer

### CSS Obligatoire

```css
.custom-scrollbar-track {
  position: absolute;
  right: 16px; /* Décollé du bord droit */
  top: 16px; /* Par défaut */
  bottom: 16px; /* Par défaut */
  width: 12px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 6px;
  pointer-events: none;
}

.custom-scrollbar-track.with-header {
  top: 40px; /* 40px d'espace entre le header et la scrollbar */
}

.custom-scrollbar-track.with-footer {
  bottom: 120px; /* Décollé du footer + raccourci de 40px */
}

.custom-scrollbar-track.with-header.with-footer {
  top: 40px;
  bottom: 120px;
}
```

### Props du Composant

Le composant `CustomScrollbar` doit recevoir les props suivantes :

- `hasHeader?: boolean` - Indique si le header est présent
- `hasFooter?: boolean` - Indique si le footer est présent

### Règle Obligatoire

⚠️ **Ce format de scrollbar est OBLIGATOIRE et ne doit pas être modifié sans autorisation explicite.**

Les valeurs suivantes sont fixes :
- Espace depuis le header : `40px`
- Espace depuis le footer : `120px`
- Espace depuis le bord droit : `16px`

