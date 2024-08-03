import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livotj/components/navigator.dart';
import 'package:livotj/pages/login_s1.dart';
import 'package:livotj/utilities/constant.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  var phone;
  var code;
  RegistrationPage({super.key, this.phone = "", this.code = ""});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {


  


  Future<void> registrationMethod(BuildContext context) async {
    var response = await http.post(
      Uri.parse('https://test.api.navbat.tj/api/client/v1/auth/register'),
      headers: <String, String>{
        "Accept": 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'phone': widget.phone,
        'code': widget.code,
        'name': nameContoroller.text,
        'surname': familContoroller.text,
      }),
    );
    if (response.statusCode == 200) {
       var token = jsonDecode(response.body)['accessToken'];
      await storage.write(key: 'token', value: token);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavigatorPage()));
    }
  }

  TextEditingController nameContoroller = TextEditingController();
  TextEditingController familContoroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 90,
                ),
                Text(
                  "Регистрация",
                  style: LoginFirstText,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Зарегистрируйтесь для дальнейшей ",
                  style: LoginSecondText,
                ),
                Text("работы с нами", style: LoginSecondText),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Имя",
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
                            SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: 250,
                              child: TextField(
                                controller: nameContoroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Введите имя ',
                                    hintStyle: InputTextField),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Фамилия",
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
                            SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: 250,
                              child: TextField(
                                controller: familContoroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Введите фамилию ',
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
                  height: 35,
                ),
                Text(
                  "Уже есть аккаунт",
                  style: LoginSecondText,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route) => false);
                    },
                    child: Text(
                      "Войти",
                      style: RegisterText,
                    )),
              ],
            ),
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
                          width: 1, color: Color.fromRGBO(164, 175, 189, 1)),
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
                            color: Color.fromRGBO(30, 49, 72, 1)),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromRGBO(238, 111, 66, 1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (widget.phone == "" || widget.code == "") {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage(
                                        name: nameContoroller.text,
                                        surname: familContoroller.text,
                                      )),
                              (Route) => false);
                        } else {
                          registrationMethod(context);
                        }
                      },
                      child: Text(
                        'Сохранить',
                        style: RegisterText.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
