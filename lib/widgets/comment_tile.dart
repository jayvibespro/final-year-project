import 'package:finalyearproject/view/pages/single_chat/user_description_page.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Samia Hussein',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Mwananyamala, Dar Es Salaam',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    '12/05/2022, 12:09 PM',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const Icon(Icons.keyboard_arrow_right),
                ],
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                child: Text(
                    'comment goes here.Example, by doing this procedure we could really help out reaching the mothers in remote areas. I suggest we should give it a try.'),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserDescriptionPage()),
        );
      },
    );
  }
}
