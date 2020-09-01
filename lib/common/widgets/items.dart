import 'package:mengda/common/values/values.dart';
import 'package:flutter/material.dart';

Widget tileItems({
  List list,
  Function onItemTap,
}) {
  return ListView.separated(
    scrollDirection: Axis.vertical,
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text(list[index]),
        onTap: () => onItemTap(index),
        trailing: Icon(Icons.chevron_right),
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Divider(
          thickness: .33,
          height: 1,
        ),
      );
    },
  );
}

Widget cell({
  String title,
  String note,
  Widget icon,
  Widget trailing,
  Function onTap,
  Color dividerColor: AppColors.greyBorder,
}) {
  return Stack(
    children: <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(16, 16, 10, 16),
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            icon == null
                ? Container()
                : Container(
                    margin: EdgeInsets.only(right: 10),
                    child: icon,
                  ),
            Expanded(
                child: Text(
              title,
              style: AppText.normalText,
            )),
            SizedBox(
              width: 5,
            ),
            Container(
              child: trailing,
            ),
            Container(
                child: note == null
                    ? null
                    : Text(
                        note,
                        style: AppText.smGreyText,
                      )),
            SizedBox(
              width: 5,
            ),
            Visibility(
              visible: onTap != null,
              child: Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.greyBorder,
              ),
            )
          ],
        ),
      ),
      Positioned(
        left: 16,
        right: 16,
        bottom: 0,
        child: Divider(
          thickness: 0.33,
          height: 0.33,
          color: dividerColor,
        ),
      ),
      Positioned.fill(
          child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: AppColors.primary.withOpacity(0.05),
          onTap: onTap,
        ),
      ))
    ],
  );
}

Widget cellItem({
  @required String title,
  IconData icon,
  Function onTap,
  String note,
  bool isThreeLine = false,
}) {
  return ListTile(
    title: Text(title),
    onTap: onTap,
    isThreeLine: isThreeLine,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16,
    ),
    leading: icon == null
        ? null
        : Icon(
            icon,
            color: AppColors.primary.withOpacity(.8),
          ),
    trailing: Container(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: note == null
                ? null
                : Text(
                    note,
                    style: TextStyle(fontSize: 13, color: AppColors.greyText),
                  ),
          ),
          SizedBox(
            width: 8,
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.greyBorder,
          )
        ],
      ),
    ),
  );
}

// 图文列表
Widget mediaTile(
    {@required String title,
    String desc,
    Widget footer,
    double imageRatio: 4 / 3,
    @required String image,
    bool hasDivider: true,
    Widget trailing,
    int titleLines: 1,
    Function onTap}) {
  return Stack(
    children: <Widget>[
      Container(
        width: double.infinity,
        height: 100,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: imageRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: image == null
                    ? Image.asset(
                        AssetsPath.defaultImg,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: titleLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: Text(
                    desc != null ? desc : '',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  child: footer,
                )
              ],
            )),
            Container(
              child: trailing,
            )
          ],
        ),
      ),
      Positioned.fill(
          child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.black.withOpacity(0.1),
          highlightColor: Colors.black.withOpacity(0.05),
          onTap: onTap,
        ),
      )),
      Positioned(
        bottom: 0,
        left: 16.0,
        right: 0,
        child: Divider(
          height: 0.5,
          thickness: 0.5,
          color: Colors.black.withOpacity(hasDivider ? 0.1 : 0),
        ),
      )
    ],
  );
}
