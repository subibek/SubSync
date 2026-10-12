import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/models/schedule_details_model.dart';
import 'package:subsync/models/schedule_model.dart';
import 'package:subsync/screens/home_screen/home_screen.dart';
import 'package:subsync/services/schedule_service.dart';
import 'package:subsync/utils/border_radius.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {

  AllScheduleModel? allSchedule;

  List<Map<String, dynamic>> scheduleDates = [];
  String? _error;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState(){
    super.initState();
    getScheduleDates();
  }

  void getScheduleDates() async {
    try{

      allSchedule = await ScheduleService.getUserSchedule();

      if(allSchedule == null){
        setState(() {
          _error = "Schedule returned empty.";
        });  
      } else {
        final dates = allSchedule!.data.results.map((item)=>{ "id": item.id, "date" :item.scheduledDate}).toList();
        setState(()=> scheduleDates = dates);
      }

    } catch(e) {
      if(!mounted)return;
      setState(() {
        _error = e.toString();
      });
    }
  }

    DateTime _startOfWeek(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    return day.subtract(Duration(days: day.weekday % 7));
  }

  List<DateTime> get _weekDays {
    final start = _startOfWeek(_selectedDay);
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  List _eventsFor(DateTime day) =>
      scheduleDates.where((item) => isSameDay(item['date'], day)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusLg),
                    border: Border.all(color: themeBloc.isDarkMode ? SubSyncColors.gray70: SubSyncColors.gray30)
                  ),
                  child: TableCalendar(
                    focusedDay: _focusedDay, 
                    firstDay: DateTime.utc(2010, 10, 10), 
                    lastDay: DateTime.utc(2030, 10, 10),
                    eventLoader: (day){
                      return scheduleDates.where((item){
                        return isSameDay(item['date'], day);
                      }).toList();
                    },
                  
                    onDaySelected: (selectedDay, focusedDay) {
                      // if(scheduleDates.any((item)=> isSameDay(item['date'],selectedDay)))
                      // {showScheduleDetailsDialog(selectedDay);}
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                  
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        if(events.isNotEmpty) {
                          return Positioned(
                            bottom: 0,
                            child: Container(
                              width: 20,
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusLg),
                                color: themeBloc.currentColor
                              ),
                            )
                          );
                        } 
                      },
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: Theme.of(context).textTheme.paragraphSm.copyWith(fontWeight: SubSyncTextStyles.bold, color:  themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray90),
                      weekendStyle: Theme.of(context).textTheme.paragraphSm.copyWith(fontWeight: SubSyncTextStyles.bold, color:  themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray90),
                    ),
                    
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      defaultTextStyle: Theme.of(context).textTheme.paragraphSm.copyWith(fontWeight: SubSyncTextStyles.medium, color:  themeBloc.isDarkMode ? SubSyncColors.gray40 : SubSyncColors.gray80),
                      weekendTextStyle: Theme.of(context).textTheme.paragraphSm.copyWith(fontWeight: SubSyncTextStyles.medium, color:  themeBloc.isDarkMode ? SubSyncColors.gray40 : SubSyncColors.gray80),
                      todayTextStyle: TextStyle(color: themeBloc.currentColor),
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeBloc.isDarkMode ? SubSyncColors.gray70.withValues(alpha: 0.8) : SubSyncColors.gray30
                      )
                    ),

                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: Theme.of(context).textTheme.paragraphLg.copyWith(fontWeight: SubSyncTextStyles.bold)
                    ),
                    // onFormatChanged: (onChanged){
                    // },
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: ListView.separated(
                    // padding: const EdgeInsets.all(16),
                    itemCount: 7,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final day = _weekDays[i];
                      final events = _eventsFor(day);
                      final isSelected = isSameDay(day, _selectedDay);

                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedDay = day);
                          if (events.isNotEmpty) showScheduleDetailsDialog(day);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? themeBloc.currentColor.withValues(alpha: 0.12)
                                : themeBloc.isDarkMode ? SubSyncColors.gray90 : SubSyncColors.gray20,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? themeBloc.currentColor
                                  : themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray40,
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 48,
                                child: Column(
                                  children: [
                                    Text(
                                      DateFormat.E().format(day),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '${day.day}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  events.isEmpty
                                      ? 'No schedule'
                                      : '${events.length} scheduled',
                                  style: Theme.of(context).textTheme.paragraphMd.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray40 : SubSyncColors.gray80)
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ),
        ),
    );
  }

  void showScheduleDetailsDialog(DateTime date) async {

    // final selectedDays = scheduleDates.where((item) => isSameDay(item['date'], date));
    final selectedDay = scheduleDates.firstWhere((item) => isSameDay(item['date'], date));
    String id = selectedDay['id'];

    ScheduleDetailsModel? schedule = await ScheduleService.getScheduleDetails(id);

    showDialog(
      barrierColor: themeBloc.isDarkMode ? Colors.black.withValues(alpha: 0.8): SubSyncColors.gray10.withValues(alpha: 0.4),
      context: context,
      builder: (context) => Dialog(
        backgroundColor: themeBloc.isDarkMode ? SubSyncColors.gray90: SubSyncColors.gray10,
        insetPadding: EdgeInsets.all(30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(SubSyncBorderRadius.radius2xl)),
        child: 
        schedule == null 
        ? Text('No Schedule Data') 
        : SizedBox(
          width: double.infinity,
          // height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: themeBloc.currentColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SubSyncBorderRadius.radius2xl),
                    topRight: Radius.circular(SubSyncBorderRadius.radius2xl)
                  )
                  // color: themeBloc.currentColor.withValues(alpha: 0.6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(width: 44, height: 44, decoration: BoxDecoration(color: themeBloc.currentColor, borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusLg)), child: Center(child: Icon(Icons.location_on_outlined))),
                    const SizedBox(width: 10),
                    Text(
                      schedule.data.site.name,
                      style: Theme.of(context).textTheme.label2xl.copyWith(fontWeight: SubSyncTextStyles.medium),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (){ context.pop(); },
                      child: SvgPicture.asset('assets/icons/X.svg',colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray0 : SubSyncColors.gray90, BlendMode.srcIn),),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(SubSyncBorderRadius.radius2xl),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(SubSyncBorderRadius.radius2xl),
                    bottomRight: Radius.circular(SubSyncBorderRadius.radius2xl)
                  ),
                  border: Border(
                    left: BorderSide(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70: SubSyncColors.gray30),
                    right: BorderSide(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70: SubSyncColors.gray30),
                    bottom: BorderSide(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70: SubSyncColors.gray30)
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: themeBloc.currentColor,
                        borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull)
                      ),
                      child: IntrinsicWidth(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: SubSyncColors.success60
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Scheduled',
                                style: Theme.of(context).textTheme.paragraphSm,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    customDialogListTile(context, 'assets/icons/CalendarBlank.svg', 'Date', DateFormat('EEEE, d MMM yyyy').format(schedule.data.scheduledDate)),
                    const SizedBox(height: 15),
                    customDialogListTile(context, 'assets/icons/Clock.svg', 'Time', DateFormat('h:mm a').format(DateFormat('HH:mm').parse(schedule.data.scheduledTime))),
                    const SizedBox(height: 15),
                    customDialogListTile(context, 'assets/icons/location.svg', 'Address', schedule.data.site.address),
                    const SizedBox(height: 20),
                    Text('Notes',style: Theme.of(context).textTheme.labelMd.copyWith(fontWeight: SubSyncTextStyles.bold, color: themeBloc.isDarkMode ? SubSyncColors.gray50 : SubSyncColors.gray70)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SubSyncBorderRadius.radius2xl),
                        color: themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray20
                      ),
                      child: Text(
                        schedule.data.notes,
                        style: Theme.of(context).textTheme.labelMd
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
              
            ],
          ),
        ),
      )
    );

  }

  Row customDialogListTile(BuildContext context, String iconPath, String title, String content) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: themeBloc.currentColor,
              borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusMd)
            ),
            child: SvgPicture.asset(height: 20, iconPath, colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn) , fit: BoxFit.contain,)
          ) 
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelMd.copyWith(fontWeight: SubSyncTextStyles.bold, color: themeBloc.isDarkMode ? SubSyncColors.gray50 : SubSyncColors.gray70)),
                Text(content, style: Theme.of(context).textTheme.labelMd)
              ],
            ), 
          )
        )
      ],
    );
}
}