import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'main-1.dart';


var _count1 = 1;
var waterlevel2 = 0;
var url1 = Uri.parse('http://192.168.200.139:5000/dehumi_post'); // 수분 정보 보내는 주소


Future<Info> fetchInfo() async {
  var url2 = '/recive_data';    // 수분 정보 받을 데이터

  final response = await http.get(Uri.parse(url2));

  if (response.statusCode == 200) {
    //만약 서버가 ok응답을 반환하면, json을 파싱합니다
    print('응답했다');
    print(json.decode(response.body));
    return Info.fromJson(json.decode(response.body));
  } else {
    //만약 응답이 ok가 아니면 에러를 던집니다.
    throw Exception('정보를 불러오는데 실패했습니다.');
  }
}

class Info {
  final int temperature;
  final int humidity;
  final int waterlevel;
  final int state;

  Info({required this.temperature,
    required this.humidity,
    required this.waterlevel,
    required this.state});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      temperature: json["temperature"],
      humidity: json["humidity"],
      waterlevel: json["waterlevel"],
      state: json["state"],
    );
  }
}

void main() async {
  runApp(InfoPage());
}

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Future<Info>? info;

  @override
  void initState() {
    super.initState();
    info = fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('제습기 관리', style: TextStyle(color: Colors.white)),
              centerTitle: true,
            ),
            body: Center(
              child: FutureBuilder<Info>(
                //통신데이터 가져오기
                future: info,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return buildColumn(snapshot);
                  } else if (snapshot.hasError) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text("연결 실패 에러!!",
                        style: TextStyle(fontSize: 25)),

                  SizedBox(height: 50),

                  ElevatedButton(
                  onPressed: () {
                  varCount1();
                  _callAPI();
                  },
                  child: Text('ON')),
                  SizedBox(height: 10),

                  ElevatedButton(
                  onPressed: () {
                  varCount1();
                  _callAPI2();
                  },
                  child: Text('OFF')),
                  SizedBox(height: 10),

                  ElevatedButton(
                  onPressed: () {
                  varCount1();
                  _callAPI3();
                  },
                  child: Text('AUTO')),
                  SizedBox(height: 10),

                  RaisedButton(
                  child: Text('방향제 페이지로 이동'),
                  onPressed: () {
                  // 눌렀을 때 두 번째 방향제 페이지로 이동합니다.
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => dehmuipage())
                  );

                  }
                  ),

                  ]
                    );
                  }

                  return CircularProgressIndicator();
                },
              ),
            )));
  }

  Widget buildColumn(snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("제습기 상황", style: TextStyle(fontSize: 25)),
        Text('온도:' + snapshot.data!.temperature.toString() + '도',
            style: TextStyle(fontSize: 15)),
        Text('습도:' + snapshot.data!.humidity.toString(),
            style: TextStyle(fontSize: 15)),

        Text('수위:' + snapshot.data!.waterlevel.toString() +
            '     1일 경우 물을 버려주세요',
            style: TextStyle(fontSize: 15)),

        Text('상태:' + snapshot.data!.state.toString(),
            style: TextStyle(fontSize: 15)),
        ElevatedButton(
            onPressed: () {
              varCount1();
              _callAPI();
            },
            child: Text('ON')),
        SizedBox(height: 10),
        ElevatedButton(
            onPressed: () {
              varCount1();
              _callAPI2();
            },
            child: Text('OFF')),
        SizedBox(height: 10),
        ElevatedButton(
            onPressed: () {
              varCount1();
              _callAPI3();
            },
            child: Text('AUTO')),
        SizedBox(height: 10),
      ],
    );
  }

  void varCount1() {
    if (_count1 == 1) {
      _count1 = 2;
    } else {
      _count1 = 1;
    }
  }

  void _callAPI() async {
    await http.post(url1, body: {'inst': 'ON', 'state': '$_count1'});
  }

  void _callAPI2() async {
    await http.post(url1, body: {'inst': 'OFF', 'state': '$_count1'});
  }

  void _callAPI3() async {
    await http.post(url1, body: {'inst': 'AUTO', 'state': '$_count1'});
  }
}
