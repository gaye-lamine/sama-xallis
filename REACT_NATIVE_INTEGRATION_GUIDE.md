# Gestion Dette API
**Version:** 1.0.0
**OAS:** 3.0
**Description:** Documentation détaillée de l'API de gestion de dettes et produits pour l'intégration Front-End (React Native).

## Standard d'Erreur Global
Toutes les erreurs renvoyées par l'API utilisent la structure suivante :
```json
{
  "success": false,
  "message": "Description détaillée de l'erreur",
  "statusCode": 404
}
```

---

## 👤 Users

### `GET` /api/users
Liste tous les utilisateurs.
* **Paramètres :** Aucun
* **Succès (200 OK) :** `User[]` (tableau d'utilisateurs sans le mot de passe).

### `POST` /api/users
Créer un utilisateur.
* **Body :** 
  ```json
  {
    "name": "string",
    "email": "string",
    "password": "string"
  }
  ```
* **Succès (201 Created) :** Retourne l'objet `User` créé (sans `password`).
* **Erreurs :**
  * `400 Bad Request` : "Missing required user fields"
  * `400 Bad Request` : "User with this email already exists"

### `GET` /api/users/{id}
Obtenir un utilisateur par ID.
* **Paramètres de chemin :** `id` (string)
* **Succès (200 OK) :** Objet `User`.
* **Erreurs :**
  * `404 Not Found` : "User not found"

### `PUT` /api/users/{id}
Mettre à jour un utilisateur.
* **Paramètres de chemin :** `id` (string)
* **Body :** Champs optionnels : `{ "name": "...", "email": "...", "password": "..." }`
* **Succès (200 OK) :** Objet `User` mis à jour.
* **Erreurs :**
  * `404 Not Found` : "User not found"

### `DELETE` /api/users/{id}
Supprimer un utilisateur.
* **Paramètres de chemin :** `id` (string)
* **Succès (204 No Content) :** Aucun contenu retourné.
* **Erreurs :**
  * `404 Not Found` : "User not found"

---

## 💸 Debts

### `GET` /api/debts
Liste toutes les dettes.
* **Paramètres :** Aucun
* **Succès (200 OK) :** `Debt[]`

### `POST` /api/debts
Créer une dette manuelle pour un client.
* **Body :** 
  ```json
  {
    "userId": "string",
    "amount": 100.5,
    "description": "string",
    "dueDate": "2024-12-31T00:00:00Z", // Optionnel
    "status": "pending" // ou "paid", "overdue"
  }
  ```
* **Succès (201 Created) :** Retourne l'objet `Debt` créé.
* **Erreurs :**
  * `400 Bad Request` : "Debt must have a userId"
  * `400 Bad Request` : "Debt amount must be a positive number."
  * `400 Bad Request` : "Debt description is required."

### `GET` /api/debts/{id}
Obtenir une dette par ID.
* **Paramètres de chemin :** `id` (string)
* **Succès (200 OK) :** Objet `Debt`.
* **Erreurs :**
  * `404 Not Found` : "Debt not found."

### `PUT` /api/debts/{id}
Mettre à jour une dette.
* **Paramètres de chemin :** `id` (string)
* **Body :** Champs optionnels de `Debt`.
* **Succès (200 OK) :** Objet `Debt` mis à jour.
* **Erreurs :**
  * `404 Not Found` : "Debt not found."

### `DELETE` /api/debts/{id}
Supprimer une dette.
* **Paramètres de chemin :** `id` (string)
* **Succès (204 No Content) :** Aucun contenu retourné.
* **Erreurs :**
  * `404 Not Found` : "Debt not found."

---

## 📦 Products

### `GET` /api/products
Liste tous les produits.
* **Succès (200 OK) :** `Product[]`

### `POST` /api/products
Créer un produit.
* **Body :** 
  ```json
  {
    "name": "string",
    "purchasePrice": 10,
    "sellingPrice": 15,
    "stock": 50
  }
  ```
* **Succès (201 Created) :** Objet `Product` créé.
* **Erreurs :**
  * `400 Bad Request` : Erreur Zod (Formatage de données incorrect).
  * `400 Bad Request` : "selling_price must be >= purchase_price"
  * `400 Bad Request` : "stock cannot be negative"

### `GET` /api/products/{id}
Obtenir un produit par ID.
* **Paramètres de chemin :** `id` (string)
* **Succès (200 OK) :** Objet `Product`.
* **Erreurs :**
  * `404 Not Found` : "Product not found"

### `PUT` /api/products/{id}
Mettre à jour un produit.
* **Paramètres de chemin :** `id` (string)
* **Body :** `Partial<{ name, purchasePrice, sellingPrice, stock }>`
* **Succès (200 OK) :** Objet `Product` mis à jour.
* **Erreurs :**
  * `400 Bad Request` : "selling_price must be >= purchase_price"
  * `400 Bad Request` : "stock cannot be negative"

### `DELETE` /api/products/{id}
Supprimer un produit.
* **Paramètres de chemin :** `id` (string)
* **Succès (204 No Content) :** Aucun contenu retourné.

---

## 🛒 Orders

### `GET` /api/orders
Liste toutes les commandes.
* **Succès (200 OK) :** `Order[]`

### `POST` /api/orders
Créer une commande (Passe par le catalogue de produits).
* **Body :** 
  ```json
  {
    "paymentType": "cash", // ou "credit"
    "customerId": "string", // Optionnel
    "paidAmount": 0, // Optionnel (acompte immédiat)
    "items": [
      {
        "productId": "string",
        "quantity": 2,
        "unitPrice": 15 // Optionnel (utilise le sellingPrice par défaut)
      }
    ]
  }
  ```
* **Succès (201 Created) :** `{ order: Order, items: OrderItem[] }`.
* **Erreurs :**
  * `400 Bad Request` : Erreur Zod (ex: "items ne peut pas être vide").
  * `500 Server Error` : "Product not found: {id}"
  * `500 Server Error` : "Insufficient stock for product {id}"

### `GET` /api/orders/{id}
Obtenir une commande par ID.
* **Paramètres de chemin :** `id` (string)
* **Succès (200 OK) :** Objet `Order` incluant un tableau de ses `items`.

### `POST` /api/orders/{id}/payments
Ajouter un paiement à une commande spécifique.
* **Paramètres de chemin :** `id` (string / Order ID)
* **Body :** 
  ```json
  {
    "paidAmount": 50
  }
  ```
* **Succès (200 OK) :** `{ paidAmount: number, remainingAmount: number, status: string }`
* **Erreurs :**
  * `400 Bad Request` : Erreur Zod.
  * `500 Server Error` : "Order not found"

---

## 💳 Payments

### `POST` /api/payments
Créer un paiement indépendant lié à une commande. 
*Contrairement au module Orders ci-dessus, cet endpoint génère une vraie entité `Payment` tracée avec un historique.*
* **Body :** 
  ```json
  {
    "orderId": "string",
    "amount": 25.5
  }
  ```
* **Succès (200 OK) :** Retourne l'objet `Payment` créé.
* **Erreurs :**
  * `400 Bad Request` : Erreur Zod.
  * `500 Server Error` : "Order not found"
  * `500 Server Error` : "Payment amount exceeds remaining debt"

### `GET` /api/payments/order/{orderId}
Liste des paiements pour une commande spécifique.
* **Paramètres de chemin :** `orderId` (string)
* **Succès (200 OK) :** `Payment[]` (Historique des entrées d'argent pour la commande).
