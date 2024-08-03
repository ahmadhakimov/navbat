import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livotj/pages/login_s2.dart';
import 'package:livotj/utilities/constant.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  var name;
  var surname;
  LoginPage({super.key, this.name = "", this.surname = ""});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  bool loginOrRegister = false;

  var phoneController = TextEditingController();
  var errorMess = '';
  String errorTextField = '';

  Future<void> sendCodeMethod(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.post(
        Uri.parse('https://test.api.navbat.tj/api/client/v1/auth/send-code'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "phone": phoneController.text.replaceAll(' ', '').trim(),
          },
        ),
      );

      
      
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPageS2(
                      phone: phoneController.text,
                      name: widget.name,
                      surname: widget.surname,
                    )));
         
      } else {
        setState(() {
          var responseData = jsonDecode(response.body);
          var errors = responseData[''];

          if (errors != null) {
            var verificationErrors = errors;
            errorMess =
                verificationErrors; 

          } else {
            errorMess = '';
          }
        });
      }
    } 
    
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error : ${e}'),
          backgroundColor: Colors.red,
        ),
      );
    }
    finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children:[ Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Text(
                  loginOrRegister ?  "Регистрация" : "Войти",
                  style: LoginFirstText,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Войдите в систему для",
                  style: LoginSecondText,
                ),
                Text("дальнейшей работы с нами", style: LoginSecondText),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Нормер телефона *",
                        style: TopTextfield,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "     +992     ",
                              style: InputTextField.copyWith(
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 250,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
                                      errorTextField = 'Do not use Alphabet';
                                    } else
                                      errorTextField = '';
                                  });
                                },
                                controller: phoneController,
                                decoration: InputDecoration(
                                    errorText: errorTextField.isEmpty
                                        ? null
                                        : errorTextField,
                                    border: InputBorder.none,
                                    hintText: 'Введите нормер телефона ',
                                    hintStyle: InputTextField),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "У вас нет аккаунта?",
                  style: LoginSecondText,
                ),
                GestureDetector(
                    onTap: () {
                     setState(() {
                       loginOrRegister = !loginOrRegister;
                     });
                    },
                    child: Text(
                    loginOrRegister ?  "Войти" : "Регистрация",  
                      style: RegisterText,
                    )),
              ],
            ),
          ),
          bottomSheet: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            height: 120,
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromRGBO(238, 111, 66, 1),
                    ),
                    child: TextButton(
                        onPressed: () {
                          sendCodeMethod(context);
                        },
                        child: Text(
                          'Далее',
                          style: RegisterText.copyWith(color: Colors.white),
                        ))),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(238, 111, 66, 1),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(238, 111, 66, 0.12),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        if (isLoading)
        Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Container(
              height: 78,
              width: 78,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(238, 111, 66, 1)),
                backgroundColor: Color.fromRGBO(238, 111, 66, 0.25),
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
