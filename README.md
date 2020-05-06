# Switching between the event calendar views in Flutter
In flutter event calendar, you can navigate between the calendar views using the view property of Calendar and in this article, switching between event calendar view has been achieved using the PopupMenuButton and OnTap callback of the calendar.

**Step 1:** In initState(), set the default values such as view and header text for Scaffold widget appBar.

```dart
CalendarView _calendarView;
DateTime _jumpToTime = DateTime.now();
String _text = '';

@override
void initState() {
  _calendarView = CalendarView.week;
  _text = DateFormat('MMMM yyyy').format(_jumpToTime).toString();
  super.initState();
}
```

**Step 2:** Place the event calendar to the body of the Scaffold widget. Get the visible date values from onViewChanged callback and set the values to appBar data.   

```dart
body: Column(
  children: <Widget>[
    Expanded(
      child: SfCalendar(
        headerHeight: 0,
        viewHeaderStyle:
            ViewHeaderStyle(backgroundColor: viewHeaderColor),
        backgroundColor: calendarColor,
        view: _calendarView,
        initialDisplayDate: _jumpToTime,
        dataSource: getCalendarDataSource(),
        onTap: calendarTapped,
        onViewChanged: (ViewChangedDetails viewChangedDetails) {
          String headerText;
          if (_calendarView == CalendarView.month) {
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
```
 
**Note:** addPostFrameCallback will be called after the widget build() is completed.

**Step 3:** Navigate between the views using the PopupMenuButton widget as follows.

```dart
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
        _calendarView = CalendarView.day;
      } else if (value == 'Week') {
        _calendarView = CalendarView.week;
      } else if (value == 'WorkWeek') {
        _calendarView = CalendarView.workWeek;
      } else if (value == 'Month') {
        _calendarView = CalendarView.month;
      } else if (value == 'Timeline Day') {
        _calendarView = CalendarView.timelineDay;
      } else if (value == 'Timeline Week') {
        _calendarView = CalendarView.timelineWeek;
      } else if (value == 'Timeline WorkWeek') {
        _calendarView = CalendarView.timelineWorkWeek;
      }
    });
  },
),
```

**Step 4:** Using the OnTap event, you will get the targetElement (get details about the tapped element). By this, you can move to the calendar view using selected date of the calendar.

```dart
void calendarTapped(CalendarTapDetails calendarTapDetails) {
  if (_calendarView == CalendarView.month &&
      calendarTapDetails.targetElement == CalendarElement.calendarCell) {
    _calendarView = CalendarView.day;
    _updateState(calendarTapDetails.date);
  } else if ((_calendarView == CalendarView.week ||
          _calendarView == CalendarView.workWeek) &&
      calendarTapDetails.targetElement == CalendarElement.viewHeader) {
    _calendarView = CalendarView.day;
    _updateState(calendarTapDetails.date);
  }
} 
``` 
**[View document in Syncfusion Flutter Knowledge base](https://www.syncfusion.com/kb/10944/how-to-switch-between-views-of-the-event-calendar-sfcalendar-in-flutter)**

**Screenshots**

![dayview](http://www.syncfusion.com/uploads/user/kb/flut/flut-612/flut-612_img1.png)
![week](http://www.syncfusion.com/uploads/user/kb/flut/flut-612/flut-612_img2.png)
![work](http://www.syncfusion.com/uploads/user/kb/flut/flut-612/flut-612_img3.png)
![month](http://www.syncfusion.com/uploads/user/kb/flut/flut-612/flut-612_img4.png)
![timeline day](http://www.syncfusion.com/uploads/user/kb/flut/flut-612/flut-612_img5.png)
![timeline week](http://www.syncfusion.com/uploads/user/kb/flut/flut-612/flut-612_img6.png)
![timeline work week](http://www.syncfusion.com/uploads/user/kb/flut/flut-612/flut-612_img7.png)

