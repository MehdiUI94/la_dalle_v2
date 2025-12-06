# WCAG 2.1 (Web Content Accessibility Guidelines)

## Niveaux de conformité

- **A** : Niveau minimum (obligatoire)
- **AA** : Niveau recommandé (objectif pour LA DALLE)
- **AAA** : Niveau optimal (optionnel)

## Principes fondamentaux

### 1. Perceptible

- Alternatives textuelles pour les images
- Sous-titres pour les vidéos
- Contraste suffisant (4.5:1 AA, 7:1 AAA)
- Redimensionnable jusqu'à 200% sans perte de fonctionnalité

### 2. Utilisable

- Accessible au clavier
- Pas de contenu clignotant (peut provoquer des crises)
- Navigation claire et prévisible
- Aide à la saisie (labels, erreurs, suggestions)

### 3. Compréhensible

- Langue de la page indiquée (`lang` sur `<html>`)
- Texte lisible et compréhensible
- Fonctionnement prévisible
- Aide à la correction des erreurs

### 4. Robuste

- Compatible avec les technologies d'assistance
- Code HTML valide
- Utilisation correcte des attributs ARIA

## Critères AA essentiels

### Contraste

- Texte normal : **4.5:1**
- Texte large : **3:1**
- Composants UI : **3:1**

### Taille du texte

- Redimensionnable jusqu'à 200% sans scroll horizontal
- Pas de perte de contenu ou de fonctionnalité

### Focus

- Visible sur tous les éléments interactifs
- Ordre de tabulation logique
- Pas de piège au clavier

### Formulaires

- Labels associés
- Messages d'erreur clairs
- Suggestions de correction

### Navigation

- Plusieurs moyens de navigation
- Titres descriptifs de page
- Liens identifiables

## Bonnes pratiques

1. **Tester avec un lecteur d'écran** (NVDA, JAWS, VoiceOver)
2. **Naviguer uniquement au clavier** (Tab, Enter, Espace)
3. **Vérifier le contraste** avec des outils dédiés
4. **Valider le HTML** avec le validateur W3C
5. **Tester sur différents navigateurs** et appareils

