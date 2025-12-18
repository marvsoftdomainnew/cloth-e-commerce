import 'package:cloth_e_commerce/roots/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;

  String _selectedCategory = 'All';
  bool _isScrolled = false;

  // Track wishlisted products
  final Set<int> _wishlistedProducts = {};

  final List<String> _categories = ['All', 'Men', 'Women', 'Kids'];
  final List<Map<String, dynamic>> _recentProducts = [
  {
    'id': 101,
    'image': 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=400',
    'name': 'Olive Green Shirt',
    'price': '₹499',
    'rating': 4.5,
  },
  {
    'id': 102,
    'image': 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400',
    'name': 'Black Hoodie',
    'price': '₹799',
    'rating': 4.8,
  },
  {
    'id': 103,
    'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
    'name': 'White T-Shirt',
    'price': '₹399',
    'rating': 4.3,
  },
  {
    'id': 104,
    'image': 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?w=400',
    'name': 'Blue Denim Jacket',
    'price': '₹1299',
    'rating': 4.7,
  },
];
final List<Map<String, dynamic>> _allProducts = [
  {
    'id': 201,
    'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
    'name': 'White T-Shirt',
    'price': '₹399',
    'rating': 4.3,
  },
  {
    'id': 202,
    'image': 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?w=400',
    'name': 'Blue Denim Jacket',
    'price': '₹1299',
    'rating': 4.7,
  },
  {
    'id': 203,
    'image': 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=400',
    'name': 'Olive Green Shirt',
    'price': '₹499',
    'rating': 4.5,
  },
  {
    'id': 204,
    'image': 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=400',
    'name': 'Black Hoodie',
    'price': '₹799',
    'rating': 4.8,
  },
];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  void _onScroll() {
    final bool scrolled = _scrollController.offset > 80;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  void _showWishlistPopup(Map<String, dynamic> product) {
    final int productId = product['id'];
        setState(() {
      if (_wishlistedProducts.contains(productId)) {
        _wishlistedProducts.remove(productId);
      } else {
        _wishlistedProducts.add(productId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isScrolled) _buildLogoHeader(),
                _buildCategoryChips(),
                _buildHeroBanner(),
                _buildPromoBanner(),
                _buildProductsGrid(),
                _buildAllProductsGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- APP BAR ----------------
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 1.5.h,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.bg(context),
      elevation: _isScrolled ? 4 : 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: AnimatedOpacity(
          opacity: _isScrolled ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.shopping_bag,
                  color: Colors.black,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'BEYOUNG',
                style: TextStyle(
                  color: AppColors.text(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: AppColors.text(context)),
          onPressed: () {
            Get.toNamed(AppRoutes.searchScreen);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: AppColors.text(context),
          ),
          onPressed: () {
            Get.toNamed(AppRoutes.notificationScreen);
          },
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.text(context),
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.cartScreen);
              },
            ),
            Positioned(
              right: 8,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '0',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildLogoHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.shopping_bag, color: Colors.black, size: 20.sp),
          ),
          SizedBox(width: 3.w),
          Text(
            'BEYOUNG',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- CATEGORY ----------------
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 8.h,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 30),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          physics: const BouncingScrollPhysics(),
          itemCount: _categories.length,
          itemBuilder: (context, i) {
            final category = _categories[i];
            final isSelected = category == _selectedCategory;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 12, top: 15),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------- HERO BANNER ----------------
  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=800',
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 30,
                right: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEW ARRIVALS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'The Most Trending Styles!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'SHOP NOW',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- PROMO ----------------
  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'NEW USERS',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FLAT 10% OFF',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Row(
                children: const [
                  Text('| USE CODE:', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 5),
                  Text(
                    'APP10',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- PRODUCTS ----------------
  Widget _buildProductsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recently Viewed',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 30.h,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _recentProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                itemBuilder: (context, index) =>
                    _buildProductCard(_recentProducts[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllProductsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Products',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context),
            ),
          ),
          GridView.builder(
            padding: EdgeInsets.only(top: 15),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.69,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: _allProducts.length,
            itemBuilder: (context, index) {
              return _buildAllProductCard(_allProducts[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final int productId = product['id'];
    final bool isWishlisted = _wishlistedProducts.contains(productId);

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.productDetailScreen);
      },
      child: Container(
        width: 43.w,
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    product['image'],
                    width: 44.w,
                    height: 16.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => _showWishlistPopup(product),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isWishlisted ? Colors.red : AppColors.icon(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${product['rating']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.text(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['price'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllProductCard(Map<String, dynamic> product) {
    final int productId = product['id'];
    final bool isWishlisted = _wishlistedProducts.contains(productId);

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.productDetailScreen);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    product['image'],
                    width: double.infinity,
                    height: 16.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      _showWishlistPopup(product);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isWishlisted ? Colors.red : AppColors.icon(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // ???
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,                   
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${product['rating']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.text(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['price'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}