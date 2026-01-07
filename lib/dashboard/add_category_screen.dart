import 'package:appwidgetflutter/dashboard/dashboard_common/custom_dialog_widget.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/custom_textfield.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/drop_zone_widget.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/form_validator.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/on_drop_functions.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/product_image.dart';
import 'package:appwidgetflutter/dashboard/done_button.dart';
import 'package:appwidgetflutter/dashboard/provider/get_all_aya_bycat.dart';
import 'package:appwidgetflutter/dashboard/provider/get_all_categories_provider.dart';
import 'package:appwidgetflutter/dashboard/provider/on_drop_provider.dart';
import 'package:appwidgetflutter/dashboard/provider/upload_category_provider.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  late final formKey = GlobalKey<FormState>();
  final TextEditingController categoryNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final catProvider = Provider.of<GetAllCategoriesProvider>(context);
    final allAyaByCategories = Provider.of<GetAllAyaByCategory>(context);
    final dropFileProvider = Provider.of<DropFileProvider>(context);
    final addCategoryProvider = Provider.of<AddCategoryProvider>(context);
    return Column(
        children: [
          AddCategoryForm(
            formKey: formKey,
            addCategoryNameController: categoryNameController,
          ),
          if(addCategoryProvider.isLoading) 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: ColorResources.THEMECOLOR,),
            )
          else if(addCategoryProvider.error)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(addCategoryProvider.message,
              style: GoogleFonts.lexend(
                color: ColorResources.redColor,
              ),
             ),
            )
          else if(addCategoryProvider.success)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(addCategoryProvider.message,
               style: GoogleFonts.lexend(
                color: ColorResources.THEMECOLOR
               ),
              ),
            ),
          DoneButton(
            onPressed: ()async{
              if(dropFileProvider.droppedFile.url.isEmpty) {
                showDialog(context: context, builder: (context){
                    return CustomDialog.alert(
                      title: 'Empty Image', 
                      body: 'Please select or drop image',
                      buttonText: 'OK',
                    );
                  });
              } else if(formKey.currentState!.validate()) {
                addCategoryProvider.addCategoryToFirebase(
                  dropFileProvider.droppedFile,
                  categoryNameController.text,
                  ).then((value) {
                    if(addCategoryProvider.success){
                      catProvider.getAllCategoreisFromDatabase();
                      allAyaByCategories.setSelectedCategoryName("Select Category");
                      allAyaByCategories.setSelectedCategoryName("");
                      categoryNameController.clear();
                      dropFileProvider.setDropFile(EmptyFunctions.emptyDropFile());
                      Provider.of<GetAllCategoriesProvider>(context, listen: false).getAllCategoreisFromDatabase();
                    }
                  });
                
              }
            },
          ),
        ],
      );
  }
}

class AddCategoryForm extends StatefulWidget {
  final TextEditingController addCategoryNameController;
  final GlobalKey<FormState> formKey;
  const AddCategoryForm({ Key? key ,required this.addCategoryNameController, required this.formKey}) : super(key: key);

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
    late DropzoneViewController _controller;
  @override
  Widget build(BuildContext context) {
    final dropFileProvider = Provider.of<DropFileProvider>(context);
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Text('Add Category', 
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: ColorResources.THEMECOLOR),
            textAlign: TextAlign.start,),
          ),
          dropFileProvider.droppedFile.url=="" ?
          DropZoneWidget(
            onDrop: (dynamic event) => OnDropFunctions.acceptCategoryFile(event, _controller,context),
            onCreated: (controller)=>_controller=controller,
            type: "Add Category Image",
            iconPressed: () async {
              final file = await _controller.pickFiles();
              OnDropFunctions.acceptCategoryFile(file.first, _controller, context);
            },
          )
          : 
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SizedBox(
              height: 130.0,
              child: ProductImage(imageUrl: dropFileProvider.getDropFile.url),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomTextField(
              controller: widget.addCategoryNameController,
              radius: 5.0,
              showErrorBorder: true,
              hintText: "Category name",
              hintStyle: GoogleFonts.lexend(
                fontSize: 12,
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: FormValidator.categoryNameValidator,
            ),
          ),
        ],
      ),
    );
  }
}