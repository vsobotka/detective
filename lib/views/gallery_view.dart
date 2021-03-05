import 'package:flutter/material.dart';
import 'package:pokeapi/model/pokemon/pokemon.dart';
import 'package:pokeapi/pokeapi.dart';

class GalleryView extends StatefulWidget {
  GalleryView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  ScrollController scrollController;
  List<Pokemon> pokemonList;
  bool loading;
  static const crossAxisCount = 3;
  static const loadCount = 2 * crossAxisCount * crossAxisCount;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController()..addListener(_scrollListener);
    pokemonList = [];
    loading = false;
    _loadMorePokemon();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    print(scrollController.position.extentAfter);
    if (scrollController.position.extentAfter < 500) {
      _loadMorePokemon();
    }
  }

  void _loadMorePokemon() {
    _loadPokemon(pokemonList.length + 1, loadCount);
  }

  void _loadPokemon(int offset, int limit) {
    if (!loading) {
        loading = true;
      PokeAPI.getObjectList<Pokemon>(offset, limit).then((poke) => {
            setState(() => {pokemonList.addAll(poke), loading = false })
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: GridView.builder(
            controller: scrollController,
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount),
            itemCount: pokemonList.length,
            itemBuilder: (_, index) {
              List<Widget> types = [];
              var pokemonImg = Image.network(
                  "https://pokeres.bastionbot.org/images/pokemon/${pokemonList[index].id}.png",
                  fit: BoxFit.cover);
              for (var i = 0; i < pokemonList[index].types.length; i++) {
                var type = pokemonList[index].types[i].type.name;
                types.add(Text(type));
              }
              return Stack(children: [
                pokemonImg,
                Column(children: types),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Text(pokemonList[index].name.toUpperCase(),
                        style: TextStyle(
                            height: 5,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)))
              ]);
            }));
  }
}