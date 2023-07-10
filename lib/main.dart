import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Recipe {
  final String title;
  final String description;
  final List<String> ingredients;

  Recipe({
    required this.title,
    required this.description,
    required this.ingredients,
  });
}



void main() {
  runApp(MaterialApp(
    home: RecipeListView(),
  ));
}
class RecipeListView extends StatefulWidget {
  @override
  _RecipeListViewState createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    String jsonString = await rootBundle.loadString('assets/api/recipes.json');
    print(jsonString);
    var jsonData = json.decode(jsonString);
    print(jsonData);
    List<dynamic> recipeData = jsonData['recipes'];
    List<Recipe> recipes = [];
    for (var item in recipeData) {
      Recipe recipe = Recipe(
        title: item['title'],
        description: item['description'],
        ingredients: List<String>.from(item['ingredients']),
      );
      recipes.add(recipe);
    }
    setState(() {
      _recipes = recipes;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
      ),
      body: ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_recipes[index].title),
            onTap: () {
              // Handle recipe item tap
            },
          );
        },
      ),
    );
  }
}
