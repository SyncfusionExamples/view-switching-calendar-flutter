import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScheduleExample();
}

List<String> colors = <String>[
  'Pink',
  'Blue',
  'Wall Brown',
  'Yellow',
  'Default'
];

List<String> views = <String>[
  'Day',
  'Week',
  'WorkWeek',
  'Month',
  'Timeline Day',
  'Timeline Week',
  'Timeline WorkWeek'
];

class ScheduleExample extends State<MyApp> {
  CalendarController _controller;
  DateTime _jumpToTime = DateTime.now();
  String _text = '';
  Color headerColor, viewHeaderColor, calendarColor, defaultColor;

  @override
  void initState() {
    _controller = CalendarController();
    _controller.view = CalendarView.week;
    _text = DateFormat('MMMM yyyy').format(_jumpToTime).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(Icons.color_lens),
              itemBuilder: (BuildContext context) {
                return colors.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              onSelected: (String value) {
                setState(() {
                  if (value == 'Pink') {
                    headerColor = const Color(0xFF09e8189);
                    viewHeaderColor = const Color(0xFF0f3acb6);
                    calendarColor = const Color(0xFF0ffe5d8);
                  } else if (value == 'Blue') {
                    headerColor = const Color(0xFF0007eff);
                    viewHeaderColor = const Color(0xFF03aa4f6);
                    calendarColor = const Color(0xFF0bae5ff);
                  } else if (value == 'Wall Brown') {
                    headerColor = const Color(0xFF0937c5d);
                    viewHeaderColor = const Color(0xFF0e6d9b1);
                    calendarColor = const Color(0xFF0d1d2d6);
                  } else if (value == 'Yellow') {
                    headerColor = const Color(0xFF0f7ed53);
                    viewHeaderColor = const Color(0xFF0fff77f);
                    calendarColor = const Color(0xFF0f7f2cc);
                  } else if (value == 'Default') {
                    headerColor = null;
                    viewHeaderColor = null;
                    calendarColor = null;
                  }
                });
              },
            ),
          ],
          backgroundColor: headerColor,
          centerTitle: true,
          titleSpacing: 60,
          title: Text(_text),
          leading: PopupMenuButton<String>(
            icon: Icon(Icons.calendar_today),
            itemBuilder: (BuildContext context) => views.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList(),
            onSelected: (String value) {
              setState(() {
                if (value == 'Day') {
                  _controller.view = CalendarView.day;
                } else if (value == 'Week') {
                  _controller.view = CalendarView.week;
                } else if (value == 'WorkWeek') {
                  _controller.view = CalendarView.workWeek;
                } else if (value == 'Month') {
                  _controller.view = CalendarView.month;
                } else if (value == 'Timeline Day') {
                  _controller.view = CalendarView.timelineDay;
                } else if (value == 'Timeline Week') {
                  _controller.view = CalendarView.timelineWeek;
                } else if (value == 'Timeline WorkWeek') {
                  _controller.view = CalendarView.timelineWorkWeek;
                }
              });
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SfCalendar(
                headerHeight: 0,
                viewHeaderStyle:
                    ViewHeaderStyle(backgroundColor: viewHeaderColor),
                backgroundColor: calendarColor,
                controller: _controller,
                initialDisplayDate: _jumpToTime,
                dataSource: getCalendarDataSource(),
                onTap: calendarTapped,
                monthViewSettings: MonthViewSettings(
                    navigationDirection: MonthNavigationDirection.vertical),
                onViewChanged: (ViewChangedDetails viewChangedDetails) {
                  String headerText;
                  if (_controller.view == CalendarView.month) {
                    headerText = DateFormat('MMMM yyyy')
                        .format(viewChangedDetails.visibleDates[
                            viewChangedDetails.visibleDates.length ~/ 2])
                        .toString();
                  } else {
                    headerText = DateFormat('MMMM yyyy')
                        .format(viewChangedDetails.visibleDates[0])
                        .toString();
                  }

                  if (headerText != null && headerText != _text) {
                    SchedulerBinding.instance
                        .addPostFrameCallback((Duration duration) {
                      _text = headerText;
                      setState(() {});
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
      _updateState(calendarTapDetails.date);
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
      _updateState(calendarTapDetails.date);
    }
  }

  void _updateState(DateTime date) {
    setState(() {
      _jumpToTime = date;
      _text = DateFormat('MMMM yyyy').format(_jumpToTime).toString();
    });
  }

  _DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      subject: 'Meeting',
      color: Colors.pink,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 4)),
      endTime: DateTime.now().add(const Duration(hours: 5)),
      subject: 'Release Meeting',
      color: Colors.lightBlueAccent,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 6)),
      endTime: DateTime.now().add(const Duration(hours: 7)),
      subject: 'Performance check',
      color: Colors.amber,
    ));
    appointments.add(Appointment(
      startTime: DateTime(2020, 1, 22, 1, 0, 0),
      endTime: DateTime(2020, 1, 22, 3, 0, 0),
      subject: 'Support',
      color: Colors.green,
    ));
    appointments.add(Appointment(
      startTime: DateTime(2020, 1, 24, 3, 0, 0),
      endTime: DateTime(2020, 1, 24, 4, 0, 0),
      subject: 'Retrospective',
      color: Colors.purple,
    ));

    return _DataSource(appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}
