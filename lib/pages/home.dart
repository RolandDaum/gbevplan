import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  final Widget child;

  const Home({super.key, required this.child});

  @override
  State<Home> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widget.child,
            MaterialButton(onPressed: () {
              context.push('/');
              
            },
              child: Text('MAIN SIDE'),
              color: Colors.grey,
            ),
          ],
        )    
      ),
    );
  }

}