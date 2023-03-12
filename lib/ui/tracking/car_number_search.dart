import 'package:fleetmanagement/bloc/keyword_search/keyword_search_bloc.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../bloc/cubit/filter/filter_bloc.dart';
import '../widgets/snackbar.dart';

class CarNumberSearch extends StatefulWidget {
  static const String route = '/car_number_search';
  const CarNumberSearch({Key? key}) : super(key: key);

  @override
  _CarNumberSearchState createState() => _CarNumberSearchState();
}

class _CarNumberSearchState extends State<CarNumberSearch> {
  final TextEditingController _searchKeywordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  String _searchText = "";
  late FocusNode focusNode;
  @override
  void initState() {
    focusNode = FocusNode();
    _searchKeywordController.addListener(() {
      if (_searchKeywordController.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _searchKeywordController.text;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _searchKeywordController.dispose();
    focusNode.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        title: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                translate('app_bar.car_number_search'),
                style: TextStyle(color: Colors.grey.shade800),
              ),
            )),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                alignment: AlignmentDirectional.center,
                height: 50,
                margin: const EdgeInsets.only(top: 15, left: 12, right: 12),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 0, // has the effect of softening the shadow
                        offset: Offset(
                          0, // horizontal, move right 10
                          0, // vertical, move down 10
                        ),
                      ),
                    ]),
                child: Center(
                  child: TextFormField(
                    autofocus: true,
                    controller: _searchKeywordController,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 5, bottom: 5, left: 15),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent, //this has no effect
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                const BorderSide(color: Colors.transparent)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                const BorderSide(color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                const BorderSide(color: Colors.transparent)),
                        errorBorder: OutlineInputBorder(
                            gapPadding: 10,
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                const BorderSide(color: Colors.transparent)),
                        hintText: "${translate('car_number_search_page.enter_vehicle_registration')}",
                        errorStyle: const TextStyle(height: 1, fontSize: 15),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                const BorderSide(color: Colors.transparent)),
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600)),
                    onSaved: (String? value) {},
                  ),
                )),
            const Padding(padding: EdgeInsets.all(5.10)),
            Expanded(child: _builList())
          ],
        ),
      ),
    );
  }

  Widget _builList() {
    if (_searchText.isNotEmpty) {
      return _getSearchList();
    } else {
      return Container(
          margin: const EdgeInsets.only(top: 8.8),
         );
    }
  }

  Widget _getSearchList() {
    return BlocProvider(
      create: (BuildContext context) {
        return KeywordSearchBloc(getIt<TrackingRepository>());
      },
      child: BlocBuilder<KeywordSearchBloc, KeywordSearchState>(
          builder: (context, state) {
        BlocProvider.of<KeywordSearchBloc>(context)
            .add(GetKeywordSearchEvent(keyword: _searchKeywordController.text));
        if (state is KeywordSearchLoading) {
          return Container(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is FailedInternetConnection) {
          ShowSnackBar.showWithScaffold(_scaffoldKey, context, 'Check Internet Connection',
              color: Colors.redAccent);
        }

        if (state is KeywordSearchLoaded) {
          return ListView.builder(
              itemCount: state.keywordSearchModel!.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          spreadRadius:
                              1.0, // has the effect of extending the shadow
                          // offset: Offset(
                          //   1.0, // horizontal, move right 10
                          //   1.0, // vertical, move down 10
                          // ),
                        )
                      ]),
                  padding: const EdgeInsets.all(1.5),
                  margin: const EdgeInsets.only(bottom: 1),
                  child: InkWell(
                    onTap: () {
                      context.read<FilterBloc>().add(GetFilterEvent(keyword:state.keywordSearchModel!.data![index]));
                      // BlocProvider.of<FilterCubit>(context).changelicense(state.groupDatas![index].license!);

                      Navigator.pop(context);

                    },
                    child: ListTile(
                      title: Text(
                        state.keywordSearchModel!.data![index],
                        style: const TextStyle(fontFamily: 'Kanit'),
                      ),
                    ),
                  ),
                );
              });
        }
        return Container(
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }
}
