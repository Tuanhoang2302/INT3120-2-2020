import 'dart:ui';

import 'package:english_app/globles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatelessWidget {
  double iconsize;
  List<String> typeOfSignUp = [
    "Sign up with Google",
    "Sign up with Facebook",
    "Sign up with Email",
    "Sign up with Apple",
  ];

  List<String> image = [
    "assets/images/google-logo.png",
    "assets/images/Facebook_Logo.png",
    "assets/images/email-logo.png",
    "assets/images/apple-logo.png",
  ];
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    if(screenSize.height < 600) {
      iconsize = 23;
    } else if(screenSize.height >= 600 && screenSize.height <= 750) {
      iconsize = 32 ;
    } else if(screenSize.height > 750 && screenSize.height <= 850) {
      iconsize = 35;
    } else {
      iconsize = 38;
    }
    Map<String, HighlightedWord> words = {
      "Sign-in": HighlightedWord(
          onTap: () {
            print("Hello");
          },
          textStyle: TextStyle(
              color: Colors.red
          )

      )
    };
    HighlightMap highlightMap = HighlightMap(words);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new ExactAssetImage('assets/images/fb.jpg'),
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                fit: BoxFit.cover
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: screenSize.height / 5, left: 30 * ratio, right: 30 * ratio),
            child: Container(
              height: 365 * ratio,
              //color: Colors.grey,
              child: Column(
                children: [
                  Column(
                    children: [
                      Text("4English", style: TextStyle(
                        fontSize: 30 * ratio,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 8,),
                      Text("Create your account.", style: TextStyle(
                        fontSize: 16 * ratio
                      ),)
                    ],
                  ),

                  Flexible(
                    flex: 8,
                    fit: FlexFit.loose,
                    child: Container(
                      //margin: EdgeInsets.only(bottom: 8),
                      //color: Colors.green,
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 30),
                        itemCount: typeOfSignUp.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              if(index == 0) {
                                try {
                                  await _googleSignIn.signIn();
                                } catch (error) {
                                  print(error);
                                }
                              }
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(12, 8, 12 , 8),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          AspectRatio(
                                            child: Image.asset(image[index], fit: BoxFit.cover,),
                                            aspectRatio: 1/1,
                                          ),
                                          SizedBox(width: 12,),
                                          Text(typeOfSignUp[index], style: TextStyle(
                                            fontSize: 16 * ratio,
                                            fontWeight: FontWeight.bold
                                          ),)
                                        ],
                                      ),
                                      height: iconsize,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),

                  Flexible(
                    //fit: FlexFit.loose,
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      //color: Colors.red,
                        child: TextHighlight(
                          text: "Already have an account? Sign-in",
                          words: highlightMap.getMap,
                          textStyle: TextStyle(
                            fontSize: 14 * ratio,
                            color: Colors.black
                          ),
                          textAlign: TextAlign.justify
                        )
                    ),
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
