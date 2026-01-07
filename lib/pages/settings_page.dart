import 'package:flutter/material.dart';
import 'package:shoenew/pages/profile_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView.builder(
        itemCount: dummyStudents.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final student = dummyStudents[index];
          return ProfileCard(
            image: student.image,
            name: student.name,
            npm: student.npm,
          );
        },
      ),
    );
  }
}

class Student {
  final String name;
  final String npm;
  final String image;

  Student({required this.name, required this.npm, required this.image});
}

final List<Student> dummyStudents = [
  Student(name: 'Glenny Christo', npm: '19232544', image: 'lib/images/m1.jpg'),
  Student(
    name: 'Sifa Aulia Rahmah',
    npm: '19232349',
    image: 'lib/images/m2.jpeg',
  ),
  Student(name: 'Yanuar Fahri', npm: '19231133', image: 'lib/images/m3.jpeg'),
  Student(
    name: 'Ratih Ihdahayuningsih',
    npm: '19232492',
    image: 'lib/images/m4.jpeg',
  ),
  Student(
    name: 'Samuel Jason Rain',
    npm: '19232208',
    image: 'lib/images/m5.jpeg',
  ),
  Student(name: 'Hairun Adhari', npm: '19231404', image: 'lib/images/m6.jpeg'),
];
