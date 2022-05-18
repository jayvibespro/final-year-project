import 'package:finalyearproject/view/pages/posts/comments_page.dart';
import 'package:flutter/material.dart';

class PostContainer extends StatefulWidget {
  const PostContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  int counter = 120;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFF7F9F9),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${counter}',
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isLiked == false) {
                                counter++;
                                isLiked = true;
                              } else if (isLiked == true) {
                                counter--;
                                isLiked = false;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.thumb_up,
                            color: isLiked ? Colors.black54 : Colors.green[300],
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       counter--;
                        //     });
                        //   },
                        //   icon: const Icon(
                        //     Icons.thumb_down,
                        //     color: Colors.black54,
                        //   ),
                        // ),
                      ],
                    ),
                    const Text('Juma Khan'),
                    const Text('Dodoma Center'),
                    const Icon(Icons.person)
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Divider(),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                    "If you're looking for random paragraphs, you've come to the right place. When a random word or a random sentence isn't quite enough, the next logical step is to find a random paragraph. We created the Random Paragraph Generator with you in mind. The process is quite simple. Choose the number of random paragraphs you'd like to see and click the button. Your chosen number of paragraphs will instantly appear"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text("12/07/2022, 10:12 PM"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text("Comments: 123"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CommentsPage()),
        );
      },
    );
  }
}
