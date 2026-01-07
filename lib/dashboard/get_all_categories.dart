
import 'package:appwidgetflutter/dashboard/controllers/firebase_controller.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/custom_dialog_widget.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/product_image.dart';
import 'package:appwidgetflutter/dashboard/models/add_category_model.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'provider/get_all_categories_provider.dart';
class GetAllCategoryScreen extends StatefulWidget {
  const GetAllCategoryScreen({Key? key}) : super(key: key);

  @override
  _GetAllCategoryScreenState createState() => _GetAllCategoryScreenState();
}

class _GetAllCategoryScreenState extends State<GetAllCategoryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<GetAllCategoriesProvider>(context, listen: false).getAllCategoreisFromDatabase();
  }
  @override
  Widget build(BuildContext context) {
    final catProvider = Provider.of<GetAllCategoriesProvider>(context);
    void showDialogForDelete({required String id}) async {
      return showDialog(
          context: context,
          builder: (context) {
            return CustomDialog.confirm(
              title: "Confirm delete",
              body: "Are you sure you want to delete",
              falseButtonText: "Cancel",
              trueButtonText: "delete",
              trueButtonPressed: () {
                catProvider.deleteCategoreisFromDatabase(id);
                catProvider.getAllCategoreisFromDatabase();
              },
            );
          });
    }

    return 
      catProvider.isLoading ? 
      Center(
        child: CircularProgressIndicator(
          color: ColorResources.THEMECOLOR,
        ),
      ) : 
      catProvider.getAllCategories.isEmpty ?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('no categories added',
           style: GoogleFonts.lexend(
            color: ColorResources.THEMECOLOR,
            fontSize: 14,
           ),
          ),
        ],
      ) :
      catProvider.error ?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(catProvider.message),
        ],
      ) :
        ReorderableListView.builder(
          onReorder: (int oldIndex, int newIndex) {
            final index=newIndex>oldIndex?newIndex-1:newIndex;
            final listData= catProvider.getAllCategories.removeAt(oldIndex);
              FirebaseController.reorderCategoryTime( oldIndex, newIndex, catProvider.getAllCategories[index].id);
              setState(() {
                catProvider.getAllCategories.insert(index, listData);
              });
            },
          itemCount: catProvider.getAllCategories.length,
          itemBuilder: ((context, index) {
            return  reorderableListItems(data: catProvider.getAllCategories[index],onDelete: (){
              showDialogForDelete(id: catProvider.getAllCategories[index].id);
            });
          }),
      );
  }
}

reorderableListItems({required AddCategoryModel data, required VoidCallback onDelete}){
  return Stack(
    key: ValueKey(data.key),
    alignment: Alignment.center,
    children: [
      Card(
        elevation: 2.0,
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProductImage(
                      imageUrl: data.image,
                      height: 50.0,
                      width: 50.0,  
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      data.category,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                        fontSize: 15.0,
                        color: ColorResources.THEMECOLOR,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
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

class SliderWidgetSkeleton extends StatelessWidget {
  const SliderWidgetSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
          color: ColorResources.lightSkeletonColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5.0)),
    );
  }
}