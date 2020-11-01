import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:registerBook/API/firebase_methods.dart';
import 'package:registerBook/fragments/booking_details.dart';
import 'package:registerBook/fragments/add_vadi.dart';
import 'package:registerBook/integrations/colors.dart';
import 'package:nb_utils/src/widget_extensions.dart';
import 'CleanCalendar.dart';

class CalendarScreen extends StatefulWidget {
  final String vadiId;

  CalendarScreen({this.vadiId});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<VadiForCalendar> _selectedEvents;
  DateTime _selectedDay = DateTime.now();

  // List of the event on particular date.
  Map<DateTime, List<VadiForCalendar>> _events =
      Map<DateTime, List<VadiForCalendar>>();
  List<Color> colors = [appCat1, appCat2, appCat3];

  List<VadiForCalendar> _bookVadiList = [];

  bool _isInit = true, _isLoad = false;

  @override
  void initState() {
    super.initState();
    // if there is an event on particular date then if will return that list or else it will return empty list
    setState(() {
      _selectedEvents = _events[_selectedDay] ?? [];
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoad = true;
      });
      await Provider.of<FirebaseMethods>(context, listen: false)
          .getAndSetVadiInCalendar(widget.vadiId);

      setState(() {
        _bookVadiList = Provider.of<FirebaseMethods>(context, listen: false)
            .vadiForCalendar;
        _events = Provider.of<FirebaseMethods>(context, listen: false).mapList;
      });
      print(_bookVadiList);
      setState(() {
        _isLoad = false;
      });
      _isInit = false;
    }
  }

  BoxDecoration boxDecoration(
      {double radius = 2,
      Color color = Colors.transparent,
      Color bgColor = Colors.white,
      var showShadow = false}) {
    return BoxDecoration(
      color: bgColor,
      boxShadow: showShadow
          ? [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)]
          : [BoxShadow(color: Colors.transparent)],
      border: Border.all(color: color),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
  }

  @override
  void _handleNewDate(DateTime date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
      print(_selectedDay);
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              onTap: (index) {
                // Tab index when user select it, it start from zero
              },
              tabs: [
                Tab(icon: Icon(Icons.calendar_today)),
                Tab(icon: Icon(Icons.list)),
              ],
            ),
            backgroundColor: Color(0xFF8998FF),
            title: Text('Calender'),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: _isLoad
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : TabBarView(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          child: Calendar(
                            isExpanded: true,
                            initialDate: _selectedDay,
                            // if the value is true it will from monday or else sunday
                            startOnMonday: true,
                            // name of the week as per user choice
                            weekDays: [
                              "Mon",
                              "Tue",
                              "Wed",
                              "Thu",
                              "Fri",
                              "Sat",
                              "Sun"
                            ],
                            // Events list
                            events: _events,
                            // it will hide the Today icon in the header of calender
                            hideTodayIcon: false,
                            // it will highlight the today date and return thr events if there
                            onDateSelected: (date) => _handleNewDate(date),
                            // you want to expand your calender or not(if not then it will show the current week)
                            isExpandable: true,
                            // color of the bottom bar
                            bottomBarColor: Color(0xFF8998FF),
                            // color of the arrow in bottom bar
                            bottomBarArrowColor: Colors.white,
                            // style of the text on the bottom bar
                            bottomBarTextStyle: TextStyle(color: Colors.white),
                            // Completed event color
                            eventDoneColor: Colors.green,
                            // current selected date color
                            selectedColor: Color(0xFF8998FF),
                            // today's date color
                            todayColor: Color(0xFF8998FF),
                            // Color of event which are pending
                            eventColor: Colors.grey,
                            // style fot the day of the week list
                            dayOfWeekStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 11),
                          ),
                        ),
                        // if the date has event it will get call
                        _buildEventList(),
                      ],
                    ),
                    listTab(),
                  ],
                ),
        ),
      ),
    );
  }

  Builder listTab() {
    return Builder(builder: (BuildContext context) {
      var width = MediaQuery.of(context).size.width;
      var height = MediaQuery.of(context).size.height;

      return Consumer<FirebaseMethods>(
        builder: (context, vadiDetails, ch) => Container(
          padding: EdgeInsets.only(top: 20),
          margin: EdgeInsets.only(bottom: 20),
          child: vadiDetails.vadiForCalendar.length == 0
              ? Center(child: Image.asset('assets/img/nodatafound.png'))
              : AnimationLimiter(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: vadiDetails.vadiForCalendar.length,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final vadiId = vadiDetails.vadiForCalendar[index].id;
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: height * 0.5,
                          child: GestureDetector(
                            // onTap: () => Navigator.push(context,
                            //     MaterialPageRoute(builder: (_) {
                            //   return CalendarScreen(
                            //     vadiId: vadiDetails.vadiList[index].id,
                            //   );
                            // })),
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: <Widget>[
                                        Container(
                                          width: width,
                                          height: 60,
                                          padding: EdgeInsets.only(
                                              left: 16, right: 16),
                                          margin: EdgeInsets.only(
                                              right: width / 28),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: text(
                                                    '${vadiDetails.vadiForCalendar[index].name}',
                                                    textColor: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 18,
                                                    fontSize: 17.0,
                                                    maxLine: 2),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  text(
                                                      '${vadiDetails.vadiForCalendar[index].eventName}',
                                                      textColor: Colors.black,
                                                      fontFamily: 18,
                                                      fontSize: 14.0,
                                                      maxLine: 2),
                                                  text(
                                                      '${DateFormat("dd/MM/yyyy").format(vadiDetails.vadiForCalendar[index].eventDate)}',
                                                      textColor: Colors.black,
                                                      fontFamily: 18,
                                                      fontSize: 14.0,
                                                      maxLine: 2),
                                                ],
                                              ).expand(),
                                            ],
                                          ),
                                          decoration: boxDecoration(
                                              bgColor: Colors.white,
                                              radius: 4,
                                              showShadow: true),
                                        ),
                                      ],
                                    ),
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
        ),
      );
    });
  }

  Widget text(var text,
      {double fontSize = 20.0,
      textColor = Colors.white,
      var fontFamily = 16,
      fontWeight = FontWeight.normal,
      var isCentered = false,
      var maxLine = 1,
      var latterSpacing = 0.5}) {
    return Text(text,
        textAlign: isCentered ? TextAlign.center : TextAlign.start,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontWeight: fontWeight,
            // fontFamily: fontFamily,
            fontSize: fontSize,
            color: textColor,
            height: 1.5,
            letterSpacing: 1));
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Colors.black12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BookingDetails(
                        vadiForCalendar: _selectedEvents[index],
                        vadiId: widget.vadiId,
                      )));
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, top: 5, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _selectedEvents[index].vadiName.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                        child:
                            Text(_selectedEvents[index].eventTime.toString()),
                      )
                    ],
                  ),
                  _selectedEvents[index].isDone == true
                      ? Row(
                          children: <Widget>[
                            Text('Booked',
                                style: TextStyle(color: Colors.black54)),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Cancle',
                              style: TextStyle(color: Colors.black54),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
        itemCount: _selectedEvents.length,
      ),
    );
  }
}
