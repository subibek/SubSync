import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/models/invoice_details_model.dart';
import 'package:subsync/models/invoice_model.dart';
import 'package:subsync/services/invoice_service.dart';
import 'package:subsync/utils/border_radius.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_arrow_back_button.dart';
import 'package:subsync/widgets/custom_bottom_modal.dart';
import 'package:subsync/widgets/custom_button.dart';
import 'package:subsync/widgets/custom_invoice_list_tile.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {

  List<Map<String, String>> workStatusFilterOptions = [
    {'title': 'Approved', 'icon' : 'assets/icons/check_mark.svg'},
    {'title': 'Pending', 'icon' : 'assets/icons/HourglassSimpleOutlined.svg'},
    {'title': 'Rejected', 'icon' : 'assets/icons/X.svg'},
    ]; 
  String? selectedWorkStatusFilter;
  ValueNotifier<DateTime?> dateFilterValue = ValueNotifier<DateTime?>(null); 

  Future<InvoiceListModel?> invoiceList = InvoiceService.getInvoicesList();

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
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
            _buildContent(context),
          ],
        )
    );
  }

    SliverToBoxAdapter _buildContent(BuildContext context) {
    return SliverToBoxAdapter(
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            _buildFilterTile(context),

            const SizedBox(height: 20),

            FutureBuilder<InvoiceListModel?>(
                future: invoiceList, 
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
              
                  InvoiceListModel invoices = snapshot.data!;

                  if(invoices.data.results.isEmpty) return Text('No data to show');
              
                  return Column(
                    children: invoices.data.results.map((invoice) => 
                      GestureDetector(
                        onTap: (){
                          showInvoiceDetailsDialog(invoice.id);
                        },
                        child: CustomInvoiceListTile(context: context, invoice: invoice)
                      )
                    ).toList(),
                  );
                }
              },
            ),
          ],
        ),
      )
    );
  }

    Row _buildFilterTile(BuildContext context) {
    return Row(
      children: [
        Text(
          'Invoices ',
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
                    
                    invoiceList = InvoiceService.getInvoicesListWithFilter(  
                      (dateFilterValue.value != null) ? DateFormat('yyyy-MM-dd').format(dateFilterValue.value!) : null, 
                      selectedWorkStatusFilter
                    );
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

    void showInvoiceDetailsDialog(String id) async {

    InvoiceDetailsModel? invoice = await InvoiceService.getInvoiceDetails(id);
    Color invoiceStatusColor = SubSyncColors.gray50;

    if(invoice != null){
      if(invoice.data.status == "APPROVED") invoiceStatusColor = SubSyncColors.success60; 
      if(invoice.data.status == "PENDING") invoiceStatusColor = SubSyncColors.brand50; 
      if(invoice.data.status == "REJECTED") invoiceStatusColor = SubSyncColors.destructive60;
    }

    showDialog(
      context: context, 
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(SubSyncBorderRadius.radius2xl)),
        child: 
        invoice == null 
        ? Text('No Invoice Data') 
        : SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Invoice ${invoice.data.invoiceNumber}", style: Theme.of(context).textTheme.headingMd.copyWith(fontWeight: SubSyncTextStyles.bold)),
                      Spacer(),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: SvgPicture.asset('assets/icons/X.svg', width: 20, colorFilter: ColorFilter.mode(SubSyncColors.gray50, BlendMode.srcIn)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/location.svg", width: 8, colorFilter: ColorFilter.mode(SubSyncColors.gray50, BlendMode.srcIn)),
                      const SizedBox(width: 6),
                      Text(invoice.data.site.name, style: Theme.of(context).textTheme.paragraphSm),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: themeBloc.isDarkMode ? SubSyncColors.gray90 : SubSyncColors.gray30,
                      borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusLg)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total ${(invoice.data.gst) ? "incl" : "excl"} GST", style: Theme.of(context).textTheme.labelMd.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray40:SubSyncColors.gray80)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          Text(invoice.data.amount, style: Theme.of(context).textTheme.headingMd.copyWith(fontWeight: SubSyncTextStyles.bold)),
                          Spacer(),
                          CustomButton(
                            height: 25,
                            width: 80,
                            onTap: (){},
                            title: invoice.data.status, 
                            titleStyle: Theme.of(context).textTheme.labelSm.copyWith(color: invoiceStatusColor),
                            outlinedBorder: true, 
                            outlineBorderColor: invoiceStatusColor
                          )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text("Amount", style: Theme.of(context).textTheme.labelMd.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray40 : SubSyncColors.gray80)),
                      Spacer(),
                      (invoice.data.gst) 
                        ? Text((double.parse(invoice.data.amount) * 1.1).toString(), style: Theme.of(context).textTheme.labelMd.copyWith(fontWeight: SubSyncTextStyles.semiBold))
                        : Text(invoice.data.amount, style: Theme.of(context).textTheme.labelMd.copyWith(fontWeight: SubSyncTextStyles.semiBold))
                    ],
                  ),
                  if(invoice.data.gst) 
                  Row(
                    children: [
                      Text("GST(10%)", style: Theme.of(context).textTheme.labelMd.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray80)),
                      Spacer(),
                      Text((double.parse(invoice.data.amount) / 11).toString(), style: Theme.of(context).textTheme.labelMd.copyWith(fontWeight: SubSyncTextStyles.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("Service Period", style: Theme.of(context).textTheme.labelMd.copyWith(fontWeight: SubSyncTextStyles.bold)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start", style: Theme.of(context).textTheme.labelSm.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray40 : SubSyncColors.gray80)),
                          Text(DateFormat('d MMM yyyy').format(invoice.data.servicePeriodStart), style: Theme.of(context).textTheme.labelMd.copyWith(fontWeight: SubSyncTextStyles.bold)),                          
                        ],
                      ),
                      Icon(Icons.arrow_right_alt),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("End", style: Theme.of(context).textTheme.labelSm.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray40 : SubSyncColors.gray80)),
                          Text(DateFormat('d MMM yyyy').format(invoice.data.servicePeriodEnd), style: Theme.of(context).textTheme.labelMd.copyWith(fontWeight: SubSyncTextStyles.bold)),                          
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Invoice Date", style: Theme.of(context).textTheme.labelMd.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray40 : SubSyncColors.gray80)),
                      Spacer(),
                      Text(DateFormat('d MMM yyyy').format(invoice.data.invoiceDate), style: Theme.of(context).textTheme.labelMd.copyWith(fontWeight: SubSyncTextStyles.semiBold))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("Verification", style: Theme.of(context).textTheme.labelMd.copyWith(fontWeight: SubSyncTextStyles.bold)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: themeBloc.isDarkMode ? SubSyncColors.gray90 : SubSyncColors.gray30,
                      borderRadius: BorderRadius.circular(SubSyncBorderRadius.radiusLg)
                    ),
                    child: Text("Not approved yet. Approvers details and will will show here once this invoice is checked.", style: Theme.of(context).textTheme.labelSm.copyWith(fontWeight: SubSyncTextStyles.medium))  
                  ),
                  const SizedBox(height: 10),
                  Divider(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Invoice ID:", style: Theme.of(context).textTheme.labelMd.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray40 : SubSyncColors.gray80)),
                      Spacer(),
                      Text(invoice.data.id, style: Theme.of(context).textTheme.labelMd.copyWith(color: themeBloc.isDarkMode ? SubSyncColors.gray40 : SubSyncColors.gray80))
                    ],
                  ),
                ],
              ),
          ),
        ),
      )
    );

  }

    RichText customListItem(String title, String content) {
      return RichText(
        text: TextSpan(
          text: title,
          style: Theme.of(context).textTheme.paragraphSm.copyWith(fontWeight: SubSyncTextStyles.bold, color: themeBloc.isDarkMode ? SubSyncColors.gray5 : SubSyncColors.gray90),
          children: [
            TextSpan(
              text: content,
              style: Theme.of(context).textTheme.paragraphSm.copyWith(fontWeight: SubSyncTextStyles.medium, color: themeBloc.isDarkMode ? SubSyncColors.gray50 : SubSyncColors.gray70)
            )
          ]
        ),
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
                    case 'Approved':
                      bgColor = themeBloc.isDarkMode ? SubSyncColors.success90 : SubSyncColors.success5;
                      borderColor = SubSyncColors.success60;
                      textColor =  themeBloc.isDarkMode ? SubSyncColors.success10 : SubSyncColors.success90;
                      break;

                    case 'Pending':
                      bgColor = themeBloc.isDarkMode ? SubSyncColors.brand90 : SubSyncColors.brand5;
                      borderColor = SubSyncColors.brand60;
                      textColor =  themeBloc.isDarkMode ? SubSyncColors.brand10 : SubSyncColors.brand90;
                      break;

                    case 'Rejected':
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
                          (dateFilterValue.value != null) ? DateFormat('dd / MM / yyy').format(dateFilterValue.value!) : '',
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
