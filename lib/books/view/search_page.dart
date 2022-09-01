import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_library/books/books.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksCubit, BooksState>(builder: (context, state) {
      switch (state.status) {
        case BooksStatus.initial:
          return Text('Start typing to search books');
        case BooksStatus.loaded:
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return state.books.length == 0
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('No books found'),
                      ),
                    )
                   : BookListItem(book: state.books[index], isSaved: false,);
            },
            itemCount: state.books.length,
            controller: _scrollController,
          );
        default:
          return Text('Fail to load books');
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      BlocProvider.of<BooksCubit>(context).loadMoreBooks(context);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) {
//         return BooksBloc();
//       },
//       child: Scaffold(
//         body:
//         Padding(
//           padding: EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: myController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Start typing...',
//                   prefixIcon: Icon(Icons.search),
//                 ),
//                 onChanged: (inValue) {
//                   context.read<BooksBloc>().add();
//                 },
//               ),
//               RaisedButton(
//                 onPressed: () {
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           content: Stack(
//                             overflow: Overflow.visible,
//                             children: <Widget>[
//                               Positioned(
//                                 right: -40.0,
//                                 top: -40.0,
//                                 child: InkResponse(
//                                   onTap: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: CircleAvatar(
//                                     child: Icon(Icons.close),
//                                     backgroundColor: Colors.red,
//                                   ),
//                                 ),
//                               ),
//                               Form(
//                                 key: _formKey,
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: TextFormField(),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: TextFormField(),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: RaisedButton(
//                                         child: Text("Submitß"),
//                                         onPressed: () {
//                                           if (_formKey.currentState!.validate()) {
//                                             _formKey.currentState!.save();
//                                           }
//                                         },
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       });
//                 },
//                 child: Text("Open Popup"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
