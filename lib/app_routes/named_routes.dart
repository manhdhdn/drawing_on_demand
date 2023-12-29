///// App name
const String dod = "Drawing on demand - ";

///// Auth
class LoginRoute {
  static const String tag = '/login';
  static const String name = 'Login';
}

///// User

//// Home
class HomeRoute {
  static const String tag = '/';
  static const String name = 'Home';
}

/// Artwork
class ArtworkRoute {
  static const String tag = 'artwork';
  static const String name = 'Artwork';
}

// Artwork Detail
class ArtworkDetailRoute {
  static const String tag = 'detail/:id';
  static const String name = 'Artwork Detail';
}

/// Cart
class CartRoute {
  static const String tag = 'cart';
  static const String name = 'Cart';
}

// Checkout
class CheckoutRoute {
  static const String tag = 'checkout/:id';
  static const String name = 'Checkout';
}

//// Message
class MessageRoute {
  static const String tag = '/message';
  static const String name = 'Message';
}

/// Chat
class ChatRoute {
  static const String tag = ':id';
  static const String name = 'Chat';
}

//// Job
class JobRoute {
  static const String tag = '/job';
  static const String name = 'Job';
}

/// Job Detail
class JobDetailRoute {
  static const String tag = 'detail/:id';
  static const String name = 'Job Detail';
}

///
class JobCreateRoute {
  static const String tag = 'create';
  static const String name = 'Job Create';
}

//// Order
class OrderRoute {
  static const String tag = '/order';
  static const String name = 'Order';
}

/// Order Detail
class OrderDetailRoute {
  static const String tag = 'detail/:id';
  static const String name = 'Order Detail';
}

//// Profile
class ProfileRoute {
  static const String tag = '/profile';
  static const String name = 'Profile';
}

/// Setting
class SettingRoute {
  static const String tag = 'settings';
  static const String name = 'Settings';
}

// Language
class LanguageRoute {
  static const String tag = 'language';
  static const String name = 'Language';
}

/// Profile_Detail
class ProfileDetailRoute {
  static const String tag = 'detail';
  static const String name = 'Profile Detail';
}
