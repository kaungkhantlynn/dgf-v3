
import 'package:fleetmanagement/ui/tracking/carinfo/car_info_menu.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/calendar/calendar_utils.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/tracking_history_index.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TrackingHistoryFilter extends StatefulWidget {
  static const String route = '/tracking_history_filter';
  const TrackingHistoryFilter({Key? key}) : super(key: key);

  @override
  _TrackingHistoryFilterState createState() => _TrackingHistoryFilterState();
}

class TrackingHistoryArguments {
  String? license;
  String? formattedDate;

  TrackingHistoryArguments({this.license, this.formattedDate});
}

class _TrackingHistoryFilterState extends State<TrackingHistoryFilter> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  String? formattedDate;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(_focusedDay);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // print('FOCUSED_DAY '+ focusedDay.toString());
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(selectedDay);

    print('FORMATTED_DATE $formatted');
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        formattedDate = formatted;
      });
      // _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as TrackingHistoryFilterArguments;
    return Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.tracking_history'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            // eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 20,
                    fontFamily: 'Kanit')),
            calendarStyle: CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                cellMargin: const EdgeInsets.only(
                    left: 14, right: 14, bottom: 8, top: 8),
                defaultTextStyle: const TextStyle(fontFamily: 'Kanit'),
                selectedTextStyle:
                    const TextStyle(fontFamily: 'Kanit', color: Colors.white),
                todayTextStyle:
                    const TextStyle(fontFamily: 'Kanit', color: Colors.white),
                todayDecoration: BoxDecoration(
                    color: Colors.green.shade300,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(8.5))),
                selectedDecoration: BoxDecoration(
                    color: HexColor('#0097E7'),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                defaultDecoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                outsideDaysVisible: true,
                outsideDecoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                weekendDecoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                markerMargin: const EdgeInsets.only(top: 7.5, left: 1.4, right: 1.4),
                markerSize: 6,
                markerDecoration:
                    const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                if (day.weekday == DateTime.sunday) {
                  final text = DateFormat.E().format(day);

                  return Center(
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          // Expanded(
          //   child: ValueListenableBuilder<List<Event>>(
          //     valueListenable: _selectedEvents,
          //     builder: (context, value, _) {
          //       return ListView.builder(
          //         itemCount: value.length,
          //         itemBuilder: (context, index) {
          //           return Container(
          //             margin: const EdgeInsets.symmetric(
          //               horizontal: 12.0,
          //               vertical: 4.0,
          //             ),
          //             decoration: BoxDecoration(
          //               border: Border.all(),
          //               borderRadius: BorderRadius.circular(12.0),
          //             ),
          //             child: ListTile(
          //               onTap: () => print('${value[index]}'),
          //               title: Text('${value[index]}'),
          //             ),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
          const Expanded(
            child: Padding(padding: EdgeInsets.all(10)),
          ),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: HexColor('#5A75FF'),
                padding: const EdgeInsets.all(15.5),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.pushNamed(context, TrackingHistoryIndex.route,
                    arguments: TrackingHistoryArguments(
                        license: args.license, formattedDate: formattedDate));
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(14))
        ],
      ),
    );
  }
}
