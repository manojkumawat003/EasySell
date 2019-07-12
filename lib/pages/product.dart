import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../widgets/products/fab.dart';

//import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_elements/title_default.dart';
import '../models/product.dart';
//import '../scoped-models/main.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  Widget _buildAddressPriceRow(double price) {
    return Column(
      //direction: Axis.horizontal,
      children: <Widget>[
        Text(
          product.location.address,
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
       Container(
          margin: EdgeInsets.all(5),
       ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(
            fontFamily: 'Oswald',
            color: Colors.deepPurple,
            decoration: TextDecoration.overline,
            decorationColor: Colors.deepOrange,
            decorationThickness: 2.0
           // backgroundColor: Colors.deepPurple,
          ),
          overflow: TextOverflow.clip,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(product.title),
        // ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 260.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(product.title),
                background: Hero(
                  tag: product.id,
                  child: FadeInImage(
                    image: NetworkImage(product.image),
                    height: 300.0,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/food.jpg'),
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: TitleDefault(product.title),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(color: Colors.amber),
                child: Text(product.userEmail),
              ),
              _buildAddressPriceRow(product.price),
              Divider(
                color: Colors.deepPurple,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(),
              Container(
                //  height: 100,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Developed by Manoj Kumawat',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ]))
          ],
        ),
        floatingActionButton: ProductFabButton(product),
      ),
    );
  }
}
