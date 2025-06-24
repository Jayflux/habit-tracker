import 'package:flutter/material.dart';

class OurTeamPage extends StatelessWidget {
  const OurTeamPage({Key? key}) : super(key: key);

  final List<TeamMember> members = const [
    TeamMember(
      name: 'Rayssa Modelline .J.S',
      id: '2310511151',
      imagePath: 'assets/rayssa.png',
    ),
    TeamMember(
      name: 'Muhamad Najwan',
      id: '2310511149',
      imagePath: 'assets/muhamad.png',
    ),
    TeamMember(
      name: 'Abdul Faris Aufar',
      id: '2310511154',
      imagePath: 'assets/abdul.png',
    ),
    TeamMember(
      name: 'Daniel Hemas .M.S',
      id: '2310511162',
      imagePath: 'assets/daniel.jpg',
    ),
    TeamMember(
      name: 'Aqiel Syafiq Rahman',
      id: '2310511139',
      imagePath: 'assets/aqiel.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Color(0xFF174E8F)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'OUR TEAM',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'This Is Our Team.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: members.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          SquareTile(imagePath: member.imagePath),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  member.id,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String id;
  final String imagePath;

  const TeamMember({
    required this.name,
    required this.id,
    required this.imagePath,
  });
}

class SquareTile extends StatelessWidget {
  final String imagePath;

  const SquareTile({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }
}
