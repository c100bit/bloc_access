import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/counter_bloc.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: _router.onGenerateRoute,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}

class AppRouter {
  final _counterBloc = CounterBloc();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/counter':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _counterBloc,
            child: CounterPage(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _counterBloc,
            child: HomePage(),
          ),
        );
    }
  }

  void dispose() {
    _counterBloc.close();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed('/counter'),
          child: const Text('Counter'),
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              heroTag: 0,
              child: const Icon(Icons.add),
              onPressed: () {
                counterBloc.add(CounterIncrementPressed());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              heroTag: 1,
              child: const Icon(Icons.remove),
              onPressed: () {
                counterBloc.add(CounterDecrementPressed());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
      ),
      body: BlocBuilder<CounterBloc, int>(
        builder: (context, count) {
          return Center(
            child: Text('$count'),
          );
        },
      ),
    );
  }
}
