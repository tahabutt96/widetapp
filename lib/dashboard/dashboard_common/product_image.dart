
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final bool showCrossButton;
  final double? width;
  final double? height;
  const ProductImage({Key? key, required this.imageUrl, this.showCrossButton=false, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: EdgeInsets.only(top:showCrossButton?0.0: 20.0),
              padding: showCrossButton?const EdgeInsets.only(left: 10.0): const EdgeInsets.all(10.0),
              child:Center(
                child: ImageNetwork(
                    key: Key(imageUrl),
                    image: imageUrl,
                    height: height?? 80,
                    width: width?? 80,
                    duration: 1000,
                    curve: Curves.easeIn,
                    onPointer: true,
                    debugPrint: false,
                    fitAndroidIos: BoxFit.contain,
                    fitWeb: BoxFitWeb.cover,
                    onLoading: const CircularProgressIndicator(
                      color: ColorResources.THEMECOLOR,
                    ),
                    onError: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                    onTap: () {
                      print(imageUrl);
                    },
                  ),
              ),
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: ColorResources.WHITE,
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(1,1),
                    blurRadius: 10,
                    color: ColorResources.shadowColor,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            showCrossButton?
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: IconButton(onPressed: (){
                
              }, icon: const Icon(Icons.cancel,color: ColorResources.redColor,)),
            ):Container(),
          ],
        ),
      ],
    );
  }
}