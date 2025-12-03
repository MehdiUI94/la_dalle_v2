import type { Deal } from '@/types/deal'

export const mockDeals: Deal[] = [
  {
    id: 1,
    restaurant: 'Pizza Paradise',
    description: 'Pizzas artisanales au feu de bois',
    deal: '1 Pizza = 1 Pizza offerte',
    arrondissement: '11ème',
    hours: '18h-23h',
    category: 'pizza',
    badge: '🔥 Populaire',
    groupSize: 2,
    coordinates: {
      lat: 48.8566,
      lng: 2.3522
    }
  },
  {
    id: 2,
    restaurant: 'Burger House',
    description: 'Burgers gourmets et frites maison',
    deal: '1 Burger = 1 Burger offert',
    arrondissement: '3ème',
    hours: '12h-15h, 19h-23h',
    category: 'burger',
    badge: 'Nouveau',
    groupSize: 2,
    coordinates: {
      lat: 48.8606,
      lng: 2.3376
    }
  },
  {
    id: 3,
    restaurant: 'Sushi Master',
    description: 'Sushi frais et sashimi premium',
    deal: '1 Menu = 1 Menu offert',
    arrondissement: '8ème',
    hours: '19h-23h',
    category: 'sushi',
    groupSize: 2,
    coordinates: {
      lat: 48.8738,
      lng: 2.2950
    }
  },
  {
    id: 4,
    restaurant: 'Le Bar à Cocktails',
    description: 'Cocktails créatifs et ambiance',
    deal: '1 Cocktail = 1 Cocktail offert',
    arrondissement: '6ème',
    hours: '18h-02h',
    category: 'bar',
    badge: 'Happy Hour',
    coordinates: {
      lat: 48.8442,
      lng: 2.3372
    }
  },
  {
    id: 5,
    restaurant: 'Coffee Corner',
    description: 'Café de spécialité et pâtisseries',
    deal: '1 Café = 1 Café offert',
    arrondissement: '4ème',
    hours: '8h-19h',
    category: 'cafe',
    coordinates: {
      lat: 48.8534,
      lng: 2.3488
    }
  },
  {
    id: 6,
    restaurant: 'Taco Loco',
    description: 'Tacos mexicains authentiques',
    deal: '1 Taco = 1 Taco offert',
    arrondissement: '10ème',
    hours: '12h-23h',
    category: 'burger',
    coordinates: {
      lat: 48.8700,
      lng: 2.3622
    }
  },
  {
    id: 7,
    restaurant: 'Pasta Factory',
    description: 'Pâtes fraîches et sauces maison',
    deal: '1 Plat = 1 Plat offert',
    arrondissement: '5ème',
    hours: '12h-15h, 19h-23h',
    category: 'pizza',
    groupSize: 2,
    coordinates: {
      lat: 48.8448,
      lng: 2.3447
    }
  },
  {
    id: 8,
    restaurant: 'Rooftop Bar',
    description: 'Vue panoramique sur Paris',
    deal: '1 Boisson = 1 Boisson offerte',
    arrondissement: '9ème',
    hours: '17h-02h',
    category: 'bar',
    badge: '🔥 Populaire',
    coordinates: {
      lat: 48.8722,
      lng: 2.3376
    }
  }
]

