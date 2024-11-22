import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chatters_model.dart';
import 'chatters_controller.dart';
import '../../shared/utils/utils.dart'; // Import the utils.dart file

class EditChatterPage extends StatefulWidget {
  final Chatter? chatter; // Nullable to handle both add and edit

  EditChatterPage({required this.chatter});

  @override
  _EditChatterPageState createState() => _EditChatterPageState();
}

class _EditChatterPageState extends State<EditChatterPage> {
  late TextEditingController _nameController;
  late TextEditingController _yearOfBirthController;
  late TextEditingController _jobController;
  late TextEditingController _personalityController;
  String? _selectedGender; // Store the selected gender

  final List<String> _genders = ['Male', 'Female', 'Unknown', 'Other']; // Gender options

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.chatter?.name ?? '');
    _yearOfBirthController = TextEditingController(text: widget.chatter?.yearOfBirth.toString() ?? '2000');
    _jobController = TextEditingController(text: widget.chatter?.job ?? 'Unknown');
    _personalityController = TextEditingController(text: widget.chatter?.personality ?? 'Neutral');
    _selectedGender = widget.chatter?.gender ?? 'Unknown'; // Initialize the gender field
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearOfBirthController.dispose();
    _jobController.dispose();
    _personalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the utility function to get the hint text for Personality
    String personalityHint = getPersonalityHintText(_personalityController.text);

    return Scaffold(
      appBar: AppBar(title: Text(widget.chatter == null ? 'Add Chatter' : 'Edit Chatter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            // Gender dropdown
            DropdownButtonFormField<String>(
              value: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
              decoration: InputDecoration(labelText: 'Gender'),
              items: _genders.map((gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
            ),
            // Year of birth input field
            TextField(
              controller: _yearOfBirthController,
              decoration: InputDecoration(labelText: 'Year of Birth'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _jobController,
              decoration: InputDecoration(labelText: 'Job'),
            ),
            // Personality field
            TextField(
              controller: _personalityController,
              decoration: InputDecoration(labelText: 'Personality'),
            ),
            // Show hint if Personality is empty
            if (personalityHint.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  personalityHint,
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Create a new or updated chatter object
                final updatedChatter = Chatter(
                  id: widget.chatter?.id ?? DateTime.now().toString(), // Use the existing id if editing, otherwise generate a new one
                  name: _nameController.text,
                  gender: _selectedGender ?? 'Unknown', // Use selected gender
                  yearOfBirth: int.tryParse(_yearOfBirthController.text) ?? 2000,
                  job: _jobController.text,
                  personality: _personalityController.text,
                );

                // Call the controller to save the changes
                Provider.of<ChattersController>(context, listen: false).addOrUpdateChatter(updatedChatter);

                // Go back to the previous page (ChattersPage)
                Navigator.pop(context);
              },
              child: Text(widget.chatter == null ? 'Add Chatter' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
