import 'package:flutter/material.dart';
import 'package:safe_bite/themes.dart';

class EditInfoDialog extends StatefulWidget {
  final String currentInfo;
  final Function(String) onInfoChanged;
  final String dialogTitle;
  final String labelText;

  const EditInfoDialog({super.key, 
    required this.currentInfo,
    required this.onInfoChanged,
    required this.dialogTitle,
    required this.labelText,
  });

  @override
  State<EditInfoDialog> createState() => _EditInfoDialogState();
}

class _EditInfoDialogState extends State<EditInfoDialog> {
  late TextEditingController _infoController;

  @override
  void initState() {
    super.initState();
    _infoController = TextEditingController(text: widget.currentInfo);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: customBackgroundColor,
      title: Text(widget.dialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _infoController,
            decoration: InputDecoration(
              labelText: widget.labelText,
              border:const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
              ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: TextStyle(color: Colors.red),),
        ),
        TextButton(
          onPressed: () {
            widget.onInfoChanged(_infoController.text);
            Navigator.pop(context);
          },
          child: Text("Confirm"),
        ),
      ],
    );
  }
}

class EditName extends StatefulWidget {

  final String currFirstName;
  final String currSurname;
  final Function(String, String) onNameChanged;

  const EditName({super.key, required this.currFirstName, required this.currSurname, required this.onNameChanged});

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  late TextEditingController _namecontroller;
  late TextEditingController _surnamecontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _namecontroller = TextEditingController(text: widget.currFirstName);
    _surnamecontroller =  TextEditingController(text: widget.currSurname);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: customBackgroundColor,
      title: Text("Edit Name"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _namecontroller,
            decoration: const InputDecoration(
              labelText: "Enter your name",
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
          const SizedBox(height: 15,),
          TextField(
            controller: _surnamecontroller,
            decoration:const InputDecoration(
              labelText: "Enter your surname",
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: TextStyle(color: Colors.red),),
        ),
        TextButton(
          onPressed: () {
            // widget.onInfoChanged(_infoController.text);
            widget.onNameChanged(_namecontroller.text, _surnamecontroller.text);
            Navigator.pop(context);
          },
          child: Text("Confirm"),
        ),
      ],
    );
  }
}

class AddAllergiesDialog extends StatefulWidget {
  final List<dynamic> allergies;
  final Function(List<dynamic>) onAllergiesUpdated;

  const AddAllergiesDialog({ required this.allergies, required this.onAllergiesUpdated, super.key});

  @override
  State<AddAllergiesDialog> createState() => _AddAllergiesDialogState();
}

class _AddAllergiesDialogState extends State<AddAllergiesDialog> {
  List<dynamic> commonAllergens = ['Peanuts','Milk','Eggs','Wheat','Soy'];
  List<dynamic> selectedAllergens = [];

  @override
  void initState() {
    super.initState();
    commonAllergens = commonAllergens.where((allergen) => !widget.allergies.contains(allergen)).toList();
    selectedAllergens = widget.allergies;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:const Text("Select Allergens"),
      content: SingleChildScrollView(
        child: Column(
          children: commonAllergens.map((allergen){
            bool isSelected = selectedAllergens.contains(allergen);
            return ListTile(
              title: Text(allergen),
              trailing: isSelected ? const Icon(Icons.check_box, color: Colors.blue,) : const Icon(Icons.check_box_outline_blank_outlined, color: Colors.blue,),
              onTap: (){
                setState(() {
                  if(isSelected){
                    selectedAllergens.remove(allergen);
                  } else {
                    selectedAllergens.add(allergen);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child:const Text("Cancel", style: TextStyle(color: Colors.red),)),
        TextButton(onPressed: (){
          widget.onAllergiesUpdated(selectedAllergens);
          Navigator.of(context).pop();
        }, child:const Text("Confirm"))
      ],
    );
  }
}

class AddDietaryPrefDialog extends StatefulWidget {
  final List<dynamic> prefs;
  final Function(List<dynamic>) onprefsUpdated;
  const AddDietaryPrefDialog({required this.prefs, required this.onprefsUpdated, super.key});

  @override
  State<AddDietaryPrefDialog> createState() => _AddDietaryPrefDialogState();
}

class _AddDietaryPrefDialogState extends State<AddDietaryPrefDialog> {
  List<dynamic> commonPrefs = ['Vegetarian','Vegan','Gluten-free','Low-carb','Paleo'];
  List<dynamic> selectedPrefs = [];

  @override
  void initState() {
    super.initState();
    commonPrefs = commonPrefs.where((element) => !widget.prefs.contains(element)).toList();
    selectedPrefs = widget.prefs;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:const Text("Select Dietary Pref."),
      content: SingleChildScrollView(
        child: Column(
          children: commonPrefs.map((allergen){
            bool isSelected = selectedPrefs.contains(allergen);
            return ListTile(
              title: Text(allergen),
              trailing: isSelected ? const Icon(Icons.check_box, color: Colors.blue,) : const Icon(Icons.check_box_outline_blank_outlined, color: Colors.blue,),
              onTap: (){
                setState(() {
                  if(isSelected){
                    selectedPrefs.remove(allergen);
                  } else {
                    selectedPrefs.add(allergen);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child:const Text("Cancel", style: TextStyle(color: Colors.red),)),
        TextButton(onPressed: (){
          widget.onprefsUpdated(selectedPrefs);
          Navigator.of(context).pop();
        }, child:const Text("Confirm"))
      ],
    );
  }
}