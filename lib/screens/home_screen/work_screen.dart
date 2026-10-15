import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/models/all_work_model.dart';
import 'package:subsync/services/work_service.dart';
import 'package:subsync/utils/border_radius.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_arrow_back_button.dart';
import 'package:subsync/widgets/custom_bottom_modal.dart';
import 'package:subsync/widgets/custom_button.dart';
import 'package:subsync/widgets/custom_work_list_tile.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {

  List<Map<String, String>> workStatusFilterOptions = [
    {'title': 'Completed', 'icon' : 'assets/icons/check_mark.svg'},
    {'title': 'In_Progress', 'icon' : 'assets/icons/HourglassSimpleOutlined.svg'},
    {'title': 'Missed', 'icon' : 'assets/icons/X.svg'},
  ]; 
  String? selectedWorkStatusFilter;
  ValueNotifier<DateTime?> dateFilterValue = ValueNotifier<DateTime?>(null);

  Future<AllWorkModel?> allWorkList = WorkService.getAllWork();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: Align(alignment: Alignment.centerLeft, child: CustomAppbarBackButton())),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
          _buildContent(context)
        ],
      )
    );
  }

  SliverToBoxAdapter _buildContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            _buildFilterTile(context),
            const SizedBox(height: 20),
            FutureBuilder<AllWorkModel?>(
                future: allWorkList, 
                builder: (context, snapshot) {

                  if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                else if(snapshot.hasError){
                  return const Center(child: Text('Error'));
                }
                else if(snapshot.data == null){
                  return const Center(child: Text('No data to show'));
                }
                else{
              
                  AllWorkModel work = snapshot.data!;

                  if(work.data.results.isEmpty) return Text('No data to show');
              
                  return Column(
                    children: work.data.results.map((work) => 
                      GestureDetector(
                        onTap: (){
                          // showInvoiceDetailsDialog(invoice.id);
                        },
                        child: CustomWorkListTile(context: context, work: work)
                      )
                    ).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _buildFilterTile(BuildContext context) {
    return Row(
      children: [
        Text(
          'Work ',
          style: Theme.of(context).textTheme.textLg.copyWith(fontWeight: SubSyncTextStyles.bold),
          ),
          const Spacer(),
        GestureDetector(
          onTap: () async {
            showCustomBottomModal(
              context, 
              title: 'Filter', 
              child: Column(
                children: [
                  _buildDatePicker(),
                  const SizedBox(height: 30),
                  _buildWorkStatusFilter()
                ],
              ), 
              button: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomButton(onTap: (){
                  setState(() {
                    context.pop();
                    allWorkList = WorkService.getAllWorkListWithFilter(
                      (dateFilterValue.value != null) ? DateFormat('yyyy-MM-dd').format(dateFilterValue.value!) : null, 
                      selectedWorkStatusFilter);
                  });
                }, outlinedBorder: false, title: "Apply Filter"),
              )
            );
          },
          child: Row(       
            children: [
                SizedBox(
                width: 20, height: 20,
                child: SvgPicture.asset('assets/icons/CalendarBlank.svg')),
              const SizedBox(width: 5),
              Text(
                'Filter',
                style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.medium),
              ),
              const SizedBox(width: 5),
              SizedBox(
                width: 20, height: 20,
                child: SvgPicture.asset('assets/icons/CaretDown.svg', colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60, BlendMode.srcIn),))
            ],
          ),
        )
      ],
    );
  }

    Column _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Date of Birth", style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.semiBold)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: (){
              _showDatePicker(dateFilterValue);
            },
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray0,
                border: Border.all(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray30),
                borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: dateFilterValue,
                      builder: (context, value, child) {
                        return Text(
                          (dateFilterValue.value != null) 
                            ? DateFormat('dd / MM / yyy').format(dateFilterValue.value!)
                            : '',
                          style: Theme.of(context).textTheme.textMd.copyWith(
                            color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60
                            ),
                        );
                      }
                    ),
                    SvgPicture.asset('assets/icons/CalendarBlank.svg', width: 20, fit: BoxFit.scaleDown, 
                    colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60 , BlendMode.srcIn)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

    StatefulBuilder _buildWorkStatusFilter() {
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Work Status', style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.semiBold),),
              const SizedBox(height: 10),
              Wrap(
                spacing: 5,
                children: workStatusFilterOptions.map((option) {
                    
                  bool isSelected = (selectedWorkStatusFilter == option['title']);
                  Color? bgColor;
                  Color? borderColor;
                  Color? textColor;
                  

                  switch(option['title']){
                    case 'Completed':
                      bgColor = themeBloc.isDarkMode ? SubSyncColors.success90 : SubSyncColors.success5;
                      borderColor = SubSyncColors.success60;
                      textColor =  themeBloc.isDarkMode ? SubSyncColors.success10 : SubSyncColors.success90;
                      break;

                    case 'In_Progress':
                      bgColor = themeBloc.isDarkMode ? SubSyncColors.brand90 : SubSyncColors.brand5;
                      borderColor = SubSyncColors.brand60;
                      textColor =  themeBloc.isDarkMode ? SubSyncColors.brand10 : SubSyncColors.brand90;
                      break;

                    case 'Missed':
                      bgColor = themeBloc.isDarkMode ? SubSyncColors.destructive90 : SubSyncColors.destructive5;
                      borderColor = SubSyncColors.destructive60;
                      textColor =  themeBloc.isDarkMode ? SubSyncColors.destructive10 : SubSyncColors.destructive90;
                      break;
                  }

              
                  return GestureDetector(
                        onTap: (){
                          if(selectedWorkStatusFilter == option['title']){
                            setState(()=> selectedWorkStatusFilter = null);
                          } else
                          {setState(() => selectedWorkStatusFilter = option['title']);}
                        },
                        child: IntrinsicWidth(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5,),
                            child: Container(
                              decoration: BoxDecoration(
                                color:  isSelected ? bgColor : null,
                                borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusFull),
                                border: Border.all(
                                  width: 1, 
                                  color: themeBloc.isDarkMode 
                                  ? isSelected ? borderColor! :SubSyncColors.gray70 
                                  : isSelected ? borderColor! :SubSyncColors.gray30
                                )
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: SvgPicture.asset(
                                          option['icon']!,
                                          colorFilter: ColorFilter.mode( textColor!, BlendMode.srcIn),
                                          )),
                                      const SizedBox(width: 5),
                                      Text(
                                        option['title']!,
                                        style: Theme.of(context).textTheme.textSm.copyWith(
                                          fontWeight: SubSyncTextStyles.semiBold,
                                          color: isSelected ? textColor : themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ); 
                }).toList() 
              ),
            ],
          ),
        );
      }
    );
  }

    void _showDatePicker(ValueNotifier notifier) async {

    var date = DateTime.now();

    notifier.value = await showDatePicker(
      barrierDismissible: true,
      barrierColor: themeBloc.isDarkMode ? SubSyncColors.gray90.withValues(alpha:0.9) : SubSyncColors.gray10.withValues(alpha: 0.9),
      context: context, 
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: SubSyncColors.gray60,
              onPrimary:  themeBloc.currentColor,
              onSurface: SubSyncColors.gray30
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60)
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: SubSyncColors.gray90
            )
          ), 
          child: child!
        );
      },
      firstDate: DateTime(date.year - 100), 
      initialDate: null,
      lastDate: DateTime(date.year + 10)
    );
  }
}