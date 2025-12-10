# Fields - Design des Champs de Formulaire

## Style Brutaliste pour les Champs

Tous les champs de formulaire doivent suivre le style brutaliste avec bordures noires et ombres décalées.

## Classes CSS Disponibles

### Input Standard

```css
.form-field {
  padding: 0.75rem 1rem;
  background: var(--background);
  color: var(--foreground);
  border: 3px solid var(--black);
  box-shadow: 4px 4px 0 0 var(--black);
  font-size: 1rem;
  font-family: inherit;
  transition: transform 0.2s, box-shadow 0.2s;
}

.form-field::placeholder {
  color: var(--gray-500);
}

.form-field:focus {
  outline: none;
  transform: translate(-2px, -2px);
  box-shadow: 6px 6px 0 0 var(--black);
}

.form-field:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  background: var(--gray-100);
}
```

### Textarea

```css
.form-textarea {
  padding: 0.75rem 1rem;
  background: var(--background);
  color: var(--foreground);
  border: 3px solid var(--black);
  box-shadow: 4px 4px 0 0 var(--black);
  font-size: 1rem;
  font-family: inherit;
  resize: vertical;
  min-height: 100px;
  transition: transform 0.2s, box-shadow 0.2s;
}

.form-textarea:focus {
  outline: none;
  transform: translate(-2px, -2px);
  box-shadow: 6px 6px 0 0 var(--black);
}
```

### Select

```css
.form-select {
  padding: 0.75rem 1rem;
  background: var(--background);
  color: var(--foreground);
  border: 3px solid var(--black);
  box-shadow: 4px 4px 0 0 var(--black);
  font-size: 1rem;
  font-family: inherit;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}

.form-select:focus {
  outline: none;
  transform: translate(-2px, -2px);
  box-shadow: 6px 6px 0 0 var(--black);
}
```

### Checkbox

```css
.form-checkbox {
  width: 20px;
  height: 20px;
  border: 3px solid var(--black);
  box-shadow: 2px 2px 0 0 var(--black);
  cursor: pointer;
  accent-color: var(--primary);
}

.form-checkbox:checked {
  background: var(--primary);
}
```

### Radio

```css
.form-radio {
  width: 20px;
  height: 20px;
  border: 3px solid var(--black);
  box-shadow: 2px 2px 0 0 var(--black);
  cursor: pointer;
  accent-color: var(--primary);
}
```

## États

### Focus
- Transform: `translate(-2px, -2px)`
- Box-shadow: `6px 6px 0 0 var(--black)`

### Disabled
- Opacity: `0.6`
- Background: `var(--gray-100)`
- Cursor: `not-allowed`

### Error
- Border-color: `var(--primary)` (orange pour attirer l'attention)
- Box-shadow: `4px 4px 0 0 var(--primary)`

## Labels

```css
.form-label {
  font-weight: 600;
  color: var(--foreground);
  font-size: 0.875rem;
  margin-bottom: 0.5rem;
}

.form-label.required::after {
  content: ' *';
  color: var(--primary);
}
```

## Messages d'Erreur

```css
.form-error {
  margin-top: 0.5rem;
  padding: 0.5rem;
  background: var(--primary);
  color: var(--background);
  border: 2px solid var(--black);
  box-shadow: 2px 2px 0 0 var(--black);
  font-size: 0.875rem;
}
```

## Règles Obligatoires

- **Toujours** des bordures noires (`var(--black)`) de 3px
- **Toujours** une ombre décalée (pas de blur)
- **Pas de border-radius** (sauf pour les checkboxes/radios si nécessaire)
- Background blanc (`var(--background)`) pour contraste avec le texte noir
- Focus avec transform et shadow augmentée

