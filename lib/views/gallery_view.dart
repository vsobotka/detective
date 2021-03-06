import 'package:flutter/material.dart';

import 'widgets/gallery_item.dart';

class GalleryView extends StatefulWidget {
  GalleryView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  ScrollController scrollController;
  bool loading;
  List<GalleryItem> galleryItemList;
  static const crossAxisCount = 3;
  static const loadCount = 2 * crossAxisCount * crossAxisCount;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController()..addListener(_scrollListener);
    galleryItemList = [];
    loading = false;
    _loadMoreItems();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter < 500) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    if (!loading) {
      setState(() {
        loading = true;
        for (var i = 0; i < loadCount; i++) {
          galleryItemList.add(GalleryItem(
            id: galleryItemList.length + 1,
          ));
        }
        loading = false;
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount),
            itemCount: galleryItemList.length,
            itemBuilder: (_, index) {
              return galleryItemList[index];
            }));
  }
}
