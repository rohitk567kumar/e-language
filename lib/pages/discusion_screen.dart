import 'package:e_language/constant/app-constant.dart';
import 'package:flutter/material.dart';

// Entry point of the application
// Forums Screen Widget
class DiscussionForumsScreen extends StatefulWidget {
  const DiscussionForumsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DiscussionForumsScreenState createState() => _DiscussionForumsScreenState();
}

class _DiscussionForumsScreenState extends State<DiscussionForumsScreen> {
  // Sample data for forums
  final List<ForumThread> threads = [
    ForumThread(
      userName: 'Alice',
      userAvatar: 'assets/1.jpg',
      title: 'Best Practices for Improving Speaking Skills',
      description:
          'Share your tips and resources for enhancing speaking abilities...',
      comments: 12,
      date: '2 hours ago',
    ),
    ForumThread(
      userName: 'Bob',
      userAvatar: 'assets/2.jpg',
      title: 'Understanding English Grammar',
      description: 'I find grammar challenging. Any advice or resources?',
      comments: 8,
      date: '1 day ago',
    ),
    ForumThread(
      userName: 'Charlie',
      userAvatar: 'assets/3.jpg',
      title: 'Vocabulary Building Techniques',
      description: 'What are the most effective ways to expand my vocabulary?',
      comments: 5,
      date: '3 days ago',
    ),
    // Add more threads as needed
  ];

  // Controller for the search bar
  final TextEditingController searchController = TextEditingController();

  // Function to handle search action
  void _searchThreads(String query) {
    // Implement search functionality here
    // For now, it just prints the query
    print('Searching for: $query');
  }

  // Function to navigate to the New Thread screen
  void _navigateToNewThread() {
    // Implement navigation to the new thread creation screen
    // For now, it just shows a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to New Thread Screen')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 5,
        title: Text(
          ("Discusion Forum").toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Open search bar
              showSearch(
                context: context,
                delegate: ForumSearchDelegate(threads: threads),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(getResponsiveSizeHieght(context, 0.015)),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: threads.length,
          itemBuilder: (context, index) {
            return ForumThreadCard(thread: threads[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewThread,
        backgroundColor: Colors.blue,
        tooltip: 'Create New Thread',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Model for a forum thread
class ForumThread {
  final String userName;
  final String userAvatar;
  final String title;
  final String description;
  final int comments;
  final String date;

  ForumThread({
    required this.userName,
    required this.userAvatar,
    required this.title,
    required this.description,
    required this.comments,
    required this.date,
  });
}

// Widget for displaying a single forum thread
class ForumThreadCard extends StatefulWidget {
  final ForumThread thread;

  const ForumThreadCard({super.key, required this.thread});

  @override
  State<ForumThreadCard> createState() => _ForumThreadCardState();
}

class _ForumThreadCardState extends State<ForumThreadCard> {
  bool isThumbClick = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(
          vertical: getResponsiveSizeHieght(context, 0.012)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(getResponsiveSizeHieght(context, 0.02)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(widget.thread.userAvatar),
                  radius: getResponsiveSizeHieght(context, 0.025),
                ),
                SizedBox(width: getResponsiveSizeWidh(context, 0.035)),
                Text(
                  widget.thread.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getResponsiveFontSize(context, 0.04),
                  ),
                ),
                const Spacer(),
                Text(
                  widget.thread.date,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: getResponsiveFontSize(context, 0.035),
                  ),
                ),
              ],
            ),
            SizedBox(height: getResponsiveSizeHieght(context, 0.015)),
            // Thread Title
            Text(
              widget.thread.title,
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, 0.05),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getResponsiveSizeHieght(context, 0.01)),
            // Thread Description
            Text(
              widget.thread.description,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: getResponsiveFontSize(context, 0.04),
              ),
            ),
            SizedBox(height: getResponsiveSizeHieght(context, 0.015)),
            // Comments and Interaction
            Row(
              children: [
                Icon(Icons.comment,
                    size: getResponsiveSizeHieght(context, 0.025),
                    color: Colors.grey.shade600),
                SizedBox(width: getResponsiveSizeWidh(context, 0.015)),
                Text(
                  '${widget.thread.comments} comments',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: getResponsiveFontSize(context, 0.035),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: isThumbClick
                      ? const Icon(Icons.thumb_up_alt_outlined)
                      : const Icon(
                          Icons.thumb_up,
                          color: Colors.blue,
                        ),
                  onPressed: () {
                    // Handle like action
                    setState(() {
                      isThumbClick = !isThumbClick;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {
                    // Handle share action
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Search Delegate for Forums
class ForumSearchDelegate extends SearchDelegate {
  final List<ForumThread> threads;

  ForumSearchDelegate({required this.threads});

  @override
  String get searchFieldLabel => 'Search Forums';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(fontSize: 16);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null), // Close the search
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = threads.where((thread) {
      return thread.title.toLowerCase().contains(query.toLowerCase()) ||
          thread.description.toLowerCase().contains(query.toLowerCase()) ||
          thread.userName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ForumThreadCard(thread: results[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = threads.where((thread) {
      return thread.title.toLowerCase().contains(query.toLowerCase()) ||
          thread.description.toLowerCase().contains(query.toLowerCase()) ||
          thread.userName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ForumThreadCard(thread: suggestions[index]);
      },
    );
  }
}
