import '../models/product_model.dart';

const List<ProductModel> dummyProducts = [
  ProductModel(
    id: '1',
    name: 'Casual T-Shirt',
    price: '\$25',
    image: 'assets/images/products/tshirt.png',
    category: 'Men',
    description: 'This casual t-shirt is designed with modern style and comfort. It is suitable for casual wear, daily use, and stylish outings. Experience the future of fashion today with premium materials and sleek aesthetics.',
  ),
  ProductModel(
    id: '2',
    name: 'Stylish Jacket',
    price: '\$60',
    image: 'assets/images/products/jacket.png',
    category: 'Men',
    description: 'This stylish jacket is designed with modern style and comfort. It is suitable for casual wear, daily use, and stylish outings. Experience the future of fashion today with premium materials and sleek aesthetics.',
  ),
  ProductModel(
    id: '3',
    name: 'Women Handbag',
    price: '\$40',
    image: 'assets/images/products/handbag.jpg',
    category: 'Bags',
    description: 'This women handbag is designed with modern style and comfort. It is suitable for casual wear, daily use, and stylish outings. Experience the future of fashion today with premium materials and sleek aesthetics.',
  ),
  ProductModel(
    id: '4',
    name: 'Sneakers',
    price: '\$55',
    image: 'assets/images/products/nike.jpg',
    category: 'Shoes',
    description: 'These sneakers are designed with modern style and comfort. It is suitable for casual wear, daily use, and stylish outings. Experience the future of fashion today with premium materials and sleek aesthetics.',
  ),
  ProductModel(
    id: '5',
    name: 'Denim Shirt',
    price: '\$35',
    image: 'assets/images/products/tshirt.png',
    category: 'Men',
    description: 'This denim shirt is designed with modern style and comfort. It is suitable for casual wear, daily use, and stylish outings. Experience the future of fashion today with premium materials and sleek aesthetics.',
  ),
  ProductModel(
    id: '6',
    name: 'Classic Watch',
    price: '\$80',
    image: 'assets/images/products/handbag.jpg',
    category: 'Accessories',
    description: 'This classic watch is designed with modern style and comfort. It is suitable for casual wear, daily use, and stylish outings. Experience the future of fashion today with premium materials and sleek aesthetics.',
  ),
];

const List<ProductModel> dummyFeaturedProducts = [
  dummyProducts[0],
  dummyProducts[1],
  dummyProducts[2],
  dummyProducts[3],
];
