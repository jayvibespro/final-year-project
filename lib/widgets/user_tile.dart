import 'package:finalyearproject/view/pages/user_chat/user_chat_page.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 30,
                child: Icon(
                  Icons.person,
                  size: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Mussa Hezron',
                      style: TextStyle(fontSize: 24),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'mussahezron112@gmail.com',
                        style: TextStyle(color: Colors.black54),
                      ),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserChatPage()),
        );
      },
    );
  }
}
