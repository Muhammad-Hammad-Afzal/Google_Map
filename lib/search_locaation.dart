
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  late GooglePlace _googlePlace;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String Api_key = "AIzaSyBou5lILPACswBz2F8JLMBQlqwIRQ9KXf4";
    _googlePlace = GooglePlace(Api_key);
  }
  List<AutocompletePrediction> placeslist = [];


  void AutocompleteSrearch(String value)async{
    var result = await _googlePlace.autocomplete.get(value);
    print(result!.predictions!.first.description);
    if(result != null && result.predictions != null ){
      setState(() {
        placeslist = result.predictions!;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search here'
          ),
          onChanged: (value){
            if(value.isNotEmpty){
              AutocompleteSrearch(value);
            }else{

            }
          },
        )
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: placeslist.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text('data'),
                    );
                  })
          )
        ],
      ),

    );
  }
}
