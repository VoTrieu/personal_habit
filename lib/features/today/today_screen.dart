import 'package:flutter/material.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today'),
      ),
      body: ListView(
        children:  const [
          ListTile(
            leading: Icon(Icons.menu_book, color: Colors.green),
            title: Text('Read 20 pages of a book'),
            subtitle: Text('3 day streak'),
            trailing: Icon(Icons.check_circle_outline, color: Colors.green)
          ),
          ListTile(
            leading: Icon(Icons.water_drop, color: Colors.green),
            title: Text('Drink 8 glasses of water'),
            subtitle: Text('5 day streak'),
            trailing: Icon(Icons.check_circle_outline, color: Colors.green)
          ),
          ListTile(
            leading: Icon(Icons.directions_walk, color: Colors.green),
            title: Text('Go for a walk'),
            subtitle: Text('2 day streak'),
            trailing: Icon(Icons.check_circle_outline, color: Colors.green) 
          ),
        ],
      ),
    );
  }
}