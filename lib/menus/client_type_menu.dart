import 'package:flutter/material.dart';

class ClientTypeMenu extends StatelessWidget {
  final Function(String k) updateParent;
  const ClientTypeMenu({
    this.updateParent,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton.icon(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.red, width: 3)),
                onPressed: () {
                  updateParent("קיבוץ");
                },
                icon: Icon(Icons.home, size: 30.0),
                label: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("קיבוצים", style: TextStyle(fontSize: 24.0)),
                ),
              ),
              FlatButton.icon(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.red, width: 3)),
                onPressed: () {
                  updateParent("פרוייקט");
                },
                icon: Icon(Icons.group_work, size: 30.0),
                label: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("פרוייקטים", style: TextStyle(fontSize: 24.0)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton.icon(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.red, width: 3)),
                onPressed: () {
                  updateParent("חברה");
                },
                icon: Icon(Icons.devices_other, size: 30.0),
                label: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("חברות", style: TextStyle(fontSize: 24.0)),
                ),
              ),
              FlatButton.icon(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.red, width: 3)),
                onPressed: () {
                  updateParent("אחר");
                },
                icon: Icon(Icons.search, size: 30.0),
                label: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("אחר", style: TextStyle(fontSize: 24.0)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
