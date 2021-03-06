import 'package:flutter/material.dart';
import 'package:pokeapi/model/pokemon/pokemon.dart';
import 'package:pokeapi/pokeapi.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GalleryView extends StatefulWidget {
  GalleryView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  ScrollController scrollController;
  bool loading;
  List<GalleryItem> pokemonList;
  static const crossAxisCount = 3;
  static const loadCount = 2 * crossAxisCount * crossAxisCount;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController()..addListener(_scrollListener);
    pokemonList = [];
    loading = false;
    print(loadCount);
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
    if (!loading) {
      setState(() {
        loading = true;
        for (var i = 0; i < loadCount; i++) {
          pokemonList.add(GalleryItem(
            id: pokemonList.length + 1,
          ));
        }
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(pokemonList.length);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: GridView.builder(
            controller: scrollController,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount),
            itemCount: pokemonList.length,
            itemBuilder: (_, index) {
              return pokemonList[index];
            }));
  }
}

class GalleryItem extends StatefulWidget {
  GalleryItem({Key key, this.id}) : super(key: key);
  final int id;

  @override
  _GalleryItemState createState() => _GalleryItemState();
}

class _GalleryItemState extends State<GalleryItem> {
  Image image;
  List<Text> types;
  String name;

  @override
  void initState() {
    super.initState();
    types = [];
    name = "";
    PokeAPI.getObject<Pokemon>(widget.id).then((poke) => {
          setState(() => {
            poke.types.forEach((type) => {types.add(Text(type.type.name))}),
            name = poke.name,
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CachedNetworkImage(
        imageUrl:
            "https://pokeres.bastionbot.org/images/pokemon/${widget.id}.png",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ),
      Column(children: types),
      Align(
          alignment: FractionalOffset.bottomCenter,
          child: Text(name.toUpperCase(),
              style: TextStyle(
                  height: 5, fontSize: 15, fontWeight: FontWeight.bold)))
    ]);
  }
}
