import 'package:flutter/material.dart';
import 'package:flutter_first_app/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

import 'package:url_launcher/url_launcher.dart';

class ProductFabButton extends StatefulWidget {
  final Product product;

  ProductFabButton(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFabButton();
  }
}

class _ProductFabButton extends State<ProductFabButton>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  void _contact() async {
    final url = 'mailto:${widget.product.userEmail}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: FloatingActionButton(
              heroTag: 'Fav',
              mini: true,
              child: Icon(
                model.selectedProduct.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () {
                model.toggleProductFavoriteStatus();
              },
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          SlideTransition(
              transformHitTests: true,
              position: Tween(begin: Offset(-10, 0), end: Offset(0, 0))
                  .animate(_controller),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //   Text(widget.product.userEmail),
                  FloatingActionButton(
                    heroTag: 'Mail',
                    mini: true,
                    child: Icon(Icons.mail),
                    onPressed: () {
                      _contact();
                    },
                  ),
                ],
              )),
          SizedBox(
            height: 5.0,
          ),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 10.25).animate(_controller),
            child: FloatingActionButton(
              heroTag: 'More',
              mini: true,
              child: Icon(Icons.more),
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            ),
          ),
        ],
      );
    });
  }
}
