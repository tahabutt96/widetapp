import 'package:appwidgetflutter/dashboard/controllers/firebase_controller.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/custom_dialog_widget.dart';
import 'package:appwidgetflutter/dashboard/models/add_aya_model.dart';
import 'package:appwidgetflutter/dashboard/provider/get_all_aya_bycat.dart';
import 'package:appwidgetflutter/dashboard/provider/get_all_categories_provider.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AllCategories extends StatefulWidget {
  final ScrollController scrollController;
  const AllCategories({super.key, required this.scrollController});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  @override
  Widget build(BuildContext context) {
    final allAyaCategories = Provider.of<GetAllCategoriesProvider>(context);
    final allAyaByCategories = Provider.of<GetAllAyaByCategory>(context);
    void showDialogForDelete({required String catId, required String ayaId}) async {
      return showDialog(
          context: context,
          builder: (context) {
            return CustomDialog.confirm(
              title: "Confirm delete",
              body: "Are you sure you want to delete",
              falseButtonText: "Cancel",
              trueButtonText: "delete",
              trueButtonPressed: () {
                allAyaByCategories.deleteAyaModel(catId, ayaId);
                allAyaByCategories.getAllAyaModel(catId);
              },
            );
          });
    }
    return Column(
      children: [
        SizedBox(
        height: 80.0,  
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: allAyaCategories.allCategories.length,
          itemBuilder: (context,index){
            return CategoryWidget(
              title: allAyaCategories.allCategories[index].category, 
              onPressed: (){
                 allAyaByCategories.getAllAyaModel(allAyaCategories.allCategories[index].id).then((value) {
                   WidgetsBinding.instance.addPostFrameCallback((_) => {
                    widget.scrollController.jumpTo(widget.scrollController.position.maxScrollExtent)
                  });
                 });
                 allAyaByCategories.setSelectedCategoryName(allAyaCategories.allCategories[index].category);
                 allAyaByCategories.setSelectedCategoryId(allAyaCategories.allCategories[index].id);
              },
            );
          }
        ),
       ),
       allAyaByCategories.getAyaByCategory.length == 0 ?
       Container(): 
       allAyaByCategories.isLoading ? 
       CircularProgressIndicator() :
       allAyaByCategories.error ? Text(allAyaByCategories.message) :
       Expanded(
        flex: 6,
         child: ReorderableListView.builder(
          shrinkWrap: true,
          reverse: true,
            scrollController: widget.scrollController,
            itemCount: allAyaByCategories.getAyaByCategory.length, 
            onReorder: (int oldIndex, int newIndex) {
              final index=newIndex>oldIndex?newIndex-1:newIndex;
              final listData= allAyaByCategories.getAyaByCategory.removeAt(oldIndex);
                FirebaseController.updateAyaTime(oldIndex,newIndex,allAyaByCategories.getSelectedCategoryId);
                setState(() {
                allAyaByCategories.getAyaByCategory.insert(index, listData);
                });
              },
            itemBuilder: ((context, index) {
              return  reorderableListItems(data: allAyaByCategories.getAyaByCategory[index],
              onDelete: (){
                showDialogForDelete(catId: allAyaByCategories.getAyaByCategory[index].catId!,ayaId: allAyaByCategories.getAyaByCategory[index].id!,);
              });
            }),
             ),
       ),
      ],
    );
  }
}
reorderableListItems({required AddAyaModel data, required VoidCallback onDelete}){
  return Stack(
    key: ValueKey(data.key),
    alignment: Alignment.center,
    children: [
      ExpandableCard(text: data.aya!),
      Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed:onDelete,
              icon: const Icon(
                Icons.delete,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class CategoryWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const CategoryWidget({ Key? key,required this.title,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allAyaByCategories = Provider.of<GetAllAyaByCategory>(context);
    return Center(
      child: InkWell(
        child: Container(
          margin: const EdgeInsets.only(right: 10.0),
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20.0),
          decoration: BoxDecoration(
            color: allAyaByCategories.getSelectedCategoryName == title ? ColorResources.THEMECOLOR : ColorResources.WHITE,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: ColorResources.lightSkeletonColor),
          ),
          child: Text(title,style: GoogleFonts.lexend(
            fontWeight: FontWeight.w600,
            color:allAyaByCategories.getSelectedCategoryName == title ? ColorResources.WHITE : ColorResources.THEMECOLOR,
          ),
         ),
        ),
        onTap: onPressed,
      ),
    );
  }
}


class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
    Expanded(
      child: FloatingActionButton(
      heroTag: 'reverse',
      elevation: 0,
      mini: true,
      // backgroundColor: _hasBeenPressed1!
      //     ? ColorResources.BOTTOM_BAR_SELECTED.withOpacity(0.4)
      //     : ColorResources.BOTTOM_BAR_SELECTED,
      onPressed: () {
      },
      child: Icon(Icons.arrow_back),
     ),
    ),
    SizedBox(width: 5),
    Expanded(
      flex: 9,
      child: Container(
        child: ExpandableNotifier(
        child: ScrollOnExpand(
        scrollOnExpand: false,
        child: Card(
          margin: EdgeInsets.all(15.0),
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Expandable(
                  collapsed: Container(
                    alignment: Alignment.center,
                    child: Text('',
                      maxLines: 12,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                        color: ColorResources.BOTTOM_BAR_SELECTED,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      ),
                    ),
                  expanded: Text('',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                    color: ColorResources.BOTTOM_BAR_SELECTED,
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                    ),
                  ),
                )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Builder(
                    builder: (context) {
                      var controller = ExpandableController.of(context, required: true)!;
                      return IconButton(
                        onPressed: () {
                          controller.toggle();
                        },
                        icon: controller.expanded ? Icon(
                          Icons.expand_less,
                          color: ColorResources.BOTTOM_BAR_SELECTED,
                          ) : 
                          Icon(Icons.expand_more_outlined,
                            color: ColorResources.BOTTOM_BAR_SELECTED));
                    },
                  ),
                ],
              ),
            ],
              ),
            ),
          ),
        ))),
    SizedBox(width: 5),
    Expanded(
      child: FloatingActionButton(
        heroTag: 'forward',
      mini: true,
      elevation: 0,
      // backgroundColor: _hasBeenPressed!
      //     ? ColorResources.BOTTOM_BAR_SELECTED.withOpacity(0.4)
      //     : ColorResources.BOTTOM_BAR_SELECTED,
      onPressed: () {
      },
      child: Icon(Icons.arrow_forward_outlined),
    )),
      ],
    );
  }
}

class ExpandableCard extends StatelessWidget {
  final String text;
  const ExpandableCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
      scrollOnExpand: true,
      child: Card(
        margin: EdgeInsets.all(15.0),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Expandable(
                collapsed: Container(
                  alignment: Alignment.center,
                  child: Text(text,
                    maxLines: 3,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(
                      forceStrutHeight: true,
                    ),
                    style: TextStyle(
                      color: ColorResources.BOTTOM_BAR_SELECTED,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                    ),
                  ),
                expanded: Container(
                  alignment: Alignment.center,
                  child: Text(text,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle(
                        forceStrutHeight: true,
                      ),
                      style: TextStyle(
                        color: ColorResources.BOTTOM_BAR_SELECTED,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                ),
              )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Builder(
                  builder: (context) {
                    var controller = ExpandableController.of(context, required: true)!;
                    return IconButton(
                      onPressed: () {
                        controller.toggle();
                      },
                      icon: controller.expanded ? Icon(
                        Icons.expand_less,
                        color: ColorResources.BOTTOM_BAR_SELECTED,
                        ) : 
                        Icon(Icons.expand_more_outlined,
                          color: ColorResources.BOTTOM_BAR_SELECTED));
                  },
                ),
              ],
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Direction direction;
  final bool showColor;
  const CircleButton({super.key, required this.onPressed,required this.direction, required this.showColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 35.0,
        width: 35.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:!showColor
            ? ColorResources.BOTTOM_BAR_SELECTED.withOpacity(0.4)
            : ColorResources.BOTTOM_BAR_SELECTED
      ),
      child: Center(
        child: Icon(direction == Direction.left ?  Icons.arrow_back : Icons.arrow_forward,
         color: Colors.white,
        ),
      ),
         ),
    );
  }
}

enum Direction {left,right}