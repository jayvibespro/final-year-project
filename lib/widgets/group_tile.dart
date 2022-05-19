import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 0, 32, 32),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(143, 148, 251, 0.5),
                blurRadius: 5.0,
                offset: Offset(2, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.group,
                  size: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Majamaa Wauguzi',
                      style: TextStyle(fontSize: 32),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text('Description goes here...brah brah brah...'),
                    )
                  ],
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Icon(Icons.east_rounded),
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) =>  GroupChatPage()),
        // );
      },
    );
  }
}
