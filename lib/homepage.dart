import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/Homescreen.dart';
class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
   Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body:  Container(
        width: size.width,
        height: size.height,
        color: Color(0xff9faac3),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('images/get-started.png'),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> WeatherPage()));
                },
                child: Container(
                  height: 50,
                  width: size.width* 0.7,
                  child: Center(child: Text('Get Started',style: TextStyle(fontSize: 20),)),
                  decoration: BoxDecoration(
                    color: Color(0xffe3e8e4),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

