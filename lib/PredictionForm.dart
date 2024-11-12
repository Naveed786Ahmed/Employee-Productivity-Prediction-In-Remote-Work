import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PredictionFormPage extends StatefulWidget {
  @override
  _PredictionFormPageState createState() => _PredictionFormPageState();
}

class _PredictionFormPageState extends State<PredictionFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool isProcessing = false;
  double? productivityScore;

  // Text Controllers for Input Fields
  final employeeIDController = TextEditingController();
  final workHoursController = TextEditingController();
  final expectedTasksController = TextEditingController();
  final tasksCompletedController = TextEditingController();
  final taskCompletionRateController = TextEditingController();
  final taskComplexityController = TextEditingController();
  final emailFrequencyController = TextEditingController();
  final meetingFrequencyController = TextEditingController();
  final breakDurationController = TextEditingController();
  final adjustedTaskCompletionController = TextEditingController();

  // Function to calculate productivity score based on input values
  void _calculateProductivity() {
    setState(() {
      isProcessing = true;
    });

    // Simulate a delay for processing
    Future.delayed(Duration(seconds: 4), () {

      setState(() {
        int workHours = int.parse(workHoursController.text);
        int expectedTasks = int.parse(expectedTasksController.text);
        int tasksCompleted = int.parse(tasksCompletedController.text);
        double taskCompletionRate = tasksCompleted / expectedTasks; 
        int taskComplexity = int.parse(taskComplexityController.text);
        double adjustedTaskCompletion = taskCompletionRate * taskComplexity; 
        int emailFrequency = int.parse(emailFrequencyController.text);
        int meetingFrequency = int.parse(meetingFrequencyController.text);
        double breakDuration = double.parse(breakDurationController.text);

        // Calculate productivity score
        productivityScore = (workHours * 0.2) +
            (adjustedTaskCompletion * 0.4) +
            ((emailFrequency + meetingFrequency) * 0.3) -
            (breakDuration * 0.1);

        isProcessing = false;
      });
    });
  }

  // Function to get the performance message based on productivity score
  String _getPerformanceMessage(double score) {
    if (score > 16 && score < 20) {
      return "Excellent productivity!";
    } else if (score > 11 && score < 15) {
      return "Good productivity!";
    } else if (score > 6 && score < 10) {
      return "Average productivity. Consider improving!";
    } else {
      return "Low productivity. Please review your tasks!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prediction Form',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF1A237E),
        centerTitle: true,
      ),
      body: isProcessing ? _buildProcessingView() : _buildFormView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: isProcessing ? 1 : 0,
        backgroundColor: Color(0xFF1A237E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Form',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Prediction',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            setState(() {
              isProcessing = false;
            });
          } else {
            if (_formKey.currentState!.validate()) {
              _calculateProductivity();
            }
          }
        },
      ),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (productivityScore == null) ...[
            CircularProgressIndicator(
              color: Color(0xFF7E57C2), 
            ),
            SizedBox(height: 20),
            Text(
              'Processing Prediction...',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.trending_up,
                    color: Color(0xFF1A237E),
                    size: 40,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Productivity Score',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7E57C2),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    productivityScore!.toStringAsFixed(2),
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    _getPerformanceMessage(productivityScore!),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7E57C2),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildInputField('Employee ID', employeeIDController,
                icon: Icons.person),
            _buildInputField('Work Hours (35-55)', workHoursController,
                min: 35, max: 55, icon: Icons.access_time),
            _buildInputField('Expected Tasks (10-15)', expectedTasksController,
                min: 10, max: 15, icon: Icons.task),
            _buildInputField('Tasks Completed (6-15)', tasksCompletedController,
                min: 6, max: 15, icon: Icons.check_circle),
            _buildInputField('Task Complexity (1-3)', taskComplexityController,
                min: 1, max: 3, icon: Icons.dashboard),
            _buildInputField(
                'Email Frequency (10-30)', emailFrequencyController,
                min: 10, max: 30, icon: Icons.email),
            _buildInputField(
                'Meeting Frequency (2-8)', meetingFrequencyController,
                min: 2, max: 8, icon: Icons.group),
            _buildInputField('Break Duration', breakDurationController,
                isFloat: true, icon: Icons.pause),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _calculateProductivity();
                }
              },
              child: Text(
                'Submit',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A237E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {double? min,
      double? max,
      bool isFloat = false,
      required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isFloat
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon:
              Icon(icon, color: Color(0xFF1A237E)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          double? numValue = double.tryParse(value);
          if (numValue == null) {
            return 'Enter a valid number';
          }
          if (min != null && numValue < min) {
            return 'Must be at least $min';
          }
          if (max != null && numValue > max) {
            return 'Must be at most $max';
          }
          return null;
        },
      ),
    );
  }
}
