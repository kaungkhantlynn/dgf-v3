import 'package:fleetmanagement/bloc/cubit/vehiclegroup/group_list_cubit.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/tracking/car_number_search.dart';
import 'package:fleetmanagement/ui/tracking/vehicle_group_detail_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../data/network/api/tracking/tracking_api.dart';
import '../vehicle/components/vehicle_menu.dart';

class VehicleGroupArguments{
  String groupName;

  VehicleGroupArguments(this.groupName);

}

class VehicleGroupSearch extends StatefulWidget {
  static const String route = '/vehicle_group_search';
  const VehicleGroupSearch({Key? key}) : super(key: key);

  @override
  _VehicleGroupSearchState createState() => _VehicleGroupSearchState();
}

class _VehicleGroupSearchState extends State<VehicleGroupSearch> {
  final TextEditingController _searchKeywordController = TextEditingController();
  final String _searchText = "";
  late FocusNode focusNode;
  @override
  void initState() {
    focusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {

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
            InkWell(
              onTap: (){
                Navigator.pushReplacementNamed(context, CarNumberSearch.route);
              },
              child: const SerchLicenseNumber(),
            ),
            const Padding(padding: EdgeInsets.all(5.10)),
            Expanded(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 11,bottom: 11),
                      child: Text(translate('car_number_search_page.vehicle_group'),style: TextStyle(fontFamily: 'Kanit',fontSize: 16,color: Colors.grey.shade700),),
                    ),
                    Expanded(child: _getSearchList())
                  ],
                )
            )
          ],
        ),
      ),
    );
  }


  


  Widget _getSearchList() {
    return BlocProvider(
      create: (BuildContext context) {
        return GroupListCubit(getIt<TrackingApi>());
      },
      child: BlocBuilder<GroupListCubit, GroupListState>(
          builder: (context, state) {
            BlocProvider.of<GroupListCubit>(context).loadGroups();

            if (state is GroupListLoaded) {
              return ListView.builder(
                  itemCount: state.listofgroup!.length,
                  itemBuilder: (context, index) {
                    // Navigator.pushNamed(context, CarInfoMenu.route,
                    //     arguments: ScreenArguments(
                    //         state.keywordSearchModel!.data![index]));
                    return InkWell(
                      onTap: (){
                        Navigator.pushReplacementNamed(context, VehicleGroupDetailSearch.route,
                        arguments: VehicleGroupArguments(state.listofgroup![index]));
                      },
                      child: VehicleMenu(title: state.listofgroup![index],),
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

class SerchLicenseNumber extends StatelessWidget {
  const SerchLicenseNumber({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: AlignmentDirectional.center,
        height: 42,
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
        child:  Container(
          alignment: AlignmentDirectional.centerStart,
          padding: const EdgeInsets.only(left: 20),
          child:  Text(translate('car_number_search_page.enter_vehicle_registration'),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.grey),),
        )
    );
  }
}
