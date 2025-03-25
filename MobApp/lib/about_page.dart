// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AboutPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("About"),
//       ),
//       body: ListView(
//         children: <Widget>[
//           // App Information Section
//           ListTile(
//             leading: Icon(Icons.info),
//             title: Text('App Name'),
//             subtitle: Text('Penny Pincher'),
//           ),
//           ListTile(
//             leading: Icon(Icons.update),
//             title: Text('Version'),
//             subtitle: Text('1.0.0'),
//           ),
//           // Navigate to Developers Page
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text('Developers'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => DevelopersPage()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DeveloperInfo {
//   final String name;
//   final String role;
//   final String imagePath;
//   final String location;
//   final Map<String, String> socialLinks;
//   final String? bio;

//   DeveloperInfo({
//     required this.name,
//     required this.role,
//     required this.imagePath,
//     required this.location,
//     required this.socialLinks,
//     this.bio,
//   });
// }

// class DevelopersPage extends StatelessWidget {
//   DevelopersPage({Key? key}) : super(key: key);

//   // Spotify theme colors
//   final Color spotifyBackground = const Color(0xFF121212);
//   final Color spotifyCardBackground = const Color(0xFF181818);
//   final Color spotifyHighlight = const Color(0xFF1DB954);
//   final Color spotifySecondary = const Color(0xFFB3B3B3);

//   final List<DeveloperInfo> developers = [
//     DeveloperInfo(
//       name: 'Soham Soni',
//       role: 'Flutter Developer, AI/ML Practitioner',
//       imagePath: 'assets/s.jpg',
//       location: 'Vadodara, Gujarat, India',
//       socialLinks: {
//         'GitHub': 'https://github.com/Soham2212004',
//         'LinkedIn': 'https://in.linkedin.com/in/soham-soni-2342b4239',
//         'Instagram': 'https://www.instagram.com/_soham_soni_/',
//       },
//       bio: 'Flutter developer with passion for creating beautiful, functional mobile applications. Also interested in AI/ML technologies and their integration with mobile apps.',
//     ),
//     DeveloperInfo(
//       name: 'Anushka Mukherjee',
//       role: 'UI/UX Designer, Front-End & Backend Developer',
//       imagePath: 'assets/anu.jpg',
//       location: 'Vadodara, Gujarat, India',
//       socialLinks: {
//         'GitHub': 'https://github.com/anushkea',
//         'LinkedIn': 'https://in.linkedin.com/in/anushkea',
//         'Instagram': 'https://www.instagram.com/anushkeaa/?__pwa=1',
//       },
//       bio: 'Passionate about creating user-centric designs and implementing them with clean code. Experienced in full-stack development with a focus on user experience.',
//     ),
//   ];

//   void _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: spotifyBackground,
//       appBar: AppBar(
//         title: Text(
//           'Developers',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             letterSpacing: -0.2,
//           ),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFF212121), spotifyBackground],
//             stops: [0.0, 0.3],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20),
//                 Text(
//                   'Meet the Team',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'The awesome people behind this app',
//                   style: TextStyle(
//                     color: spotifySecondary,
//                     fontSize: 16,
//                   ),
//                 ),
//                 SizedBox(height: 32),
//                 Expanded(
//                   child: Row(
//                     children: developers.map((developer) => 
//                       Expanded(
//                         child: _buildDeveloperCard(context, developer),
//                       )
//                     ).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDeveloperCard(BuildContext context, DeveloperInfo developer) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: () => _showDeveloperBio(context, developer),
//             child: Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.3),
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: ClipOval(
//                     child: Image.asset(
//                       developer.imagePath,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: spotifyHighlight,
//                   ),
//                   child: Icon(
//                     Icons.info_outline,
//                     color: Colors.black,
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16),
//           Text(
//             developer.name,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               letterSpacing: -0.2,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 6),
//           Text(
//             developer.role,
//             style: TextStyle(
//               color: spotifySecondary,
//               fontSize: 14,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.location_on,
//                 color: spotifySecondary,
//                 size: 16,
//               ),
//               SizedBox(width: 4),
//               Flexible(
//                 child: Text(
//                   developer.location,
//                   style: TextStyle(
//                     color: spotifySecondary,
//                     fontSize: 13,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           _buildSocialLinks(developer),
//         ],
//       ),
//     );
//   }

//   Widget _buildSocialLinks(DeveloperInfo developer) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         if (developer.socialLinks.containsKey('GitHub'))
//           _buildSocialIcon(
//             'GitHub',
//             Image.asset(
//               'assets/github.png',
//               width: 18,
//               height: 18,
//               color: spotifySecondary,
//             ),
//             developer.socialLinks['GitHub']!,
//           ),
//         SizedBox(width: 12),
//         if (developer.socialLinks.containsKey('LinkedIn'))
//           _buildSocialIcon(
//             'LinkedIn',
//             Image.asset(
//               'assets/linkedin.png',
//               width: 18,
//               height: 18,
//               color: spotifySecondary,
//             ),
//             developer.socialLinks['LinkedIn']!,
//           ),
//         SizedBox(width: 12),
//         if (developer.socialLinks.containsKey('Instagram'))
//           _buildSocialIcon(
//             'Instagram',
//             Image.asset(
//               'assets/instagram.png',
//               width: 18,
//               height: 18,
//               color: spotifySecondary,
//             ),
//             developer.socialLinks['Instagram']!,
//           ),
//       ],
//     );
//   }

//   Widget _buildSocialIcon(String name, Widget icon, String url) {
//     return InkWell(
//       onTap: () => _launchURL(url),
//       borderRadius: BorderRadius.circular(20),
//       child: Container(
//         width: 36,
//         height: 36,
//         decoration: BoxDecoration(
//           color: spotifyCardBackground,
//           shape: BoxShape.circle,
//         ),
//         child: Center(child: icon),
//       ),
//     );
//   }

//   void _showDeveloperBio(BuildContext context, DeveloperInfo developer) {
//     final RenderBox box = context.findRenderObject() as RenderBox;
//     final position = box.localToGlobal(Offset.zero);
    
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           insetPadding: EdgeInsets.zero,
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             constraints: BoxConstraints(maxWidth: 320),
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: spotifyCardBackground,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.5),
//                   blurRadius: 15,
//                   offset: Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 4,
//                   width: 40,
//                   margin: EdgeInsets.only(top: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white24,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           ClipOval(
//                             child: Image.asset(
//                               developer.imagePath,
//                               width: 60,
//                               height: 60,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   developer.name,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   developer.role,
//                                   style: TextStyle(
//                                     color: spotifySecondary,
//                                     fontSize: 13,
//                                   ),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         'Bio',
//                         style: TextStyle(
//                           color: spotifyHighlight,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         developer.bio ?? 'No bio available.',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           height: 1.5,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         'Location',
//                         style: TextStyle(
//                           color: spotifyHighlight,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on,
//                             color: spotifySecondary,
//                             size: 16,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             developer.location,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: spotifyHighlight,
//                               foregroundColor: Colors.black,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                             ),
//                             child: Text(
//                               'Close',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:finaces_tracker/dark_light_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {

  final Color spotifyBackground = const Color(0xFF121212);
  final Color spotifyCardBackground = const Color(0xFF181818);
  final Color spotifyHighlight = const Color(0xFF1DB954);
  final Color spotifySecondary = const Color(0xFFB3B3B3);
  final Color spotifyText = Colors.white;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = true;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: spotifyText,
          ),
        ),
        backgroundColor: spotifyBackground,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), spotifyBackground],
            stops: [0.0, 0.3],
          ),
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            // App Information Section
            ListTile(
              leading: Icon(Icons.money, color: spotifyHighlight, size: 28),
              title: Text('App Name', 
                style: TextStyle(color: spotifyText, fontSize: 18, fontWeight: FontWeight.w600)),
              subtitle: Text('Penny Pincher', 
                style: TextStyle(color: spotifySecondary, fontSize: 16)),
            ),
            ListTile(
              leading: Icon(Icons.update, color: spotifyHighlight, size: 28),
              title: Text('Version', 
                style: TextStyle(color: spotifyText, fontSize: 18, fontWeight: FontWeight.w600)),
              subtitle: Text('1.0.0', 
                style: TextStyle(color: spotifySecondary, fontSize: 16)),
            ),
            // Navigate to Developers Page
            ListTile(
              leading: Icon(Icons.person, color: spotifyHighlight, size: 28),
              title: Text('Developers', 
                style: TextStyle(color: spotifyText, fontSize: 18, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DevelopersPage()),
                );
              },
              trailing: Icon(Icons.chevron_right, color: spotifySecondary),
            ),
            Divider(color: spotifyCardBackground, thickness: 1.5, height: 30),
            ListTile(
              leading: Icon(Icons.contact_support, color: spotifyHighlight, size: 28),
              title: Text('Contact Us', 
                style: TextStyle(color: spotifyText, fontSize: 18, fontWeight: FontWeight.w600)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: spotifyCardBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Contact Us',
                              style: TextStyle(
                                color: spotifyText,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildContactItem('Soham Soni', 'sonisoham91@gmail.com'),
                            SizedBox(height: 10),
                            _buildContactItem('Anushka Mukherjee', 'anushkamukherjee1027@gmail.com'),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: spotifyHighlight,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              ),
                              child: Text(
                                'Close',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              trailing: Icon(Icons.chevron_right, color: spotifySecondary),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip, color: spotifyHighlight, size: 28),
              title: Text('Privacy Policy', 
                style: TextStyle(color: spotifyText, fontSize: 18, fontWeight: FontWeight.w600)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: spotifyCardBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: spotifyText,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Penny Pincher respects your privacy and is committed to protecting your personal data. We collect only necessary information to provide you with the best possible experience.',
                              style: TextStyle(
                                color: spotifySecondary,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'All data is stored locally on your device and is not shared with third parties. We do not collect any personal identification information.',
                              style: TextStyle(
                                color: spotifySecondary,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              '© 2025 Penny Pincher. All rights reserved by Soham Soni & Anushka Mukherjee.',
                              style: TextStyle(
                                color: spotifyHighlight,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: spotifyHighlight,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              ),
                              child: Text(
                                'Close',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              trailing: Icon(Icons.chevron_right, color: spotifySecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(String name, String email) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF282828),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.email, color: spotifyHighlight, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: spotifyText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    color: spotifySecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeveloperInfo {
  final String name;
  final String role;
  final String imagePath;
  final String location;
  final Map<String, String> socialLinks;
  final String? bio;

  DeveloperInfo({
    required this.name,
    required this.role,
    required this.imagePath,
    required this.location,
    required this.socialLinks,
    this.bio,
  });
}

class DevelopersPage extends StatelessWidget {
  DevelopersPage({Key? key}) : super(key: key);

  // Spotify theme colors
  final Color spotifyBackground = const Color(0xFF121212);
  final Color spotifyCardBackground = const Color(0xFF181818);
  final Color spotifyHighlight = const Color(0xFF1DB954);
  final Color spotifySecondary = const Color(0xFFB3B3B3);

  final List<DeveloperInfo> developers = [
    DeveloperInfo(
      name: 'Soham Soni',
      role: 'Flutter Developer, AI/ML Practitioner,Cloud Computing Expert',
      imagePath: 'assets/s.jpg',
      location: 'Vadodara, Gujarat, India',
      socialLinks: {
        'GitHub': 'https://github.com/Soham2212004',
        'LinkedIn': 'https://in.linkedin.com/in/soham-soni-2342b4239',
        'Instagram': 'https://www.instagram.com/_soham_soni_/',
      },
      bio: 'Passionate Flutter Developer, Cloud Computing Enthusiast, and Machine Learning Practitioner, with expertise in Google Cloud and Oracle Generative AI. Experienced in building AI-powered applications using TensorFlow Lite, YOLO, and Gemini API. Skilled in developing secure, scalable, and efficient Flutter applications with real-time features and advanced AI integration.',
    ),
    DeveloperInfo(
      name: 'Anushka Mukherjee',
      role: 'MERN Stack Developer, Cloud Computing Expert, UI/UX Designer',
      imagePath: 'assets/anu.jpg',
      location: 'Vadodara, Gujarat, India',
      socialLinks: {
        'GitHub': 'https://github.com/anushkea',
        'LinkedIn': 'https://in.linkedin.com/in/anushkea',
        'Instagram': 'https://www.instagram.com/anushkeaa/?__pwa=1',
      },
      bio: 'Passionate about cloud computing and full-stack development, specializing in the MERN stack. Experienced in building scalable applications with a strong focus on user experience. Proficient in UI/UX design principles and skilled in using Figma to create intuitive interfaces. Dedicated to writing clean, efficient code and crafting seamless digital experiences.',
    ),
  ];

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always use Spotify dark theme for consistency
    bool isDarkMode = true;

    return Scaffold(
      backgroundColor: spotifyBackground,
      appBar: AppBar(
        title: Text(
          'Developers',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
        backgroundColor: spotifyBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: spotifyHighlight),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), spotifyBackground],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Meet the Team',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The awesome people behind this app',
                  style: TextStyle(
                    color: spotifySecondary,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 32),
                Expanded(
                  child: Row(
                    children: developers.map((developer) => 
                      Expanded(
                        child: _buildDeveloperCard(context, developer, isDarkMode),
                      )
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloperCard(BuildContext context, DeveloperInfo developer, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showDeveloperBio(context, developer, isDarkMode),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      developer.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: spotifyHighlight,
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            developer.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            developer.role,
            style: TextStyle(
              color: spotifySecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: spotifySecondary,
                size: 16,
              ),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  developer.location,
                  style: TextStyle(
                    color: spotifySecondary,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildSocialLinks(developer, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSocialLinks(DeveloperInfo developer, bool isDarkMode) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (developer.socialLinks.containsKey('GitHub'))
        _buildSocialIcon(
          'GitHub',
          Image.asset(
            'assets/github.png',
            width: 18,
            height: 18,
            color: Colors.white, // Changed to white for better visibility
          ),
          developer.socialLinks['GitHub']!,
        ),
      SizedBox(width: 12),
      if (developer.socialLinks.containsKey('LinkedIn'))
        _buildSocialIcon(
          'LinkedIn',
          Image.asset(
            'assets/linkedin2.png',
            width: 20, // Slightly larger
            height: 20, // Slightly larger
            color: Colors.white, // Changed to white for better visibility
          ),
          developer.socialLinks['LinkedIn']!,
        ),
      SizedBox(width: 12),
      if (developer.socialLinks.containsKey('Instagram'))
        _buildSocialIcon(
          'Instagram',
          Image.asset(
            'assets/instagram3.png',
            width: 20, // Slightly larger
            height: 20, // Slightly larger
            color: Colors.white, // Changed to white for better visibility
          ),
          developer.socialLinks['Instagram']!,
        ),
    ],
  );
}

Widget _buildSocialIcon(String name, Widget icon, String url) {
  return InkWell(
    onTap: () => _launchURL(url),
    borderRadius: BorderRadius.circular(20),
    child: Container(
      width: 40, // Slightly larger container
      height: 40, // Slightly larger container
      decoration: BoxDecoration(
        color: Color(0xFF282828),
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFF333333), width: 1), // Added subtle border
      ),
      child: Center(child: icon),
    ),
  );
}

  void _showDeveloperBio(BuildContext context, DeveloperInfo developer, bool isDarkMode) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: spotifyCardBackground,
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: BoxConstraints(maxWidth: 320),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: spotifyCardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              developer.imagePath,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  developer.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  developer.role,
                                  style: TextStyle(
                                    color: spotifySecondary,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Bio',
                        style: TextStyle(
                          color: spotifyHighlight,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        developer.bio ?? 'No bio available.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Location',
                        style: TextStyle(
                          color: spotifyHighlight,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: spotifySecondary,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            developer.location,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: spotifyHighlight,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}