import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'cons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecipeListWidget(),
    );
  }
}


class RecipeService {
  static Future<List<Recipe>> fetchRecipes() async {
    String jsonString = await rootBundle.loadString('assets/api/recipes.json');
    final List<dynamic> jsonList = json.decode(jsonString)['recipes'];
    return jsonList.map((json) => Recipe.fromJson(json)).toList();
  }
}

class RecipeListWidget extends StatefulWidget {
  @override
  _RecipeListWidgetState createState() => _RecipeListWidgetState();
}

class _RecipeListWidgetState extends State<RecipeListWidget> {
  late Future<List<Recipe>> _recipeListFuture;

  @override
  void initState() {
    super.initState();
    _recipeListFuture = RecipeService.fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _recipeListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final recipeList = snapshot.data;
            return ListView.builder(
              itemCount: recipeList!.length,
              itemBuilder: (context, index) {
                final recipe = recipeList[index];
                return ListTile(
                  title: Text(recipe.title),
                  subtitle: Text(recipe.description),
                  onTap: () {
                    // Handle recipe item tap
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}