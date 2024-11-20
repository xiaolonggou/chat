import 'package:flutter/material.dart';
import 'chatters_model.dart'; // Chatter model

class EditChatterPage extends StatelessWidget {
  final Chatter chatter;

  const EditChatterPage({super.key, required this.chatter});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController(text: chatter.name);
    final TextEditingController genderController = TextEditingController(text: chatter.gender);
    final TextEditingController yearOfBirthController = TextEditingController(text: chatter.yearOfBirth.toString());
    final TextEditingController jobController = TextEditingController(text: chatter.job);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Chatter: ${chatter.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: genderController,
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              TextFormField(
                controller: yearOfBirthController,
                decoration: InputDecoration(labelText: 'Year of Birth'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: jobController,
                decoration: InputDecoration(labelText: 'Job'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Logic to save changes can go here, like updating the chatter data
                  // For now, it just prints the updated data
                  if (_formKey.currentState!.validate()) {
                    print('Updated Chatter: ${nameController.text}, ${genderController.text}, ${yearOfBirthController.text}, ${jobController.text}');
                    // You would typically save the changes to the repository or API here.
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
