import 'package:flutter/material.dart';

Size screenSize(BuildContext context) => MediaQuery.of(context).size;
double screenHeight(BuildContext context) => screenSize(context).height;
double screenWidth(BuildContext context) => screenSize(context).width;
bool isMobileLayout(BuildContext context) => screenSize(context).shortestSide < 600;