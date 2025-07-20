import 'package:flutter/material.dart';
import '../data/shoe_data.dart';
import '../models/shoe_model.dart';
import '../widgets/shoe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> brands = const ['All', 'Adidas', 'Nike', 'Puma', 'Reebok','Hummel'];
  String selectedBrand = 'All';

  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  final List<String> bannerImages = const [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];

  // Animation flags
  bool _showBanner = false;
  bool _showBrands = false;
  bool _showFilter = false;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();

    // Delay each part to create staggered animation
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _showBanner = true);
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _showBrands = true);
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() => _showFilter = true);
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() => _showContent = true);
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    final List<ShoeModel> filteredShoes = selectedBrand == 'All'
        ? shoeList
        : shoeList.where((shoe) => shoe.brand == selectedBrand).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Logo & Brand
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo2.png',
                      height: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SNEAKPEAK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Search Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Any Shoe Here',
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Banner Carousel with animation
              AnimatedSlide(
                offset: _showBanner ? Offset.zero : const Offset(0, 0.2),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: _showBanner ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: SizedBox(
                    height: 220,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: PageView.builder(
                                controller: _bannerController,
                                itemCount: bannerImages.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentBannerIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Image.asset(
                                    bannerImages[index],
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            bannerImages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width:
                                  _currentBannerIndex == index ? 20 : 8,
                              decoration: BoxDecoration(
                                color: _currentBannerIndex == index
                                    ? primaryColor
                                    : Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ✅ Popular Brands with animation
              AnimatedSlide(
                offset: _showBrands ? Offset.zero : const Offset(0, 0.2),
                duration: const Duration(milliseconds: 600),
                child: AnimatedOpacity(
                  opacity: _showBrands ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Popular Brands',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ✅ Filter Brand with animation
              AnimatedSlide(
                offset: _showFilter ? Offset.zero : const Offset(0, 0.2),
                duration: const Duration(milliseconds: 600),
                child: AnimatedOpacity(
                  opacity: _showFilter ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: brands.length,
                        itemBuilder: (context, index) {
                          final brand = brands[index];
                          final isSelected = brand == selectedBrand;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => selectedBrand = brand),
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryColor
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                brand,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ✅ Grid Produk with animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AnimatedSlide(
                  offset: _showContent ? Offset.zero : const Offset(0, 0.2),
                  duration: const Duration(milliseconds: 600),
                  child: AnimatedOpacity(
                    opacity: _showContent ? 1 : 0,
                    duration: const Duration(milliseconds: 600),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: GridView.count(
                        key: ValueKey<String>(selectedBrand),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                        physics: const NeverScrollableScrollPhysics(),
                        children: filteredShoes
                            .map((shoe) => ShoeCard(shoe: shoe))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
