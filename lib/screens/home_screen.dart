import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'dart:math' as math;

import '../models/movie.dart';
import '../providers/movies_provider.dart';


 

class HomeScreen extends StatefulWidget { 
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textFieldFocusNode = FocusNode();
  final textEditingController = TextEditingController();
  late MoviesProvider moviesProvider;
  String query = '';

  @override
  void initState() {
    moviesProvider = Provider.of<MoviesProvider>(context, listen: false); 
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.clear();
    moviesProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        backgroundColor: const Color(0xFF0F0F0F),
        body: SingleChildScrollView( 
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2C),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextField(
                            onChanged: (value) {
                              debugPrint('jean: On Changed. value: $value');
                              query = value;
                              if(value.isNotEmpty) moviesProvider.getSuggestionsByQuery(value);
                              setState(() {});
                            },
                            controller: textEditingController,
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            focusNode: textFieldFocusNode,
                            style: const TextStyle(color: Color(0xFF96969D)),
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(color: Color(0xFF96969D)),
                              constraints: BoxConstraints(minWidth: 150, maxWidth: MediaQuery.of(context).size.width - 70),
                              prefixIcon: const Icon(Icons.search),
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintText: 'Select an Admin',
                              suffixIcon: Transform.rotate(
                                angle: math.pi / 4,
                                child: IconButton(
                                  icon: const Icon(Icons.add_circle), onPressed: () { 
                                    query = '';
                                    textEditingController.clear();
                                    FocusScope.of(context).unfocus();
                                    setState(() {});
                                  },
                                )
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          query = '';
                          textEditingController.clear();
                          FocusScope.of(context).unfocus();
                          setState(() {});
                        },
                        child: const Text( 
                          'Cancel', 
                          style: TextStyle(
                            color: Color(0xFF185093), 
                            fontSize: 17, 
                            fontWeight: FontWeight.bold
                          ), 
                        )
                      )
                    ],
                  ), 
                ), 
                if(query.isEmpty) _emptyContainer(context),
                if(query.isNotEmpty) GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  onTapUp: (_) => FocusScope.of(context).unfocus(),
                  onTapDown: (_) => FocusScope.of(context).unfocus(),
                  onVerticalDragStart: (details) =>  FocusScope.of(context).unfocus(),
                  child: Container( 
                    height: MediaQuery.of(context).size.height - 160,
                    padding: const EdgeInsets.only(top: 10),
                    child: StreamBuilder( 
                      stream: moviesProvider.suggestionStream, 
                      builder: ( _ , AsyncSnapshot<List<Movie>> snapshot){  
                        if(!snapshot.hasData) return _emptyContainer(context);  
                        final movies = snapshot.data; 
                        return ListView.builder(
                          itemCount: movies!.length,
                          itemExtent: 90,
                          itemBuilder: ( _, int index) => _MovieItem(movie: movies[index])
                        ); 
                      },
                    ),
                  ),
                )
              ],
            ),
          ), 
        )
      ),
    );
  }
}


class CustomAppBar extends StatelessWidget with PreferredSizeWidget{
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF000000), 
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  // Navigator.pop(context);
                },
              ),
              const Expanded(child: Text('Add an Admin', textAlign: TextAlign.center, style: TextStyle(fontSize: 25))),
              const Icon(Icons.handshake, size: 35)
            ],
          ),
        ],
      ),
      elevation: 0,
    );
  }
}


Widget _emptyContainer(context) {
  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Container(
      color: const Color(0xFF0F0F0F),
      height: MediaQuery.of(context).size.height - 156,
      child: const Center(
        child: Icon(Icons.handshake, color: Color(0xFFFFFFFF), size: 130),
      ),
    ),
  );
}
                  

class _MovieItem extends StatelessWidget {

  final Movie movie; 
   
  const _MovieItem({
    Key? key, 
    required this.movie
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {  
    return Container(
      color: const Color(0xFF0F0F0F), 
      child: ListTile( 
        horizontalTitleGap: 10, 
        contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
        textColor: Colors.white,
        leading: Transform.scale(
          scale: 1.25,
          child: Container(
            width: 90,
            height: 90, 
            decoration: BoxDecoration(
              shape: BoxShape.circle, 
              border: Border.all(
                width: 2,
                color: Colors.green,
              ),
              image: DecorationImage(
                image: NetworkImage(movie.fullPostering), 
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  const AssetImage('assets/no-image.jpg');
                },
              ),
            ),
          ),
        ),
        title: Text(movie.title, maxLines: 1),
        subtitle: const Padding(
          padding:  EdgeInsets.only(top: 15.0),
          child: Text('Member since 11/25/2019'),
        ),
        onTap: () => debugPrint('jean movie.title: ${movie.title}'),
        trailing: IconButton(
          icon: const Icon(Icons.more_horiz_outlined, size: 40), 
          color: Colors.white, 
          onPressed: () => debugPrint('jean movie.originalTitle: ${movie.originalTitle}'),
        ),
      ),
    );
  }
} 