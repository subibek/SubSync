
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/models/invoice_model.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';

class CustomInvoiceListTile extends StatelessWidget {

  final BuildContext context;
  final InvoiceModel invoice;

  const CustomInvoiceListTile({
    super.key,
    required this.context,
    required this.invoice
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: 
      BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color:  themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray20))
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _buildCircularContainer(),
            _buildCompanyInfo(context),
          ],
        ),
      ),
    );
  }

  Expanded _buildCompanyInfo(BuildContext context) {
    return Expanded(
                flex: 11,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(flex: 3, child: Text(invoice.invoiceNumber, style: Theme.of(context).textTheme.textMd.copyWith(fontWeight: SubSyncTextStyles.semiBold),)),
                            Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text(invoice.amount, style: Theme.of(context).textTheme.textMd.copyWith(fontWeight: SubSyncTextStyles.bold),)))
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                DateFormat('yyyy-MM-dd').format(invoice.invoiceDate),
                                style: Theme.of(context).textTheme.textSm.copyWith(
                                  color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60
                                  ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if(invoice.status == "APPROVED") SvgPicture.asset('assets/icons/check_mark.svg', colorFilter: ColorFilter.mode(SubSyncColors.success60, BlendMode.srcIn)),
                                  if(invoice.status == "PENDING") SvgPicture.asset('assets/icons/HourglassSimpleOutlined.svg', colorFilter: ColorFilter.mode(SubSyncColors.brand60, BlendMode.srcIn)),
                                  if(invoice.status == "REJECTED") SvgPicture.asset('assets/icons/X.svg', colorFilter: ColorFilter.mode(SubSyncColors.destructive60, BlendMode.srcIn)),
                                  const SizedBox(width: 4),
                                  if(invoice.status == "APPROVED") Text(invoice.status, style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.medium, color:SubSyncColors.success60)),
                                  if(invoice.status == "PENDING") Text(invoice.status, style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.medium, color:SubSyncColors.brand60)),
                                  if(invoice.status == "REJECTED") Text(invoice.status, style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.medium, color:SubSyncColors.destructive60))
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
  }

  Expanded _buildCircularContainer() {
    return Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: 
                FractionallySizedBox(
                  widthFactor: 0.9,
                  heightFactor: 0.9,
                  child: CircleAvatar(
                    backgroundColor: (themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray10),
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      heightFactor: 0.7,
                      child: Center(child: Text(invoice.invoiceNumber))
                    ),
                  ),
                )
              ),
            );
  }
}