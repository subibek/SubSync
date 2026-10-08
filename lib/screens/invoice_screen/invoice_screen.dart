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
  ValueNotifier<DateTime?> dateFilterValue = ValueNotifier<DateTime?>(DateTime.now()); 

  Future<InvoiceListModel?> invoiceList = InvoiceService.getInvoicesList();

  @override
  void initState() {
    // TODO: implement initState
    dateFilterValue.value = DateTime.now();
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
                    invoiceList = InvoiceService.getInvoicesListWithFilter(DateFormat('yyyy-MM-dd').format(dateFilterValue.value!), selectedWorkStatusFilter);
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
                'This Week',
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
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invoice Details', style: Theme.of(context).textTheme.headingMd.copyWith(fontWeight: SubSyncTextStyles.bold)),
                  const SizedBox(height: 30),
                  customListItem('Invoice id: ', invoice.data.id),
                  customListItem('Invoice number: ', invoice.data.invoiceNumber),
                  customListItem('Site name: ', invoice.data.site.name),
                  customListItem('Invoice date: ', DateFormat('yyyy-MM-dd').format(invoice.data.invoiceDate)),
                  customListItem('Service period start: ', DateFormat('yyyy-MM-dd').format(invoice.data.servicePeriodStart)),
                  customListItem('Service period end: ', DateFormat('yyyy-MM-dd').format(invoice.data.servicePeriodEnd)),
                  customListItem('Amount: ', invoice.data.amount),
                  customListItem('Status: ', invoice.data.status),
                  customListItem('Verification notes: ', invoice.data.verificationNotes ?? ""),
                  customListItem('Verrified by: ', invoice.data.verifiedBy ?? ""),
                  customListItem('Verified at: ', invoice.data.verifiedAt ?? ""),
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
                          setState(() {
                            selectedWorkStatusFilter = option['title'];
                          });
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
                          DateFormat('dd / MM / yyy').format(dateFilterValue.value ?? DateTime.now()),
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
      initialDate: date,
      lastDate: DateTime(date.year + 10)
    );
  }
}
