# RGAA (Référentiel Général d'Amélioration de l'Accessibilité)

## Niveau de conformité

**Objectif : RGAA 4.1 niveau AA minimum**

## Critères essentiels

### 1. Images

- **Toutes les images doivent avoir un attribut `alt`**
- Images décoratives : `alt=""`
- Images informatives : `alt` descriptif et pertinent
- Images complexes : description détaillée dans le texte adjacent

### 2. Formulaires

- **Tous les champs doivent avoir un `<label>` associé**
- Utiliser `for` sur le label et `id` sur l'input
- Messages d'erreur clairs et associés au champ
- Indication des champs obligatoires (astérisque + texte)
- Validation côté client ET serveur

### 3. Navigation

- **Structure sémantique HTML5** : `<header>`, `<nav>`, `<main>`, `<footer>`
- Liens de navigation accessibles au clavier
- Indication visuelle du focus
- Ordre de tabulation logique

### 4. Contraste

- **Ratio minimum 4.5:1** pour le texte normal
- **Ratio minimum 3:1** pour le texte large (18px+ ou gras 14px+)
- Vérifier avec des outils comme WebAIM Contrast Checker

### 5. Clavier

- **Toutes les fonctionnalités accessibles au clavier**
- Pas de piège au clavier (focus bloqué)
- Raccourcis clavier documentés
- Ordre de tabulation logique

### 6. ARIA

- Utiliser les attributs ARIA quand nécessaire
- `aria-label` pour les boutons icon-only
- `aria-describedby` pour les descriptions
- `aria-live` pour les mises à jour dynamiques
- `role` seulement si nécessaire (HTML5 sémantique préféré)

### 7. Focus

- **Indicateur de focus visible** sur tous les éléments interactifs
- Contraste suffisant (au moins 3:1)
- Taille minimale : 2px de bordure

### 8. Titres

- **Hiérarchie logique** : h1 → h2 → h3, etc.
- Un seul h1 par page
- Pas de saut de niveau (h1 → h3 interdit)

### 9. Liens

- **Texte de lien descriptif** (pas "cliquez ici")
- Liens identifiables (soulignés ou couleur distincte)
- Liens externes : indication (icône ou texte)

### 10. Tableaux

- Utiliser `<th>` pour les en-têtes
- `scope` pour associer cellules et en-têtes
- `<caption>` pour les tableaux complexes

## Outils de vérification

- **aXe DevTools** : Extension navigateur
- **WAVE** : Extension navigateur
- **Lighthouse** : Audit intégré Chrome
- **Asqatasun** : Outil français de test RGAA

## Checklist avant mise en production

- [ ] Toutes les images ont un `alt`
- [ ] Tous les formulaires ont des labels
- [ ] Contraste vérifié (4.5:1 minimum)
- [ ] Navigation au clavier fonctionnelle
- [ ] Focus visible sur tous les éléments
- [ ] Structure HTML5 sémantique
- [ ] ARIA utilisé correctement
- [ ] Tests avec lecteur d'écran (NVDA/JAWS)

## Ressources

- [RGAA 4.1](https://www.numerique.gouv.fr/publications/rgaa-accessibilite/)
- [WCAG 2.1](https://www.w3.org/WAI/WCAG21/quickref/)
- [MDN Accessibility](https://developer.mozilla.org/fr/docs/Web/Accessibility)

