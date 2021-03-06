import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokeapi/model/pokemon/pokemon.dart';
import 'package:pokeapi/pokeapi.dart';

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
          if (mounted)
            {
              setState(() => {
                    poke.types
                        .forEach((type) => {types.add(Text(type.type.name))}),
                    name = poke.name,
                  })
            }
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
