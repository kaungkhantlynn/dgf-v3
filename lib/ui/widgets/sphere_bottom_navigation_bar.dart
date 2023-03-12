import 'package:flutter/material.dart';

class BuildNavigationItem {
  final Icon? icon;
  final Color? selectedItemColor;
  final Color? itemColor;
  final String? tooltip;
  final String? title;
  final bool? hasNoti;
  final String? notiCount;

  BuildNavigationItem(
      {@required this.icon,
      @required this.tooltip,
      this.selectedItemColor = Colors.blue,
      this.itemColor,
      this.title,
      this.hasNoti,
      this.notiCount});
}

class SphereBottomNavigationBar extends StatefulWidget {
  final int? defaultSelectedItem;
  final Color? sheetBackgroundColor;
  final BorderRadius? sheetRadius;
  final List<BuildNavigationItem>? navigationItems;
  final ValueChanged<int>? onItemPressed;
  final ValueChanged<int>? onItemLongPressed;

  SphereBottomNavigationBar(
      {Key? key,
      this.defaultSelectedItem,
      this.sheetBackgroundColor,
      this.sheetRadius,
      this.onItemLongPressed,
      @required this.navigationItems,
      @required this.onItemPressed}) {
    assert(onItemPressed != null, 'You must implement onItemPressed ');
  }

  @override
  _SphereBottomNavigationBarState createState() {
    // ignore: no_logic_in_create_state
    return _SphereBottomNavigationBarState(
        items: navigationItems!,
        sheetRadius: sheetRadius!,
        onItemLongPressed: onItemLongPressed!,
        sheetBackgroundColor: sheetBackgroundColor!,
        defaultSelectedItem: defaultSelectedItem!,
        onItemPressed: onItemPressed!);
  }
}

class _SphereBottomNavigationBarState extends State<SphereBottomNavigationBar> {
  final int? defaultSelectedItem;
  List<BuildNavigationItem>? items;
  int? selectedItemIndex;
  BorderRadius? sheetRadius;
  var sheetHieght;
  var sheetWidth;
  Color? sheetBackgroundColor;
  ValueChanged<int>? onItemLongPressed;
  ValueChanged<int>? onItemPressed;

  _SphereBottomNavigationBarState(
      {@required this.items,
      this.onItemLongPressed,
      this.defaultSelectedItem = 0,
      this.sheetRadius,
      this.sheetBackgroundColor,
      //this.iconSize,
      @required this.onItemPressed}) {
    selectedItemIndex = defaultSelectedItem;
    assert(items!.length > 1, 'Atleast 2 item required. ');
    assert(items!.length <= 5, 'You can add Maximum 5 Item');
  }

  Widget itemBuilder(BuildNavigationItem item, bool isSelected) {
    var containerHieght = ((sheetHieght + sheetWidth) / 12);
    var containerWidth = ((sheetHieght + sheetWidth) / 12);
    var tooltip =
        item.tooltip ?? selectedItemIndex.toString();
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Tooltip(
          verticalOffset: 50,
          message: tooltip,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: containerWidth,
                height: containerHieght,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Stack(
                        fit: StackFit.loose,
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconTheme(
                                data: IconThemeData(
                                    size: ((containerHieght + containerWidth) /
                                        5),
                                    color: isSelected
                                        ? item.selectedItemColor
                                        : item.itemColor ?? Colors.grey),
                                child: item.icon!,
                              ),
                            ],
                          ),
                          Visibility(
                            visible: item.hasNoti!,
                            child: Positioned(
                              left: 8,

                              child: Container(
                                padding: const EdgeInsets.all(2.2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.10),
                                    color: Colors.red,),
                                child: Text(
                                  item.notiCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Text(item.title!)
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    sheetHieght = MediaQuery.of(context).size.height / 12;
    sheetWidth = MediaQuery.of(context).size.width;
    sheetBackgroundColor = (sheetBackgroundColor == null)
        ? Theme.of(context).bottomAppBarColor
        : sheetBackgroundColor;
    return Container(
      width: sheetWidth,
      height: sheetHieght,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(top: 12),
        width: sheetWidth,
        height: sheetHieght,
        decoration: BoxDecoration(
            color: sheetBackgroundColor,
            borderRadius: sheetRadius,
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items!.map((item) {
            var index = items!.indexOf(item);
            return GestureDetector(
              onTap: () {
                onItemPressed!(index);
                setState(() {
                  selectedItemIndex = index;
                });
              },
              onLongPress: () {
                onItemLongPressed!(index);
                setState(() {
                  selectedItemIndex = index;
                });
              },
              child: itemBuilder(item, selectedItemIndex == index),
            );
          }).toList(),
        ),
      ),
    );
  }
}
