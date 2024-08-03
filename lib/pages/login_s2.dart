import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:livotj/components/navigator.dart';
import 'package:livotj/pages/login_s1.dart';
import 'package:livotj/pages/registration_Page.dart';
import 'package:livotj/utilities/constant.dart';
import 'dart:developer' as developer;

class LoginPageS2 extends StatefulWidget {
  var phone;
  var name;
  var surname;
  LoginPageS2(
      {super.key,
      required this.phone,
      required this.name,
      required this.surname});

  @override
  State<LoginPageS2> createState() => _LoginPageS2State();
}

class _LoginPageS2State extends State<LoginPageS2> {
  bool isLoading = false;
  var codeController = TextEditingController();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> registrationMethod(BuildContext context) async {
    var response = await http.post(
      Uri.parse('https://test.api.navbat.tj/api/client/v1/auth/register'),
      headers: <String, String>{
        "Accept": 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'phone': widget.phone,
        'code': codeController.text.replaceAll(' ', '').trim(),
        'name': widget.name,
        'surname': widget.surname,
      }),
    );
    if (response.statusCode == 200) {
      
      var token = jsonDecode(response.body)['accessToken'];
      await storage.write(key: 'token', value: token);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const NavigatorPage()));
    }
  }

  Future<void> confirmCode(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post(
      Uri.parse('https://test.api.navbat.tj/api/client/v1/auth/confirm-code'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'phone': widget.phone,
          'code': codeController.text.replaceAll(' ', '').trim(),
        },
      ),
    );
    if (response.statusCode == 200) {
      var token = jsonDecode(response.body)['accessToken'];
      await storage.write(key: 'token', value: token);
      token == null || token == 'null'
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegistrationPage(
                        phone: widget.phone,
                        code: codeController.text,
                      )))
          : Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const NavigatorPage()));
    }
  }


  Future<void> sendCodeMethod(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.post(
        Uri.parse('https://test.api.navbat.tj/api/client/v1/auth/send-code'),
        headers: <String, String>{
          "Accept": 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "phone": widget.phone,
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading=false;
        });
               
        
      } else {
        setState(() {
          var responseData = jsonDecode(response.body);
          var errors = responseData[''];

          
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error : ${e}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }







  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _connectionStatus[0].name == 'none'
                  ? Container(
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(254, 242, 242, 1),
                          borderRadius: BorderRadius.circular(5)),
                      margin: const EdgeInsets.only(top: 50),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: const Color.fromRGBO(248, 113, 113, 1)),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Отсутствует подключение к интернету",
                              style: ErorrInternet,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 60,
              ),
              Text(
                "Код подтверждения",
                style: LoginFirstText,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Мы отправили код подтверждения на ваш ",
                style: LoginSecondText,
              ),
              Text("номер телефона", style: LoginSecondText),
              const SizedBox(
                height: 50,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Код подверждения",
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
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 250,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: codeController,
                              decoration: InputDecoration(
                                
                                  border: InputBorder.none,
                                  hintText: 'Введите Код подверждения ',
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
              GestureDetector(
                onTap: () {
                
                    sendCodeMethod(context);
                  
                },
                child: Text(
                  "Отправить SMS код повторно",
                  style: RegisterText,
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          height: 120,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 1, color: const Color.fromRGBO(164, 175, 189, 1)),
                      color: Colors.white,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (Route) => false);
                      },
                      child: Text(
                        'Назад',
                        style: RegisterText.copyWith(
                            color: const Color.fromRGBO(30, 49, 72, 1)),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromRGBO(238, 111, 66, 1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (widget.surname == "" && widget.name == "") {
                          confirmCode(context);
                        } else {
                          registrationMethod(context);
                        }
                      },
                      child: Text(
                        'Далее',
                        style: RegisterText.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
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
                      color: Color.fromRGBO(238, 111, 66, 0.12),
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
                      color: Color.fromRGBO(238, 111, 66, 1),
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





    ]);
  }
}
