import 'package:flutter/material.dart';

class LifestylePage extends StatelessWidget {
  const LifestylePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: Text("Lifestyle Tracker"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sleep Tracker
            _buildTrackerCard(
              title: "Sleep Quality",
              icon: Icons.bedtime,
              value: "7.2/10",
              onPressed: () => _showSleepDetails(context),
            ),
            
            SizedBox(height: 16),
            
            // Water Intake
            _buildTrackerCard(
              title: "Water Intake",
              icon: Icons.water_drop,
              value: "5/8 glasses",
              onPressed: () => _showWaterDetails(context),
            ),
            
            SizedBox(height: 16),
            
            // Stress Level
            _buildTrackerCard(
              title: "Stress Level",
              icon: Icons.mood,
              value: "Medium",
              onPressed: () => _showStressDetails(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackerCard({
    required String title,
    required IconData icon,
    required String value,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue.shade600, size: 32),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(value, style: TextStyle(color: Colors.blue.shade800)),
              ],
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showSleepDetails(BuildContext context) {
    // Implement detailed sleep tracking
  }

  void _showWaterDetails(BuildContext context) {
    // Implement water intake details
  }

  void _showStressDetails(BuildContext context) {
    // Implement stress level details
  }
}
