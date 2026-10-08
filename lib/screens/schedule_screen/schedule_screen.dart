import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/models/schedule_details_model.dart';
import 'package:subsync/models/schedule_model.dart';
import 'package:subsync/screens/home_screen/home_screen.dart';
import 'package:subsync/services/schedule_service.dart';
import 'package:subsync/utils/border_radius.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {

  AllScheduleModel? allSchedule;
  DateTime? _selectedDay;

  List<Map<String, dynamic>> scheduleDates = [];
  bool _loading = true;
  String? _error;

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
          _loading = false;
        });  
      } else {
        final dates = allSchedule!.data.results.map((item)=>{ "id": item.id, "date" :item.scheduledDate}).toList();
        setState(()=> scheduleDates = dates);
      }

    } catch(e) {
      if(!mounted)return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              TableCalendar(
                focusedDay: DateTime.now(), 
                firstDay: DateTime.utc(2010, 10, 10), 
                lastDay: DateTime.utc(2030, 10, 10),
                eventLoader: (day){
                  return scheduleDates.where((item){
                    return isSameDay(item['date'], day);
                  }).toList();
                },

                onDaySelected: (selectedDay, focusedDay) {
                  if(scheduleDates.any((item)=> isSameDay(item['date'],selectedDay)))
                  {showScheduleDetailsDialog(selectedDay);}
                },

                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if(events.isNotEmpty) {
                      return Positioned(
                        bottom: 4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeBloc.currentColor
                          ),
                        )
                      );
                    } 
                  },
                ),
                onFormatChanged: (onChanged){
                },
              )
            ],
          )
        ),
    );
  }

  void showScheduleDetailsDialog(DateTime date) async {

    final selectedDay = scheduleDates.firstWhere((item) => isSameDay(item['date'], date));
    String id = selectedDay['id'];

    ScheduleDetailsModel? schedule = await ScheduleService.getScheduleDetails(id);

    showDialog(
      context: context, 
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(SubSyncBorderRadius.radius2xl)),
        child: 
        schedule == null 
        ? Text('No Schedule Data') 
        : SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Schedule', style: Theme.of(context).textTheme.headingMd.copyWith(fontWeight: SubSyncTextStyles.bold)),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: 'Site Name: ',
                      style: Theme.of(context).textTheme.paragraphSm.copyWith(fontWeight: SubSyncTextStyles.medium),
                      children: [
                        TextSpan(
                          text: schedule.data.site.name
                        )
                      ]
                    ),
                  ),
            
                  RichText(
                    text: TextSpan(
                      text: 'Site Address: ',
                      style: Theme.of(context).textTheme.paragraphSm.copyWith(fontWeight: SubSyncTextStyles.medium),
                      children: [
                        TextSpan(
                          text: schedule.data.site.address
                        )
                      ]
                    ),
                  ),
            
                  RichText(
                    text: TextSpan(
                      text: 'Cleaning Frequency: ',
                      style: Theme.of(context).textTheme.paragraphSm.copyWith(fontWeight: SubSyncTextStyles.medium),
                      children: [
                        TextSpan(
                          text: schedule.data.site.cleaningFrequency
                        )
                      ]
                    ),
                  ),
            
                  RichText(
                    text: TextSpan(
                      text: 'Cleaning instructions: ',
                      style: Theme.of(context).textTheme.paragraphSm.copyWith(fontWeight: SubSyncTextStyles.medium),
                      children: [
                        TextSpan(
                          text: schedule.data.site.cleaningInstructions
                        )
                      ]
                    ),
                  ),
                ],
              ),
          ),
        ),
      )
    );

  }
}