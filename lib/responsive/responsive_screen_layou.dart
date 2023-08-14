import 'package:flutter/material.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/utils/Global_var.dart';
import 'package:provider/provider.dart';

class ResponsiveSreen extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveSreen({super.key,required this.webScreenLayout,required this.mobileScreenLayout});

  @override
  State<ResponsiveSreen> createState() => _ResponsiveSreenState();
}

class _ResponsiveSreenState extends State<ResponsiveSreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }


  addData()async{
    UserProvider _userProvider=Provider.of(context,listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (Context,Constraints) {
        if(Constraints.maxWidth >webScreenSize){
          return widget.webScreenLayout;
        }else {
          return widget.mobileScreenLayout;
        }
      },
    );
  }
}
