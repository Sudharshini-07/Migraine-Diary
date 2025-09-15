import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'add_migraine_page.dart';

class MigraineLogPage extends StatefulWidget {
  const MigraineLogPage({super.key});

  @override
  _MigraineLogPageState createState() => _MigraineLogPageState();
}

class _MigraineLogPageState extends State<MigraineLogPage> {
  double _painLevel = 5;
  double _duration = 2;
  String? _selectedSymptom;
  String? _selectedTrigger;
  String? _selectedMedication;

  final List<String> _symptoms = ["Nausea", "Sensitivity to light", "Dizziness"];
  final List<String> _triggers = ["Stress", "Lack of Sleep", "Certain Foods"];
  final List<String> _medications = ["Paracetamol", "Ibuprofen", "Sumatriptan"];

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text("Migraine Log", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat.yMMMM().format(_focusedDay),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Text("No. of Attacks", style: TextStyle(fontSize: 16, color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 8),
              
              // Calendar Widget
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 4)],
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _showMigraineForm(selectedDay);
                  },
                  onPageChanged: (focusedDay) => setState(() => _focusedDay = focusedDay),
                  onFormatChanged: (format) => setState(() => _calendarFormat = format),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Log Section
              const Text(
                "Quick Log",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Pain Tracking Slider
              _buildSlider("Pain Tracking:", _painLevel, (value) {
                setState(() => _painLevel = value);
              }),

              // Dropdown Fields
              _buildDropdown("Symptoms:", _selectedSymptom, _symptoms, (newValue) {
                setState(() => _selectedSymptom = newValue);
              }),
              _buildDropdown("Trigger Factors:", _selectedTrigger, _triggers, (newValue) {
                setState(() => _selectedTrigger = newValue);
              }),
              _buildDropdown("Medication:", _selectedMedication, _medications, (newValue) {
                setState(() => _selectedMedication = newValue);
              }),

              // Duration Slider
              _buildSlider("Duration (hours):", _duration, (value) {
                setState(() => _duration = value);
              }),

              const SizedBox(height: 16),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveQuickLog();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Save Quick Log", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value,
                min: 0,
                max: 10,
                divisions: 10,
                activeColor: Colors.blue.shade600,
                inactiveColor: Colors.grey.shade400,
                onChanged: onChanged,
              ),
            ),
            Container(
              width: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 4)],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: const Text("Select an option"),
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade600),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(item),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showMigraineForm(DateTime selectedDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMigrainePage(
          initialDate: selectedDate,
        ),
      ),
    );
  }

  void _saveQuickLog() {
    final logData = {
      'date': DateTime.now(),
      'painLevel': _painLevel,
      'duration': _duration,
      'symptom': _selectedSymptom,
      'trigger': _selectedTrigger,
      'medication': _selectedMedication,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quick log saved!")),
    );

    print(logData); // For debugging
  }
}
