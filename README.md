# Foodier

Welcome to **Foodier**, a dual-app Swift project designed to create an engaging food ordering experience for customers and restaurants alike.

## Apps Overview
Foodier consists of two separate apps:
- **[Foodier!](Foodier!/)**: A seamless and personalized food ordering experience for customers.
- **[Foodier! Restaurant](Foodier!%20Restaurant/)**: A comprehensive restaurant management platform for handling orders, menus, and customer requests.

---

## Features Overview

### Foodier!
The **[Foodier!](Foodier!/)** app enables customers to explore a variety of dishes and restaurants, with options to save favorites, manage orders, and customize their experience.

#### Key Screens
1. **Splash Screen**: Welcomes users with a vibrant introduction.
2. **Sign Up & Sign In**: Easy registration and login process.
3. **HomeView**: 
   - Explore available restaurants and items.
   - Search for items and filter by food type.
   - View item details and add items to favorites or cart.
   - Place orders directly from the app.
4. **Location Selection**: Customize orders based on location preferences.
5. **Cart**:
   - View and manage current orders.
   - Option to cancel orders.
6. **Favorites**: Access saved favorite items.
7. **Profile**:
   - Sign out or delete account.

#### Screenshots

<div align="center">
    <img src="Photos/22splash_screen1.jpg" alt="Splash Screen 1" width="200"/>
    <img src="Photos/23splash_screen2.jpg" alt="Splash Screen 2" width="200"/>
    <img src="Photos/24splash_screen3.jpg" alt="Splash Screen 3" width="200"/>
    <img src="Photos/25splash_screen4.jpg" alt="Splash Screen 4" width="200"/>
    <p><em>Figure 1: Splash Screen</em></p>
</div>

<div align="center">
    <img src="Photos/26signin.jpg" alt="Sign In 1" width="200"/>
    <img src="Photos/28signin2.jpg" alt="Sign In 2" width="200"/>
    <img src="Photos/27signup.jpg" alt="Sign Up" width="200"/>
    <p><em>Figure 2: Sign In & Sign Up</em></p>
</div>

<div align="center">
    <img src="Photos/29availableitems.jpg" alt="Available Items" width="200"/>
    <img src="Photos/32availableitems2.jpg" alt="Available Items" width="200"/>
    <img src="Photos/33availableitems3.jpg" alt="Available Items" width="200"/>
    <img src="Photos/34availableitems4.jpg" alt="Available Items" width="200"/>
    <img src="Photos/35availableitems5.jpg" alt="Available Items" width="200"/>
    <img src="Photos/42availableitems6.jpg" alt="Available Items" width="200"/>
    <p><em>Figure 3: HomeView</em></p>
</div>

<div align="center">
    <img src="Photos/30locations.jpg" alt="Item View" width="200"/>
    <img src="Photos/31locations2.jpg" alt="Item View" width="200"/>
    <p><em>Figure 4: LocationView</em></p>
</div>

<div align="center">
    <img src="Photos/36itemview.jpg" alt="Item View" width="200"/>
    <img src="Photos/37itemview2.jpg" alt="Item View" width="200"/>
    <img src="Photos/38itemview3.jpg" alt="Item View" width="200"/>
    <img src="Photos/43itemview4.jpg" alt="Item View" width="200"/>
    <p><em>Figure 5: ItemView</em></p>
</div>

<div align="center">
    <img src="Photos/39myorders.jpg" alt="My Orders" width="200"/>
    <img src="Photos/44myorders2.jpg" alt="My Orders" width="200"/>
    <img src="Photos/45myorders3.jpg" alt="My Orders" width="200"/>
    <img src="Photos/46myorders4.jpg" alt="My Orders" width="200"/>
    <p><em>Figure 6: MyOrderView</em></p>
</div>

<div align="center">
    <img src="Photos/40myfavouriteitems.jpg" alt="Favorite Items" width="200"/>
    <p><em>Figure 7: FavouriteView</em></p>
</div>

<div align="center">
    <img src="Photos/41profiles.jpg" alt="Profile View" width="200"/>
    <p><em>Figure 8: ProfileView</em></p>
</div>

---

### Foodier! Restaurant
The **[Foodier! Restaurant](Foodier!%20Restaurant/)** app allows restaurant owners to manage orders, update menus, and oversee kitchen operations efficiently.

#### Key Screens
1. **Sign In & Sign Up**: Secure access to the restaurant management platform.
2. **HomeView**:
   - Display available restaurants and menu items.
   - Search for items, filter by food type, and view item details.
3. **Add ItemView**: Easily add new menu items.
4. **Order Queue View**:
   - Manage orders by status: New, Processing, On the Way, and Delivered.
5. **My Kitchen**:
   - View available items, update profiles, and log out.

#### Screenshots

<div align="center">
    <img src="Photos/1signin.jpg" alt="Sign In" width="200"/>
    <img src="Photos/2signup.jpg" alt="Sign Up" width="200"/>
    <img src="Photos/3signup2.jpg" alt="Sign Up" width="200"/>
    <p><em>Figure 1: Sign In & Sign Up</em></p>
</div>

<div align="center">
    <img src="Photos/4home.jpg" alt="Home View" width="200"/>
    <img src="Photos/12home2.jpg" alt="Home View" width="200"/>
    <img src="Photos/13home3.jpg" alt="Home View" width="200"/>
    <img src="Photos/14home4.jpg" alt="Home View" width="200"/>
    <p><em>Figure 2: HomeView</em></p>
</div>

<div align="center">
    <img src="Photos/5additem.jpg" alt="Add Item" width="200"/>
    <img src="Photos/6additem2.jpg" alt="Add Item" width="200"/>
    <img src="Photos/7additem3.jpg" alt="Add Item" width="200"/>
    <p><em>Figure 3: AddItemView</em></p>
</div>

<div align="center">
    <img src="Photos/17myorder.jpg" alt="My Orders" width="200"/>
    <img src="Photos/18myorder2.jpg" alt="My Orders" width="200"/>
    <img src="Photos/19myorder3.jpg" alt="My Orders" width="200"/>
    <img src="Photos/20myorder4.jpg" alt="My Orders" width="200"/>
    <img src="Photos/21myorder5.jpg" alt="My Orders" width="200"/>
    <p><em>Figure 4: MyOrderView</em></p>
</div>

<div align="center">
    <img src="Photos/9mykitchen.jpg" alt="My Kitchen" width="200"/>
    <!-- <img src="Photos/15mykitchen2.jpg" alt="My Kitchen" width="200"/> -->
    <p><em>Figure 5: MyKitchenView</em></p>
</div>

<div align="center">
    <img src="Photos/16profile.jpg" alt="Profile View" width="200"/>
    <p><em>Figure 6: ProfileView</em></p>
</div>

---

## Tech Stack

- **Language**: Swift
- **Platform**: iOS
- **Database**: Firebase

### Firebase Integration

Foodier utilizes **Firebase** to seamlessly manage and synchronize data across both applications:

- **Firebase Storage**: Stores all images, including menu items, restaurant profiles, and user avatars.
- **Cloud Firestore**: Serves as the primary database for storing structured text data such as restaurant information, menu details, order histories, and user preferences.
- **Firebase Authentication**: Manages user authentication, allowing secure sign-in and sign-up processes for both customers and restaurants.

Both **Foodier!** and **Foodier! Restaurant** are connected to the same Firebase database, enabling real-time data sharing and updates between the customer and restaurant applications.

#### Screenshots

<div align="center">
    <img src="Photos/47Firebase.jpg" alt="Firebase Overview" width="800"/>
    <img src="Photos/48firebaseauthentication.jpg" alt="Firebase Authentication" width="800"/>
    <img src="Photos/49storages.jpg" alt="Firebase Storage" width="800"/>
    <img src="Photos/50storages.jpg" alt="Firebase Storage" width="800"/>
    <!-- <img src="Photos/51firestore.jpg" alt="Cloud Firestore" width="800"/> -->
    <img src="Photos/52firestore.jpg" alt="Cloud Firestore" width="800"/>
    <img src="Photos/53firestore.jpg" alt="Cloud Firestore" width="800"/>
    <img src="Photos/54firestore.jpg" alt="Cloud Firestore" width="800"/>
    <img src="Photos/55firestore.jpg" alt="Cloud Firestore" width="800"/>
    <img src="Photos/56firestore.jpg" alt="Cloud Firestore" width="800"/>
    <p><em>Figure 1: Firebase Integration</em></p>
</div>

---


## Installation

To get started with Foodier:

1. Clone the repository:
```bash
   git clone https://github.com/MachangDoniel/Foodier.git
```
2. Open the project in Xcode.
3. Build and run each app on the iOS simulator or a physical device.

## Contributions

Contributions are welcome! If you have suggestions for improving Foodier, please open an issue or submit a pull request.
## License

This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details.
## Contact

For any inquiries, please contact [donieltripura1971@gmail.com](mailto:donieltripura1971@gmail.com)
