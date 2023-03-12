
import 'package:fleetmanagement/bloc/cubit/filter/filter_bloc.dart';
import 'package:fleetmanagement/bloc/cubit/vehiclegroup/groupdetail_cubit.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/tracking/vehicle_group_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../data/network/api/tracking/tracking_api.dart';

class VehicleGroupDetailSearch extends StatefulWidget {
  static const String route = '/vehicle_group_detail_search';
  const VehicleGroupDetailSearch({Key? key}) : super(key: key);

  @override
  _VehicleGroupDetailSearchState createState() => _VehicleGroupDetailSearchState();
}

class _VehicleGroupDetailSearchState extends State<VehicleGroupDetailSearch> {
  final TextEditingController _searchKeywordController = TextEditingController();
  String _searchText = "";
  late FocusNode focusNode;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    print("change dependencies ran");
    // bloc = FilterBlocProvider.of(context);
    super.didChangeDependencies();
    }

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
    // filterBloc = BlocProvider.of<FilterBloc>(context);
  }

  @override
  void dispose() {
    _searchKeywordController.dispose();
    focusNode.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as VehicleGroupArguments;



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
        child:  Container(
          margin: const EdgeInsets.only(top: 32),
          child: _getSearchList(args.groupName),
        )
      ),
    );
  }


  Widget _getSearchList(String groupName) {
    final FilterBloc filterBloc = BlocProvider.of<FilterBloc>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => GroupDetailCubit(getIt<TrackingApi>())),
        // BlocProvider(create: (context)=>FilterBloc())

      ], child:  BlocBuilder<GroupDetailCubit, GroupDetailState>(
        builder: (context, state) {
          BlocProvider.of<GroupDetailCubit>(context).loadGroupDetail(groupName);

          if (state is GroupDetailLoaded) {
            return ListView.builder(
                itemCount: state.groupDatas!.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: const EdgeInsets.only(left: 20),
                      color: Colors.white,
                      child: Container(

                        decoration: BoxDecoration(
                          color: Colors.white,

                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300)),

                        ),
                        child: InkWell(
                          onTap: () {

                            // context.read<FilterBloc>().add(GetFilterEvent(keyword:state.groupDatas![index].license!));
                            filterBloc.add(GetFilterEvent(keyword:state.groupDatas![index].license!));
                            // BlocProvider.of<FilterCubit>(context).changelicense(state.groupDatas![index].license!);

                            Navigator.pop(context);

                          },
                          child: ListTile(
                            title: Text(
                              state.groupDatas![index].license!,
                              style: const TextStyle(fontFamily: 'Kanit'),
                            ),
                          ),
                        ),
                      )
                  );
                });
          }
          return Container(
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }),);

  }
}
