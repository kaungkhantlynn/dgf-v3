import 'package:fleetmanagement/bloc/mng/fuel_management/fuel_type/action/fuel_type_action_bloc.dart';
import 'package:fleetmanagement/ui/vehicle/fuel_management/fuel_type/edit_fuel_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';

class FuelTypeArguments {
  final int id;
  FuelTypeArguments(this.id);
}

class FuelTypeCard extends StatelessWidget {
  int? id;
  DateTime? date;
  String? type;
  FuelTypeCard({required this.id,required this.date, required this.type});
  // const FuelTypeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fuelTypeAction = BlocProvider.of<FuelTypeActionCubit>(context);
    return Card(
        semanticContainer: true,
        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Date Section
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                  translate('vehicle_management_page.date'),
                style: TextStyle(
                    color: Colors.grey.shade800,
                    fontFamily: 'Kanit',
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(padding: EdgeInsets.all(1.3)),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "${date!.day}-${date!.month}-${date!.year}",
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: 'Kanit',
                    fontSize: 18),
              ),
            ),

            //type
            Padding(padding: EdgeInsets.all(10)),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        translate('vehicle_management_page.type'),
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Kanit',
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(padding: EdgeInsets.all(3.3)),
                      Text(
                        type!,
                        style: TextStyle(
                            color: HexColor('#0F8E70'),
                            fontFamily: 'Kanit',
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 10, top: 10),
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('action'),
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Kanit',
                            fontSize: 19,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(padding: EdgeInsets.all(1.3)),
                      Wrap(
                        spacing: 1,
                        children: [
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: Colors.grey.shade200, width: 2),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, EditFuelType.route,
                                    arguments: FuelTypeArguments(id!));
                              },
                              child: Icon(
                                Icons.edit,
                                color: HexColor('#0F8E70'),
                                size: 20,
                              )),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: Colors.grey.shade200, width: 2),
                              ),
                              onPressed: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                        side: BorderSide(color: Colors.black,width: 2)
                                    ),
                                    title:  Text(translate('delete'),style: TextStyle(fontFamily: 'Inter',
                                        fontSize: 18,fontWeight: FontWeight.w600, color: Colors.black),),
                                    content: Container(
                                      child: Text(translate('sure_delete'),
                                          style: TextStyle(fontFamily: 'Inter',
                                              fontSize: 16, color: Colors.black)
                                        // textAlign: TextAlign.center,),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'Delete');
                                          fuelTypeAction.delete(id!);
                                        },
                                        child:  Text(translate('delete'),
                                            style: TextStyle(fontFamily: 'Inter',
                                                fontSize: 16, color: Colors.red)),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                        child:  Text(translate('cancel'),
                                            style: TextStyle(fontFamily: 'Inter',
                                                fontSize: 16, color: Colors.blue)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.delete_forever,
                                color: HexColor('#FF3232'),
                                size: 20,
                              ))
                        ],
                      )
                    ],
                  ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Status',
                  //       style: TextStyle(
                  //           color: Colors.grey.shade500,
                  //           fontFamily: 'Kanit',
                  //           fontSize: 19,
                  //           fontWeight: FontWeight.w500),
                  //     ),
                  //     Padding(padding: EdgeInsets.all(1.3)),
                  //     Container(
                  //       padding: EdgeInsets.all(5.5),
                  //       decoration: BoxDecoration(
                  //         border:
                  //             Border.all(color: Colors.green.shade50, width: 1),
                  //         borderRadius: BorderRadius.all(Radius.circular(5.5)),
                  //       ),
                  //       child: Text(
                  //         'Ready',
                  //         style: TextStyle(
                  //             color: Colors.green.shade700, fontSize: 15),
                  //       ),
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.5),
            )
          ],
        ));
  }
}
