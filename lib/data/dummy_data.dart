import '../models/property_model.dart';

final List<Property> dummyProperties = [
  Property(
    id: '1',
    name: 'Cozy Hotel',
    type: 'Hotel',
    location: 'Bandung',
    price: 600000,
    rating: 4.5,
    image: 'https://i0.wp.com/visit.kalteng.go.id/wp-content/uploads/2023/08/Luwansa.jpg?resize=1024%2C801&ssl=1',
    bedrooms: 2,
    bathrooms: 1,
    area: 45,
    reviewsCount: 12,
    description: 'A beautiful villa located near the beach with stunning sunset views.',
    gallery: [

    ],
    reviews: [
      {'user': 'John Doe', 'comment': 'Amazing place! Will come back.'},
      {'user': 'Jane Smith', 'comment': 'Very clean and beautiful view.'},
    ],
  ),
  Property(
    id: '2',
    name: 'Swing Hotel',
    type: 'Hotel',
    location: 'Lembang',
    price: 820000,
    rating: 4.8,
    image: 'https://images.trvl-media.com/lodging/10000000/9700000/9695700/9695675/2cbc4ea4.jpg?impolicy=resizecrop&rw=575&rh=575&ra=fill',
    bedrooms: 4,
    bathrooms: 3,
    area: 120,
    reviewsCount: 12,
    description: 'A beautiful villa located near the beach with stunning sunset views.',
    gallery: [

    ],
    reviews: [
      {'user': 'John Doe', 'comment': 'Amazing place! Will come back.'},
      {'user': 'Jane Smith', 'comment': 'Very clean and beautiful view.'},
    ],
  ),
  Property(
    id: '3',
    name: 'L Hotel',
    type: 'Hotel',
    location: 'Lembang',
    price: 450000,
    rating: 4.6,
    image: 'https://ik.imagekit.io/tvlk/apr-asset/Ixf4aptF5N2Qdfmh4fGGYhTN274kJXuNMkUAzpL5HuD9jzSxIGG5kZNhhHY-p7nw/hotel/asset/67818132-0fe4a69965f0f6ce71e5e304d4c3b066.jpeg?tr=q-80,c-at_max,w-740,h-500&_src=imagekit',
    bedrooms: 4,
    bathrooms: 3,
    area: 120,
    reviewsCount: 12,
    description: 'A beautiful villa located near the beach with stunning sunset views.',
    gallery: [

    ],
    reviews: [
      {'user': 'John Doe', 'comment': 'Amazing place! Will come back.'},
      {'user': 'Jane Smith', 'comment': 'Very clean and beautiful view.'},
    ],
  ),
  Property(
    id: '4',
    name: 'Model J Hotel',
    type: 'Hotel',
    location: 'Bandung',
    price: 600000,
    rating: 4.5,
    image: 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/634254798.jpg?k=61669224335693f03bec9a983cfee9b4a08fb44132c98dd037c063434f55ff54&o=&hp=1',
    bedrooms: 2,
    bathrooms: 1,
    area: 45,
    reviewsCount: 12,
    description: 'A beautiful villa located near the beach with stunning sunset views.',
    gallery: [

    ],
    reviews: [
      {'user': 'John Doe', 'comment': 'Amazing place! Will come back.'},
      {'user': 'Jane Smith', 'comment': 'Very clean and beautiful view.'},
    ],
  ),
  Property(
    id: '5',
    name: 'Regala Skycity',
    type: 'Apartment',
    location: 'Lembang',
    price: 1200000,
    rating: 4.8,
    image: 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/419574065.jpg?k=b92a4cd8818189ade50f546b7c3d286e9d99e3c4cbfbc1d24143a8f68f09fb78&o=&hp=1',
    bedrooms: 4,
    bathrooms: 3,
    area: 120,
    reviewsCount: 12,
    description: 'A beautiful villa located near the beach with stunning sunset views.',
    gallery: [

    ],
    reviews: [
      {'user': 'John Doe', 'comment': 'Amazing place! Will come back.'},
      {'user': 'Jane Smith', 'comment': 'Very clean and beautiful view.'},
    ],
  ),
  Property(
    id: '6',
    name: 'Luxury Villa',
    type: 'Villa',
    location: 'Lembang',
    price: 1900000,
    rating: 4.8,
    image: 'https://www.adriaticluxuryvillas.com/uploads/images/villa-di-polisane-zadar-dalmatia-1716977474706.jpg',
    bedrooms: 4,
    bathrooms: 3,
    area: 120,
    reviewsCount: 12,
    description: 'A beautiful villa located near the beach with stunning sunset views.',
    gallery: [

    ],
    reviews: [
      {'user': 'John Doe', 'comment': 'Amazing place! Will come back.'},
      {'user': 'Jane Smith', 'comment': 'Very clean and beautiful view.'},
    ],
  ),
  Property(
    id: '7',
    name: 'Namaskar Villa',
    type: 'Villa',
    location: 'Lembang',
    price: 1200000,
    rating: 4.8,
    image: 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/542522517.jpg?k=7b6a70b95eefaff8a2bd124c8b41720b4a6d8b60a773c09e3f83196960d5332c&o=&hp=1',
    bedrooms: 4,
    bathrooms: 3,
    area: 120,
    reviewsCount: 12,
    description: 'A beautiful villa located near the beach with stunning sunset views.',
    gallery: [

    ],
    reviews: [
      {'user': 'John Doe', 'comment': 'Amazing place! Will come back.'},
      {'user': 'Jane Smith', 'comment': 'Very clean and beautiful view.'},
    ],
  ),
  Property(
    id: '8',
    name: 'Bulgari Resort',
    type: 'Resort',
    location: 'Lembang',
    price: 1300000,
    rating: 4.8,
    image: 'https://miro.medium.com/v2/resize:fit:3840/1*csHi6jT1h7T3Xyqf4yowow.png',
    bedrooms: 4,
    bathrooms: 3,
    area: 120,
    reviewsCount: 12,
    description: 'A beautiful villa located near the beach with stunning sunset views.',
    gallery: [

    ],
    reviews: [
      {'user': 'John Doe', 'comment': 'Amazing place! Will come back.'},
      {'user': 'Jane Smith', 'comment': 'Very clean and beautiful view.'},
    ],
  ),

  // Optional: tambahkan lebih banyak data jika mau kategori lebih ramai
];
