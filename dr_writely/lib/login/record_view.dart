import 'package:flutter/material.dart';
import 'package:dr_writely/login/audio_recorder_page.dart';

class RecordView extends StatefulWidget {
  static String tag = 'record-page';

  const RecordView({super.key});

  @override
  _RecordViewState createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> with TickerProviderStateMixin {
  // Placeholder patient data (replace with Firebase data later)
  final List<Map<String, String>> patients = [
    {
      'patientName': 'John Doe',
      'appointmentNumber': 'AP123456',
      'diagnosisSummary': 'Patient shows signs of improvement. XYZ for 7 days.'
    },
    {
      'patientName': 'Jane Smith',
      'appointmentNumber': 'AP987654',
      'diagnosisSummary': 'Moderate fever, prescribed ABC medication.'
    },
    {
      'patientName': 'Michael Johnson',
      'appointmentNumber': 'AP654321',
      'diagnosisSummary': 'Chronic back pain, recommended physiotherapy.'
    },
    {
      'patientName': 'Emily Davis',
      'appointmentNumber': 'AP112233',
      'diagnosisSummary': 'Mild allergic reaction, prescribed antihistamines.'
    },
  ];

  // State to track the expansion of each card
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    // Initialize isExpandedList with false for all patients (collapsed state)
    isExpandedList = List.generate(patients.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF1A1A1A), // Darker gray background for consistency
      appBar: AppBar(
        title: const Text(
          'Patient Details',
          style: TextStyle(
            color: Colors.white, // White text for contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1C110A), // Dark background color
      ),
      body: Stack(
        children: [
          // Scrollable List of Cards
          Padding(
            padding: const EdgeInsets.only(
                bottom: 80.0), // Add padding to avoid overlap with button
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                final bool isExpanded = isExpandedList[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpandedList[index] =
                          !isExpandedList[index]; // Toggle expansion on tap
                    });
                  },
                  child: Card(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color: const Color(0xFF1C110A), // Darker card background
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Patient Name:',
                                      style: TextStyle(
                                        fontSize: 13.0, // Smaller font size
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Colors.white70, // Light gray text
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      patient['patientName']!,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // White text
                                      ),
                                    ),
                                    const SizedBox(height: 12.0),
                                    const Text(
                                      'Appointment Number:',
                                      style: TextStyle(
                                        fontSize: 13.0, // Smaller font size
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Colors.white70, // Light gray text
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      patient['appointmentNumber']!,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // White text
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Download started'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.download,
                                      size: 36.0), // Bigger icon size
                                  color: const Color(
                                      0xFF8AC4FF), // Blue icon color for consistency
                                ),
                              ],
                            ),
                            // Expandable diagnosis summary
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isExpanded
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Text(
                                        patient['diagnosisSummary']!,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color:
                                              Colors.white70, // Light gray text
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Fixed Record Button at the Bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity, // Full-width button
                height: 56, // Match height of the button
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AudioRecorderPage.tag);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF8AC4FF), // Light blue button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Record",
                    style: TextStyle(
                      color: Colors.white, // White text for contrast
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
