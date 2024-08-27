import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MaterialApp(
    home: const WaterTrackerApp(),
    theme: ThemeData(
      primarySwatch: Colors.teal,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}


class WaterTrackerApp extends StatefulWidget {
  const WaterTrackerApp({super.key});

  @override
  State<WaterTrackerApp> createState() => _WaterTrackerAppState();
}

class _WaterTrackerAppState extends State<WaterTrackerApp> {
  // 用於記錄總喝水量
  int _totalAmount = 0;

  // 每種飲料的容量
  final Map<String, int> _beverageOptions = {
    '小杯水': 250,
    '大杯水': 500,
    '大杯咖啡': 500,
    '小杯咖啡': 250,
    '果汁': 300,
    '牛奶': 200,
    '茶': 150,
    '汽水': 330,
    '啤酒': 500,
    '能量飲料': 250,
    '運動飲料': 400,
    '綠茶': 250,
    '豆漿': 200,
    '冰沙': 350,
    '冰咖啡': 300,
    '奶昔': 300,
    // 可以添加更多飲料選項
  };

  @override
  void initState() {
    super.initState();
    _loadTotalAmount();
  }

  // 從 SharedPreferences 讀取總喝水量
  void _loadTotalAmount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalAmount = prefs.getInt('totalAmount') ?? 0;
    });
  }

  // 儲存總喝水量到 SharedPreferences
  void _saveTotalAmount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalAmount', _totalAmount);
  }

  // 更新總喝水量
  void _addAmount(int amount) {
    setState(() {
      _totalAmount += amount;
      _saveTotalAmount(); // 更新 SharedPreferences
    });
  }

  // 重置總喝水量
  void _resetAmount() {
    setState(() {
      _totalAmount = 0;
      _saveTotalAmount(); // 更新 SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('今日喝水量紀錄', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 顯示總喝水量
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '總喝水量: $_totalAmount cc',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          // 顯示各種飲料容量按鈕 (使用 GridView)
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 每行顯示2個按鈕
                crossAxisSpacing: 12.0, // 每行按鈕之間的水平間距
                mainAxisSpacing: 12.0, // 每列按鈕之間的垂直間距
              ),
              padding: const EdgeInsets.all(8.0),
              itemCount: _beverageOptions.length,
              itemBuilder: (context, index) {
                final beverageName = _beverageOptions.keys.elementAt(index);
                final beverageAmount = _beverageOptions.values.elementAt(index);

                return Card(
                  elevation: 5, // 添加陰影效果
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 圓角
                  ),
                  child: InkWell(
                    onTap: () => _addAmount(beverageAmount),
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '$beverageName\n${beverageAmount}cc',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // 歸零按鈕
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _resetAmount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // 按鈕顏色
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: const Text('重置水量',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
