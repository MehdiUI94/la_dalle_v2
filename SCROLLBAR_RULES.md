# 📜 Règles Obligatoires - Format de Scrollbar

## Format de Scrollbar Personnalisée - RÈGLE OBLIGATOIRE

### ⚠️ Cette configuration est OBLIGATOIRE et ne doit pas être modifiée

### Positionnement Fixe

La scrollbar personnalisée doit respecter **EXACTEMENT** ces valeurs :

#### Marges Obligatoires

1. **Bord droit** : `16px` de marge depuis le bord droit
   ```css
   right: 16px;
   ```

2. **Header** : `40px` d'espace entre le bas du header et le début de la scrollbar
   ```css
   top: 40px; /* Quand header présent */
   ```

3. **Footer** : `120px` de marge depuis le bas
   ```css
   bottom: 120px; /* Quand footer présent */
   ```

### Dimensions Fixes

- **Largeur** : `12px`
- **Border radius** : `6px`
- **Background track** : `rgba(255, 255, 255, 0.1)`
- **Background thumb** : `rgba(255, 255, 255, 0.3)`
- **Border thumb** : `2px solid rgba(255, 255, 255, 0.1)`

### Comportement

- La scrollbar doit être décollée du bord droit (`right: 16px`)
- La scrollbar doit commencer à `40px` du top quand le header est présent
- La scrollbar doit se terminer à `120px` du bottom quand le footer est présent
- La scrollbar doit s'adapter automatiquement selon la présence du header et du footer via les props `hasHeader` et `hasFooter`

### Fichier Concerné

- `src/components/shared/CustomScrollbar.vue`

### Valeurs à NE JAMAIS MODIFIER

- ❌ Ne pas changer `top: 40px` quand header présent
- ❌ Ne pas changer `bottom: 120px` quand footer présent
- ❌ Ne pas changer `right: 16px`
- ❌ Ne pas modifier les dimensions (12px de largeur)

### Vérification

Pour vérifier que la scrollbar respecte ces règles, vérifier dans `src/components/shared/CustomScrollbar.vue` :

```css
.custom-scrollbar-track.with-header {
  top: 40px; /* ✅ DOIT être 40px */
}

.custom-scrollbar-track.with-footer {
  bottom: 120px; /* ✅ DOIT être 120px */
}

.custom-scrollbar-track {
  right: 16px; /* ✅ DOIT être 16px */
  width: 12px; /* ✅ DOIT être 12px */
}
```

