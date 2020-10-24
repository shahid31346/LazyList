import 'package:flutter/material.dart';

class LazyListSingle extends StatelessWidget {
  final int id;
  final String name;

  LazyListSingle({
    Key key,
    this.id,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Text('$id'),
            
            ),
            title: Text(name),
           
            onTap: () {},
          ),
          Divider(),
        ],
      ),
    );
  }
}
