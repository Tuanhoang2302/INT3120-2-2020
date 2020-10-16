import 'package:english_app/Screens/Account/Login.dart';
import 'package:english_app/globles.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  _loginButtonArea() {
    return Container(
      height: 150 * ratio,
      color: Colors.grey[200],
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Login()
                ));
              },
              child: Card(
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                        size: 50 * ratio,
                      ),
                      SizedBox(width: 12,),
                      Text("Login", style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18 * ratio,
                        fontWeight: FontWeight.bold
                      ),),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: iconSize * ratio,
                        color: Colors.grey,)
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text("Settings", style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18 * ratio
              ),),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _loginButtonArea()
        ],
      )
    );
  }
}
