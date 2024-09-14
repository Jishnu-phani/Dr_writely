import 'package:flutter/material.dart';

class PatientView extends StatefulWidget {
  static String tag = 'patient-page';

  const PatientView({super.key});

  @override
  _PatientViewState createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  // Placeholder patient data (replace with Firebase data later)
  final List<Map<String, String>> patients = [
    {
      'appointmentNumber': 'AP123456',
      'summary': 'Patient shows signs of improvement.',
      'medications': 'XYZ for 7 days'
    },
    {
      'appointmentNumber': 'AP987654',
      'summary': 'Moderate fever.',
      'medications': 'ABC medication'
    },
    {
      'appointmentNumber': 'AP654321',
      'summary': 'Chronic back pain.',
      'medications': 'Recommended physiotherapy'
    },
    {
      'appointmentNumber': 'AP112233',
      'summary': 'Mild allergic reaction.',
      'medications': 'Prescribed antihistamines'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF1A1A1A), // Dark gray background for consistency
      appBar: AppBar(
        title: const Text(
          'Patient Summary',
          style: TextStyle(
            color: Colors.white, // White text for contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1C110A), // Dark background color
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];

          return Card(
            elevation: 6.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            color: const Color(0xFF1C110A), // Dark card background
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Appointment Number:',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70, // Lighter text color for label
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    patient['appointmentNumber']!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text for contrast
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Summary:',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70, // Lighter text color for label
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    patient['summary']!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white, // White text
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Medications:',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70, // Lighter text color for label
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    patient['medications']!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white, // White text
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
