import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive App'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1200) {
            return _buildExtraLargeLayout();
          } else if (constraints.maxWidth > 850) {
            return _buildLargeLayout();
          } else if (constraints.maxWidth > 400) {
            return _buildMediumLayout();
          } else {
            return _buildSmallLayout();
          }
        },
      ),
    );
  }

  Widget _buildExtraLargeLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            color: Colors.blue,
            height: 200,
            child: Center(
              child: Text('Element 1'),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.green,
            height: 200,
            child: Center(
              child: Text('Element 2'),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.red,
            height: 200,
            child: Center(
              child: Text('Element 3'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLargeLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                height: 200,
                child: Center(
                  child: Text('Element 1'),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green,
                height: 200,
                child: Center(
                  child: Text('Element 2'),
                ),
              ),
            ),
          ],
        ),
        Container(
          color: Colors.red,
          height: 200,
          child: Center(
            child: Text('Element 3'),
          ),
        ),
      ],
    );
  }

  Widget _buildMediumLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.blue,
          height: 200,
          child: Center(
            child: Text('Element 1'),
          ),
        ),
        Container(
          color: Colors.green,
          height: 200,
          child: Center(
            child: Text('Element 2'),
          ),
        ),
        Container(
          color: Colors.red,
          height: 200,
          child: Center(
            child: Text('Element 3'),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.blue,
          height: 200,
          child: Center(
            child: Text('Element 1'),
          ),
        ),
        Container(
          color: Colors.red,
          height: 200,
          child: Center(
            child: Text('Element 3'),
          ),
        ),
        Container(
          color: Colors.green,
          height: 200,
          child: Center(
            child: Text('Element 2'),
          ),
        ),
      ],
    );
  }
}
