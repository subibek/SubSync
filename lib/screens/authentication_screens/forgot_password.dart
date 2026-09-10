import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_button.dart';
import 'package:subsync/widgets/custom_error_message.dart';
import 'package:subsync/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController emailController = TextEditingController();
  bool isErrorMessageVisible = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16/9,
                    child: SvgPicture.asset(themeBloc.isDarkMode ? 'assets/icons/Security(Dark).svg' : 'assets/icons/Security(Light).svg'),
                  ),
                  Text('Format Password', style: Theme.of(context).textTheme.headingXs.copyWith(fontWeight: SubSyncTextStyles.bold)),
                  const SizedBox(height: 10),
                  Text('Please enter your email addresss to reset your password.', style: Theme.of(context).textTheme.paragraphMd, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: emailController, 
                    label: "Email",
                    hintText: "Enter you email address...",
                    prefixIcon: 'assets/icons/mail_outline_bold.svg',
                    validator: (email){
                      if(email == null || email.isEmpty){
                        setState(() {
                          isErrorMessageVisible = true;
                        });
                        return '';
                      }
                    },
                  ),
                  if(isErrorMessageVisible) const CustomErrorMessage(content: 'Invalid email address!'),
                  const SizedBox(height: 20),
                  CustomButton(
                    outlinedBorder: false,
                    title: "Rest Password",
                    onTap: (){
                      final form = formKey.currentState!;

                      if(form.validate()){ 
                      }
                    }, 
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}