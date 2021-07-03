import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/services/api_services/event_services/event_services.dart';
import 'package:secondhand_sharing/utils/validator/validator.dart';
import 'package:secondhand_sharing/widgets/icons/app_icons.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  int _groupId;

  var _eventNameController = TextEditingController();
  var _startDateController = TextEditingController();
  var _endDateController = TextEditingController();
  var _contentController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  DateTime _startDate;
  DateTime _endDate;
  DateFormat _dateFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _groupId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).createEvent,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: [
            TextFormField(
              validator: Validator.validateEventName,
              controller: _eventNameController,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                  labelText: S.of(context).eventName,
                  filled: true,
                  fillColor: Theme.of(context).backgroundColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: Validator.validateStartDate,
              onTap: () {
                showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2200))
                    .then((value) {
                  if (value != null)
                    setState(() {
                      _startDate = value;
                      _startDateController.text = _dateFormat.format(value);
                    });
                });
              },
              controller: _startDateController,
              readOnly: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                  labelText: S.of(context).startDate,
                  filled: true,
                  fillColor: Theme.of(context).backgroundColor,
                  suffixIcon: Icon(AppIcons.calendar),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: Validator.validateEndDate,
              controller: _endDateController,
              readOnly: true,
              onTap: () {
                showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2200))
                    .then((value) {
                  if (value != null)
                    setState(() {
                      _endDate = value;
                      _endDateController.text = _dateFormat.format(value);
                    });
                });
              },
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                  labelText: S.of(context).endDate,
                  filled: true,
                  fillColor: Theme.of(context).backgroundColor,
                  suffixIcon: Icon(AppIcons.calendar),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              minLines: 8,
              maxLines: 20,
              validator: Validator.validateContent,
              controller: _contentController,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                  hintText: "${S.of(context).content}...",
                  filled: true,
                  fillColor: Theme.of(context).backgroundColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState.validate()) return;
                  EventForm eventForm = EventForm(
                      eventName: _eventNameController.text,
                      startDate: _startDate,
                      endDate: _endDate,
                      content: _contentController.text,
                      groupId: _groupId);
                  EventServices.createEvent(eventForm).then((value) {
                    if (value != null) {
                      Navigator.pop(context, value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).eventPosted),
                        ),
                      );
                    }
                  });
                },
                child: Text(S.of(context).create))
          ],
        ),
      ),
    );
  }
}
