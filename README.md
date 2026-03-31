# Sama Xaalis

Application mobile de gestion de ventes, dettes et paiements pour vendeurs terrain.  
Conçue pour des utilisateurs non techniques — interface simple, rapide, pensée caisse physique.

---

## Stack

- **Flutter** — iOS & Android
- **Riverpod** — state management
- **Dio** — HTTP client avec intercepteur JWT
- **Freezed + json_serializable** — modèles immutables
- **Hive** — cache offline
- **flutter_secure_storage** — stockage sécurisé du token
- **record + just_audio** — notes vocales

---

## Fonctionnalités

| Module | Description |
|--------|-------------|
| Auth | Connexion par téléphone + PIN 4 chiffres |
| Ventes | Caisse POS — ajout produits, panier, cash/crédit |
| Produits | Catalogue avec indicateur de stock coloré |
| Clients | Import depuis contacts, notes vocales |
| Dettes | Manuelles + commandes crédit, paiement par tranche |
| Paiements | Historique par commande |
| Stats | CA, encaissements, taux de recouvrement |
| Exports | PDF/CSV via Cloudinary (commandes, dettes, rapport) |
| Notes vocales | Enregistrement audio sur dettes et clients |
| Offline | Cache Hive, sync automatique au retour en ligne |

---

## Architecture

```
lib/
├── core/
│   ├── cache/          # Hive + sync service
│   ├── config/         # AppConfig (base URL, timeouts)
│   ├── design/         # Design system (couleurs, typo, spacing)
│   ├── exceptions/     # ApiException
│   ├── network/        # DioClient + AuthInterceptor + AppInterceptor
│   ├── providers/      # Providers partagés (dio, repositories)
│   ├── utils/          # FlexibleIdConverter
│   └── widgets/        # AppButton, AppCard, AppInput, QtyControl...
└── features/
    ├── auth/           # Login, Register, AuthProvider
    ├── customers/      # Liste clients, import contacts
    ├── debts/          # Dettes manuelles + commandes crédit
    ├── exports/        # Export PDF/CSV
    ├── orders/         # Commandes
    ├── payments/       # Paiements
    ├── products/       # Catalogue produits
    ├── sales/          # Écran POS
    ├── stats/          # Statistiques
    ├── users/          # Modèles et service clients
    └── voice_notes/    # Enregistrement et lecture audio
```

---

## Démarrage

```bash
# Installer les dépendances
flutter pub get

# Générer les fichiers Freezed
dart run build_runner build --delete-conflicting-outputs

# Lancer l'app
flutter run
```

---

## Configuration

Modifier l'URL du backend dans `lib/core/config/app_config.dart` :

```dart
static const development = AppConfig(
  baseUrl: 'http://localhost:3000',
);

static const production = AppConfig(
  baseUrl: 'https://sama-xaalis.backnd-api.cloud',
);
```

---

## Auth

- Inscription : `POST /api/auth/register` — nom, téléphone, PIN
- Connexion : `POST /api/auth/login` — téléphone + PIN → JWT 7 jours
- Token stocké dans `flutter_secure_storage`
- Intercepteur Dio injecte `Authorization: Bearer <token>` automatiquement
- 401 → déconnexion automatique et redirection vers login

---

## Design System

Palette définie dans `lib/core/design/app_colors.dart` :

| Token | Valeur |
|-------|--------|
| primary | `#0A84FF` |
| success | `#22C55E` |
| warning | `#F59E0B` |
| danger | `#EF4444` |
| background | `#FFFFFF` |
| surface | `#F5F5F5` |
