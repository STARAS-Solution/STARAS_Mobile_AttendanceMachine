import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:staras_checkin/constants/constant.dart';
import 'package:staras_checkin/view/enter_code.dart';

// Import the EnterCode page

class ListEmployee extends StatefulWidget {
  const ListEmployee({Key? key}) : super(key: key);

  @override
  _ListEmployeeState createState() => _ListEmployeeState();
}

class _ListEmployeeState extends State<ListEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kMainColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Padding(
          padding:
              EdgeInsets.only(left: 20.0), // Đặt khoảng cách bên trái là 20.0
          child: Text(
            'Check In',
            maxLines: 2,
            style: kTextStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              width: context.width(),
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                color: kBgColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Employee List',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Circular Avatar wrapped in GestureDetector
                  GestureDetector(
                      onTap: () {
                        // Navigate to EnterCode Page
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const EnterCode(),
                        ));
                      },
                      child: CircleAvatar(
                          radius: (52),
                          backgroundColor: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset("assets/images/emp1.png"),
                          ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
