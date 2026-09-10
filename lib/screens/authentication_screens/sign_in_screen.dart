import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/services/user_service.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/route/route_names.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_button.dart';
import 'package:subsync/widgets/custom_error_message.dart';
import 'package:subsync/widgets/custom_text_button.dart';
import 'package:subsync/widgets/custom_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isChecked = true;
  bool showErrorMessage = false;
  String errorMessage = 'ERROR: Invalid email or password!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'SubSync',
                    style: Theme.of(context).textTheme.headingLg.copyWith(color: themeBloc.currentColor, fontWeight: SubSyncTextStyles.bold),
                  ),
                  const SizedBox(height: 80),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Sign In to SubSync',
                      style: Theme.of(context).textTheme.headingSm.copyWith(fontWeight: SubSyncTextStyles.bold)
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildEmailTextField(),
                  const SizedBox(height: 20),
                  _buildPasswordTextField(),
                  const SizedBox(height: 20),
                  _buildCheckbox(context),
                  const SizedBox(height: 20),
                  if (showErrorMessage) CustomErrorMessage(content: errorMessage),
                  const SizedBox(height: 20),
                  _buildSignInButton(),
                  const SizedBox(height: 30),
                  CustomTextButton(
                    content: 'Forgot Password', 
                    onTap: (){
                      context.push(RouteNames.forgotPassword);
                    },
                    underline: true ,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CustomTextField _buildEmailTextField() {
    return CustomTextField(
      controller: emailController,
      label: 'Email Address', 
      hintText: 'Enter you email address..',
      validator: (email) {
        // RegExp regExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

         if(email == null || email.isEmpty){
            setState(() => showErrorMessage = true);

            return 'Enter you email.';
          }
          // else if(!regExp.hasMatch(email)){
          //   setState(() {
          //     showErrorMessage = true;
          //     errorMessage = "Enter a valid email.";
          //   });

          //   return 'message';
          // }
          else {
            return null;
          }
      },
    );
  }

  CustomTextField _buildPasswordTextField() {
    return CustomTextField(
      controller: passwordController, 
      label: 'Password', 
      hintText: 'Enter your password...', 
      prefixIcon: 'assets/icons/padlock.svg',
      activeSuffixIcon: 'assets/icons/visibility.svg',
      disabledSuffixIcon: 'assets/icons/visibility_off.svg',
      obscureText: true,
      validator: 
      (password){
  
        if(password == null || password.isEmpty){
          setState(() => showErrorMessage = true);

          return 'Enter your password...';
        }
        else {
          return null;
        }
        
      },
    );
  }

   Widget _buildCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Checkbox(
              side: WidgetStateBorderSide.resolveWith(
                (states) => BorderSide(
                      width: isChecked ? 1.5 : 1,
                      color: themeBloc.currentColor,
                      strokeAlign:
                          BorderSide.strokeAlignCenter,
                            ),
              ),
              value: isChecked, 
              onChanged: (bool? value){
                setState(() {
                  isChecked = value!;
                });
              },
              checkColor: Colors.white,
              activeColor: themeBloc.currentColor,
              shape: const CircleBorder(),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Remember for 30 days',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            )
        ],
      ),
    );
  }

  CustomButton _buildSignInButton() {
    return CustomButton(
      onTap: () async {
        setState(() => showErrorMessage = false);
        final form = _formKey.currentState!;

        if(form.validate()){
          setState(() => isLoading = true);

          String response = await UserService.login(emailController.text, passwordController.text);

          if(response == "Success"){
            context.go(RouteNames.homeScreen);
          } else {
            setState(() {
              errorMessage = "Invalid credentials.";
              showErrorMessage = true;
              isLoading = false;
            });
          }

          // String message = await UserService.login(emailController.text, passwordController.text);

          // if(message == "Success") {
          //   if(mounted) context.go(RoutesName.homeScreen);
            
          //   // Future.delayed(Duration(seconds: 1),(){
          //   //   setState(() => isLoading = false);
          //   // }); 
          // } else {
          //   setState(() {
          //   isLoading = false;
          //   showErrorMessage = true;
          //   errorMessage = message;
          // });
          // }
        }
      }, 
      outlinedBorder: false,
      isLoading: isLoading,
      title: 'Sign In',
    );
  }

}