import 'package:e_language/constant/app-constant.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 5,
        title: Text(
          ("Leaderboard").toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(getResponsiveSizeHieght(context, 0.02)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: getResponsiveSizeHieght(context, 0.025)),

            // Title and Description
            Text(
              "Top Performers",
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, 0.057),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getResponsiveSizeHieght(context, 0.02)),
            Text(
              "See how you stack up against the best!",
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, 0.047),
                color: Colors.grey,
              ),
            ),
            SizedBox(height: getResponsiveSizeHieght(context, 0.025)),

            // Leaderboard List
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: leaderboardData.length,
                itemBuilder: (context, index) {
                  return LeaderboardItem(
                    rank: index + 1,
                    name: leaderboardData[index]["name"],
                    points: leaderboardData[index]["points"],
                    isCurrentUser: leaderboardData[index]["isCurrentUser"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Leaderboard Item Widget
class LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final bool isCurrentUser;

  const LeaderboardItem({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCurrentUser ? Colors.blue.shade50 : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(
          vertical: getResponsiveSizeHieght(context, 0.012)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: rank == 1
              ? Colors.amber
              : rank == 2
                  ? Colors.grey
                  : rank == 3
                      ? Colors.brown
                      : Colors.blueGrey,
          child: Text(
            rank.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isCurrentUser ? Colors.blue : Colors.black,
          ),
        ),
        trailing: Text(
          "$points score",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

// Mock Data for Leaderboard
final List<Map<String, dynamic>> leaderboardData = [
  {"name": "Rohait Kumar", "points": 1500, "isCurrentUser": true},
  {"name": "Jawed Hussain", "points": 1480, "isCurrentUser": false},
  {"name": "Mohatshim Shaikh", "points": 1400, "isCurrentUser": false},
  {"name": "Aisha Rizwan", "points": 1350, "isCurrentUser": false},
  {"name": "Bibi Amna", "points": 1320, "isCurrentUser": false},
  {"name": "Awais", "points": 1300, "isCurrentUser": false},
];
