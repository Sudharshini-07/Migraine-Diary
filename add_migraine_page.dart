import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:intl/intl.dart';

class AddMigrainePage extends StatefulWidget {
  final DateTime? initialDate;

  const AddMigrainePage({
    super.key,
    this.initialDate,
  });

  @override
  State<AddMigrainePage> createState() => _AddMigrainePageState();
}

class _AddMigrainePageState extends State<AddMigrainePage> {
  int _currentQuestionIndex = 0;
  late DateTime _attackDate;
  TimeOfDay _attackTime = TimeOfDay.now();
  String? _painDuration;
  String? _painSide;
  String? _painArea;
  String? _painSeverity;
  final Map<String, bool> _selectedSymptoms = {
    'Anxiety': false,
    'Aura': false,
    'Blurred Vision': false,
    'Confusion': false,
    'Concentrating difficulty': false,
    'Craving': false,
    'Depressed mood': false,
  };
  final Map<String, bool> _selectedTriggers = {
    'Alcohol': false,
    'Allergy': false,
    'Anxiety': false,
    'Bright light': false,
    'Caffeine': false,
    'Cold': false,
    'Dehydration': false,
  };
  final Map<String, bool> _selectedMedications = {
    'Acetaminophen': false,
    'Aimovig': false,
    'Diclofenac': false,
    'Ibuprofen': false,
    'Maxalt': false,
    'Naproxen': false,
    'Paracetamol': false,
  };
  final Map<String, bool> _selectedReliefMethods = {
    'Caffeine': false,
    'Cold shower': false,
    'Dark room rest': false,
    'Drink water': false,
    'Heat pad': false,
    'Hot shower': false,
  };
  final TextEditingController _notesController = TextEditingController();

  final List<Map<String, dynamic>> _questions = [
    {
      'title': 'What time did the attack start?',
      'widget': (BuildContext context, _AddMigrainePageState state) => state._buildTimeQuestion(),
    },
    {
      'title': 'How long did the pain last?',
      'widget': (BuildContext context, _AddMigrainePageState state) => state._buildPainDurationQuestion(),
    },
    {
      'title': 'Where does it hurt?',
      'widget': (BuildContext context, _AddMigrainePageState state) => state._buildPainLocationQuestion(),
    },
    {
      'title': 'How painful is the attack?',
      'widget': (BuildContext context, _AddMigrainePageState state) => state._buildPainSeverityQuestion(),
    },
    {
      'title': 'What are your symptoms?',
      'widget': (BuildContext context, _AddMigrainePageState state) => state._buildSymptomsQuestion(),
    },
    {
      'title': 'Can you guess what could have triggered attack?',
      'widget': (BuildContext context, _AddMigrainePageState state) => state._buildTriggersQuestion(),
    },
    {
      'title': 'Which acute medications did you take?',
      'widget': (BuildContext context, _AddMigrainePageState state) => state._buildMedicationsQuestion(),
    },
    {
      'title': 'Which relief methods have you tried?',
      'widget': (BuildContext context, _AddMigrainePageState state) => state._buildReliefMethodsQuestion(),
    },
    {
      'title': 'Write additional notes if necessary',
      'widget': (BuildContext context, _AddMigrainePageState state) => state._buildAdditionalNotesQuestion(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _attackDate = widget.initialDate ?? DateTime.now();
    _attackTime = TimeOfDay.fromDateTime(_attackDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Migraine Log'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _questions[_currentQuestionIndex]['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _questions[_currentQuestionIndex]['widget'](context, this),
                ],
              ),
            ),
          ),
          _buildPageIndicator(),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentQuestionIndex > 0)
                  TextButton(
                    onPressed: () => setState(() => _currentQuestionIndex--),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 18,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 48),
                ElevatedButton(
                  onPressed: () {
                    if (_currentQuestionIndex < _questions.length - 1) {
                      setState(() => _currentQuestionIndex++);
                    } else {
                      _saveAttack();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    _currentQuestionIndex == _questions.length - 1 ? 'Save' : 'Next',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_questions.length, (index) {
          return Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentQuestionIndex == index 
                  ? Colors.blue.shade600 
                  : Colors.grey.shade400,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTimeQuestion() {
    return Column(
      children: [
        // iOS-style time picker
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: Duration(
              hours: _attackTime.hour,
              minutes: _attackTime.minute,
            ),
            onTimerDurationChanged: (Duration newTime) {
              setState(() {
                _attackTime = TimeOfDay(
                  hour: newTime.inHours % 24,
                  minute: newTime.inMinutes % 60,
                );
                _attackDate = DateTime(
                  _attackDate.year,
                  _attackDate.month,
                  _attackDate.day,
                  _attackTime.hour,
                  _attackTime.minute,
                );
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        // Selected time display
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'Selected Time: ${_attackTime.format(context)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // Keep all other question widgets the same as before
  Widget _buildPainDurationQuestion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          RadioListTile(
            title: const Text('I don\'t know'),
            value: 'unknown',
            groupValue: _painDuration,
            onChanged: (value) => setState(() => _painDuration = value.toString()),
            activeColor: Colors.blue.shade600,
          ),
          const Divider(),
          RadioListTile(
            title: const Text('Less than 1 hour'),
            value: '<1h',
            groupValue: _painDuration,
            onChanged: (value) => setState(() => _painDuration = value.toString()),
            activeColor: Colors.blue.shade600,
          ),
          const Divider(),
          RadioListTile(
            title: const Text('1-4 hours'),
            value: '1-4h',
            groupValue: _painDuration,
            onChanged: (value) => setState(() => _painDuration = value.toString()),
            activeColor: Colors.blue.shade600,
          ),
          const Divider(),
          RadioListTile(
            title: const Text('4-12 hours'),
            value: '4-12h',
            groupValue: _painDuration,
            onChanged: (value) => setState(() => _painDuration = value.toString()),
            activeColor: Colors.blue.shade600,
          ),
          const Divider(),
          RadioListTile(
            title: const Text('12+ hours'),
            value: '12+h',
            groupValue: _painDuration,
            onChanged: (value) => setState(() => _painDuration = value.toString()),
            activeColor: Colors.blue.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildPainLocationQuestion() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                'Side',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLocationButton('LEFT', isSide: true),
                  _buildLocationButton('RIGHT', isSide: true),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                'Area',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLocationButton('FRONT', isSide: false),
                  _buildLocationButton('BACK', isSide: false),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationButton(String text, {required bool isSide}) {
    final isSelected = isSide ? _painSide == text : _painArea == text;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          if (isSide) {
            _painSide = isSelected ? null : text;
          } else {
            _painArea = isSelected ? null : text;
          }
        });
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: isSelected ? Colors.blue.shade600 : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
        backgroundColor: isSelected ? Colors.blue.shade100 : Colors.white,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: isSelected ? Colors.blue.shade600 : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPainSeverityQuestion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          RadioListTile(
            title: const Text('MILD'),
            subtitle: const Text('I can keep up daily business'),
            value: 'mild',
            groupValue: _painSeverity,
            onChanged: (value) => setState(() => _painSeverity = value.toString()),
            activeColor: Colors.blue.shade600,
          ),
          const Divider(),
          RadioListTile(
            title: const Text('MODERATE'),
            subtitle: const Text('I can function but with difficulty'),
            value: 'moderate',
            groupValue: _painSeverity,
            onChanged: (value) => setState(() => _painSeverity = value.toString()),
            activeColor: Colors.blue.shade600,
          ),
          const Divider(),
          RadioListTile(
            title: const Text('SEVERE'),
            subtitle: const Text('I can\'t do anything'),
            value: 'severe',
            groupValue: _painSeverity,
            onChanged: (value) => setState(() => _painSeverity = value.toString()),
            activeColor: Colors.blue.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsQuestion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: _selectedSymptoms.keys.map((symptom) {
          return Column(
            children: [
              CheckboxListTile(
                title: Text(symptom),
                value: _selectedSymptoms[symptom],
                onChanged: (value) {
                  setState(() {
                    _selectedSymptoms[symptom] = value!;
                  });
                },
                activeColor: Colors.blue.shade600,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (symptom != _selectedSymptoms.keys.last) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTriggersQuestion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: _selectedTriggers.keys.map((trigger) {
          return Column(
            children: [
              CheckboxListTile(
                title: Text(trigger),
                value: _selectedTriggers[trigger],
                onChanged: (value) {
                  setState(() {
                    _selectedTriggers[trigger] = value!;
                  });
                },
                activeColor: Colors.blue.shade600,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (trigger != _selectedTriggers.keys.last) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMedicationsQuestion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'POPULAR MEDICATIONS',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Column(
            children: _selectedMedications.keys.map((medication) {
              return Column(
                children: [
                  CheckboxListTile(
                    title: Text(medication),
                    value: _selectedMedications[medication],
                    onChanged: (value) {
                      setState(() {
                        _selectedMedications[medication] = value!;
                      });
                    },
                    activeColor: Colors.blue.shade600,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  if (medication != _selectedMedications.keys.last) const Divider(),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReliefMethodsQuestion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: _selectedReliefMethods.keys.map((method) {
          return Column(
            children: [
              CheckboxListTile(
                title: Text(method),
                value: _selectedReliefMethods[method],
                onChanged: (value) {
                  setState(() {
                    _selectedReliefMethods[method] = value!;
                  });
                },
                activeColor: Colors.blue.shade600,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (method != _selectedReliefMethods.keys.last) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdditionalNotesQuestion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _notesController,
        decoration: const InputDecoration(
          hintText: 'For example, medication didn\'t help...',
          border: InputBorder.none,
        ),
        maxLines: 8,
      ),
    );
  }

  void _saveAttack() {
    final attackData = {
      'date': _attackDate,
      'time': _attackTime.format(context),
      'duration': _painDuration,
      'side': _painSide,
      'area': _painArea,
      'severity': _painSeverity,
      'symptoms': _selectedSymptoms.entries.where((e) => e.value).map((e) => e.key).toList(),
      'triggers': _selectedTriggers.entries.where((e) => e.value).map((e) => e.key).toList(),
      'medications': _selectedMedications.entries.where((e) => e.value).map((e) => e.key).toList(),
      'reliefMethods': _selectedReliefMethods.entries.where((e) => e.value).map((e) => e.key).toList(),
      'notes': _notesController.text,
    };

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Migraine attack logged successfully!')),
    );

    print(attackData); // For debugging
  }
}
