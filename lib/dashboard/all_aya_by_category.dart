import 'package:appwidgetflutter/dashboard/all_categories_widget.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/custom_app_bar.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/custom_dialog_widget.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/custom_textfield.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/form_validator.dart';
import 'package:appwidgetflutter/dashboard/done_button.dart';
import 'package:appwidgetflutter/dashboard/models/add_aya_model.dart';
import 'package:appwidgetflutter/dashboard/provider/add_aya_provider.dart';
import 'package:appwidgetflutter/dashboard/provider/get_all_categories_provider.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'provider/get_all_aya_bycat.dart';

class AddAya extends StatefulWidget {
  const AddAya({super.key});

  @override
  State<AddAya> createState() => _AddAyaState();
}

class _AddAyaState extends State<AddAya> {
  late ScrollController controller;
  final TextEditingController ayaController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final getAllCategoriesProvider = Provider.of<GetAllCategoriesProvider>(context);
    final allAyaByCategories = Provider.of<GetAllAyaByCategory>(context);
    final addAyaProvider = Provider.of<AddAyaProvider>(context);
    return Expanded(
      flex: 8,
      child: CustomAppBar(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Text('Add Aya', 
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: ColorResources.THEMECOLOR),
                    textAlign: TextAlign.start,),
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: AllCategoriesByName()),
                  ],
                ),
                AyaTextField(ayaController: ayaController),
                SizedBox(
                  height: 10.0,
                ),
                if(addAyaProvider.isLoading) 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: ColorResources.THEMECOLOR,),
                  )
                else if(addAyaProvider.error)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(addAyaProvider.message,
                    style: GoogleFonts.lexend(
                      color: ColorResources.redColor,
                    ),
                  ),
                  )
                else if(addAyaProvider.success)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(addAyaProvider.message,
                    style: GoogleFonts.lexend(
                      color: ColorResources.THEMECOLOR
                    ),
                    ),
                  ),
                DoneButton(
                  onPressed: ()async{
                    if(getAllCategoriesProvider.getselectedCategoryForUpload.isEmpty) {
                      showDialog(context: context, builder: (context){
                          return CustomDialog.alert(
                            title: 'Empty Category', 
                            body: 'Please select or category',
                            buttonText: 'OK',
                          );
                        });
                    } else if(formKey.currentState!.validate()) {
                      getAllCategoriesProvider.getselectedCategoryForUpload.forEach((categoriesId) {
                        print(allAyaByCategories.selectedCategoryId);
                        print("This is selected cat id");
                        addAyaProvider.addAyaToFirebase(
                        AddAyaModel(
                          id: '', 
                          catId: categoriesId, 
                          aya: ayaController.text, 
                          date: '',
                          key: 0,
                          ),
                      ).then((value) {
                          if(addAyaProvider.success){
                            ayaController.clear();
                              allAyaByCategories.setSelectedCategoryName(getAllCategoriesProvider.selectedCategoryNameForUpload.first);
                              allAyaByCategories.getAllAyaModel(getAllCategoriesProvider.selectedCategoryForUpload.first).then((value) {
                                WidgetsBinding.instance.addPostFrameCallback((_) => {
                                  controller.jumpTo(controller.position.maxScrollExtent)
                                });
                              });
                            getAllCategoriesProvider.clearSelectedCategory();
                            // allAyaByCategories.setSelectedCategoryId(getAllCategoriesProvider.getuploadSelectedCategoryId);
                            // getAllCategoriesProvider.setuploadSelectedCategory("Select Category");
                          }
                        });
                       });
                    }
                  },
                ),
                Expanded(child: AllCategories(scrollController: controller,)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AllCategoriesByName extends StatefulWidget {
  const AllCategoriesByName({Key? key}) : super(key: key);

  @override
  State<AllCategoriesByName> createState() => _AllCategoriesByNameState();
}

class _AllCategoriesByNameState extends State<AllCategoriesByName> {
  @override
  void initState() {
    Provider.of<GetAllCategoriesProvider>(context, listen: false).getAllCategoreisFromDatabase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final getAllCategoriesProvider = Provider.of<GetAllCategoriesProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        child: Wrap(
          children: getAllCategoriesProvider.getAllCategories.map((e) => Container(
            child: Wrap(
                    children: [
                      InkWell(
                        onTap: () {
                          print(e.id);
                          print(getAllCategoriesProvider);
                          // if( e.id == getAllCategoriesProvider){
                              // getAllCategoriesProvider.setselectedCategoryForUpload("");
                              // getAllCategoriesProvider.setuploadSelectedCategory("Select Category");
                              // getAllCategoriesProvider.setuploadSelectedCategoryId("");
                          // } else {
                            getAllCategoriesProvider.setselectedCategoryForUpload(e.id);
                            getAllCategoriesProvider.setselectedCategoryNameForUpload(e.category);
                              // getAllCategoriesProvider.setuploadSelectedCategory(e.category);
                              // getAllCategoriesProvider.setuploadSelectedCategoryId(e.id);
                          // }

                          print(getAllCategoriesProvider.getselectedCategoryForUpload);
                        },
                        child: Container(
                          height: 25.0,
                          width: 25.0,
                          decoration: BoxDecoration(
                            color: getAllCategoriesProvider.getselectedCategoryForUpload.contains(e.id) ? ColorResources.THEMECOLOR : ColorResources.WHITE,
                            border: Border.all(color: ColorResources.THEMECOLOR),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child:getAllCategoriesProvider.getselectedCategoryForUpload.contains(e.id) ? Center(
                            child: Icon(Icons.check, color: ColorResources.WHITE,size: 14.0,),
                          ) : Container(),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 25.0),
                          child: Text(e.category, 
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: ColorResources.THEMECOLOR,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.0,),
                    ],
                  ),
          )).toList(),
        ),
      ),
    );
  }
}

class AyaTextField extends StatelessWidget {
  final TextEditingController ayaController;
  const AyaTextField({super.key, required this.ayaController});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: ayaController,
      radius: 5.0,
      showErrorBorder: true,
      hintText: "Aya",
      hintStyle: GoogleFonts.lexend(
        fontSize: 12,
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: FormValidator.ayaValidator,
    );
  }
}

