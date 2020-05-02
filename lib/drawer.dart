import 'package:f_fitness_concepts_admin/comment/commentList.dart';
import 'package:f_fitness_concepts_admin/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  DrawerMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {
      return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            /*
            UserAccountsDrawerHeader(
              accountName: Text(
                "",
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/drawerBackground.jpg"),
                      fit: BoxFit.cover)),
              /*accountEmail: Text(
                '${loginUser.userName}',
                style: TextStyle(fontSize: 20.0),
              ),*/

              accountEmail: Text(
                //memberName,
                memberName,
                style: TextStyle(fontSize: 20.0),
              ),
              /*
                accountEmail: ScopedModelDescendant<LoginUserModel>(
                builder: (context, child, loginUser) => Text(
                  '${loginUser.userName}',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
                 */
              currentAccountPicture: CircleAvatar(
                radius: 30,
                backgroundImage: MemoryImage(base64Decode(memberPhoto)),
              ),
            ),
             */

            ListTile(
              leading: Icon(
                MyFlutterApp.comment,
                size: 20,
              ),
              title: Text(
                "Comment Trainer",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminCommentList()));
              },
            ),
            /*ListTile(
              leading: Icon(
                MyFlutterApp.key,
                size: 20,
              ),
              title: Text(
                'Change My Password',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                MyFlutterApp.logout,
                size: 20,
              ),
              title: Text(
                'LogOut',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text(
                            'Do you really want to logout of this app? You will have to log in again next time.'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('No'),
                          ),
                          FlatButton(
                            onPressed: () {
                              _logout();
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    });
              },
            ),*/
          ],
        ),
      );
    }
  }
}
