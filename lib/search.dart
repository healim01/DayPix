import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daypix/detail.dart';
import 'package:daypix/home.dart';
import 'package:daypix/profile.dart';
import 'package:daypix/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}
// TODO :search 에서 결과 보여줄 때, 글씨 bold, black, text만 키우기
// TODO :search 에서 원하는 결과 제대로 보여주기 

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  Future<void> _getPostsBySearchTerm(String searchTerm, UserModel user) async {
    print(searchTerm);
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(user.uid)
          .where('text', isEqualTo: searchTerm)
          .get();
      
      setState(() {
        _searchResults = querySnapshot.docs;
        print(_searchResults);
      });
    } catch (e) {
      print('데이터 가져오기 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                semanticLabel: 'arrow_back',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                    settings: RouteSettings(
                      arguments: user
                    ),
                  ),
                );
              },
            );
          },
        ),
        centerTitle: true,
        title: const Text('Daypix'),        
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a search text',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 3, 0, 181),
                        ),
                      ),
                      // filled: true,
                      // fillColor: Color.fromARGB(255, 191, 203, 231), // 배경색을 변경하려면 여기에 지정하세요
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  final String searchTerm = _searchController.text.trim();
                  if (searchTerm.isNotEmpty) {
                    _getPostsBySearchTerm(searchTerm, user);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot document = _searchResults[index];
                      final data = document.data() as Map<String, dynamic>;
                      final String docID = document.id;
                      final String img = data['img'];
                      final String text = data['text'];
                      final String emoji = data['emoji'];
                      final String date = data['date'];

                      return Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              print("detail page let's go~");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(uID: user.uid, docID: docID),
                                  settings: RouteSettings(arguments: user),
                                ),
                              );
                            },
                            child: Image.network(img),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 3, 0, 181),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Image.asset(
                              "assets/emoji/$emoji.png",
                              width: 30,
                              color: Color.fromARGB(255, 3, 0, 181),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Text(
                              date,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 3, 0, 181),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : 
                Column(
                  children :[
                    const SizedBox(height: 100),
                    Center(
                      child: ClipOval(
                        child: Lottie.network(
                          'https://assets7.lottiefiles.com/packages/lf20_MrIjH2.json',
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        '결과가 없습니다.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}
