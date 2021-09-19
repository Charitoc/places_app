import 'package:flutter/material.dart';
import 'package:places_app/providers/great_places.dart';
import 'package:places_app/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';
import './add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Your Places'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              })
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: Center(
                  child: const Text('Got no places yet, start adding some!'),
                ),
                builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemBuilder: (ctx, i) => Container(
                          padding: EdgeInsets.all(8),
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              Card(
                                color: Theme.of(context).accentColor,
                                margin: EdgeInsets.only(left: 28),
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 28),
                                  title: Text(greatPlaces.items[i].title),
                                  subtitle: Text(
                                      greatPlaces.items[i].location.address),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        PlaceDetailScreen.routeName,
                                        arguments: greatPlaces.items[i].id);
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                alignment: FractionalOffset.centerLeft,
                                child: CircleAvatar(
                                  backgroundImage:
                                      FileImage(greatPlaces.items[i].image),
                                ),
                              ),
                            ],
                          ),
                        ),
                        itemCount: greatPlaces.items.length,
                      ),
              ),
      ),
    );
  }
}
