import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de Combustível',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
      ),
      home: FuelCalculator(),
    );
  }
}

class FuelCalculator extends StatefulWidget {
  @override
  _FuelCalculatorState createState() => _FuelCalculatorState();
}

class _FuelCalculatorState extends State<FuelCalculator> with SingleTickerProviderStateMixin {
  final _alcoolController = TextEditingController();
  final _gasolinaController = TextEditingController();
  String _resultMessage = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _calculate() {
    final precoAlcool = double.tryParse(_alcoolController.text);
    final precoGasolina = double.tryParse(_gasolinaController.text);

    if (precoAlcool == null || precoGasolina == null || precoGasolina == 0) {
      setState(() {
        _resultMessage = 'Por favor, insira valores válidos para os combustíveis.';
      });
      return;
    }

    final razao = precoAlcool / precoGasolina;

    setState(() {
      if (razao < 0.7) {
        _resultMessage = 'Abasteça com Álcool';
      } else {
        _resultMessage = 'Abasteça com Gasolina';
      }
    });
  }

  void _clear() {
    setState(() {
      _alcoolController.clear();
      _gasolinaController.clear();
      _resultMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Combustível'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  controller: _alcoolController,
                  decoration: InputDecoration(
                    labelText: 'Preço do Álcool',
                    prefixIcon: Icon(Icons.local_gas_station),
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _gasolinaController,
                  decoration: InputDecoration(
                    labelText: 'Preço da Gasolina',
                    prefixIcon: Icon(Icons.local_gas_station),
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.1),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _calculate,
                  child: Text('Calcular'),
                ),
                ElevatedButton(
                  onPressed: _clear,
                  child: Text('Limpar'),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            AnimatedOpacity(
              opacity: _resultMessage.isNotEmpty ? 1.0 : 0.0,
              duration: Duration(seconds: 1),
              child: Text(
                _resultMessage,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: _resultMessage.contains('Álcool') ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
