
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppbarBackButton extends StatelessWidget {
  const CustomAppbarBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 10),
      child: GestureDetector(
        onTap: (){
          context.pop();
        },
        child: const Icon(Icons.arrow_back_ios, size: 24,)),
    );
  }
}