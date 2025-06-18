import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villanakey/components/bottom_bar.dart';
import 'package:villanakey/components/skeleton_loader.dart';
import 'package:villanakey/components/decorated_box_container.dart';
import 'package:villanakey/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // Simulasi loading data
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _launchMap() async {
    const url = 'https://maps.app.goo.gl/9mDXt5skcUyDMjoy8';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SkeletonLoader();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero section
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/Hero.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const Text(
                'Selamat Datang di Villa Na Key',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 6,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ],
          ),

          Column(
            children: [
              DecoratedBoxContainer(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "VillaNaKey terletak di kaki Gunung Burangrang, Cihanjawar Bojong, Purwakarta. Tempat yang sempurna untuk menikmati udara segar dan pemandangan alam yang asri, cocok untuk liburan santai dan melepas penat.",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/about.jpg',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              DecoratedBoxContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/villa_main.jpg',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Villa Na Key',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Rp. 1,500,000',
                                  style: TextStyle(
                                    color: Color(0xFF42754C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: '/day',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                                color: Color(0xFF42754C),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Cihanjawar Bojong, Purwakarta',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 21,
                                color: Color(0xFF42754C),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '081909333132',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFacilityIcon(Icons.group, "10 orang"),
                              _buildFacilityIcon(Icons.bed, "4 Kasur"),
                              _buildFacilityIcon(Icons.bathroom, "2 Toilet"),
                              _buildFacilityIcon(Icons.pool, "1 Kolam"),
                              _buildFacilityIcon(Icons.wifi, "WiFi"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Overview",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120,
                      child: PageView.builder(
                        itemCount: 6,
                        controller: PageController(viewportFraction: 0.8),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/villa_$index.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 14,
                        bottom: 16,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              final isLoggedIn =
                                  Provider.of<UserProvider>(
                                    context,
                                    listen: false,
                                  ).isLoggedIn;

                              if (!isLoggedIn) {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text(
                                          'Harap Login Dahulu',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                              255,
                                              43,
                                              75,
                                              49,
                                            ),
                                          ),
                                        ),
                                        content: const Text(
                                          'Silakan login terlebih dahulu untuk melakukan Reservasi.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Tutup',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                context,
                                                '/login',
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF819766,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text(
                                              'Login',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const CustomBottomBar(
                                          initialIndex: 1,
                                        ),
                                  ),
                                );
                              }
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF42754C),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14.0,
                                horizontal: 20.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text("Booking"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              DecoratedBoxContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Lokasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _launchMap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/location.png',
                            width: double.infinity,
                            height: 175,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityIcon(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFEADECE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }
}
