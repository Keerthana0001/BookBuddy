import 'package:bookbuddy/auth/services/auth.dart';
import 'package:bookbuddy/drawer.dart';
import 'package:bookbuddy/models/error_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => HomeState();
}

class _Heading extends StatefulWidget {
  const _Heading({
    Key? key,
  }) : super(key: key);

  @override
  State<_Heading> createState() => _HeadingState();
}
var search = "";
class _HeadingState extends State<_Heading> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    var stream = FirebaseFirestore.instance.collection('Books').snapshots();
    
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BookBuddy',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 20),
          TextFormField(
            // controller: _controller,
            onChanged: (val) {
              setState(() {
                
                search = val;
                print("Search " +search);
              });
            },
            decoration: InputDecoration(
              hintText: 'Search',
              filled: true,
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: ((context, index) {
                    var data = snapshot.data?.docs[index];
                    Map<String, dynamic> dataMap =
                        data!.data() as Map<String, dynamic>;
                    if (data['title']
                        .toString()
                        .toLowerCase()
                        .contains(search.toLowerCase().trim()) || 
                        
                        data['author']
                        .toString()
                        .toLowerCase()
                        .contains(search.toLowerCase().trim())) {
                      print('Search is' + search);
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Image.network(
                                  data['imageUrl'],
                                  width: 100,
                                  height: 80,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        data["title"],
                                        maxLines: 2,
                                        overflow: TextOverflow.clip,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        data['author'],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }),
                );
              }),
        ],
      ),
    );
  }
}

class HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    return Scaffold(
      key: _key,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            _key.currentState!.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: [const _Heading()],
      ),
    );
  }
}
