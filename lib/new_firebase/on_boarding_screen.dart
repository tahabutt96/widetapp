import 'package:appwidgetflutter/common/share_prefs.dart';
import 'package:appwidgetflutter/main.dart';
import 'package:appwidgetflutter/new_firebase/models/slider_model.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:appwidgetflutter/utills/images_sources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

@override
State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

List<SliderModel> slides = <SliderModel>[];
int currentIndex = 0;
 PageController? _controller;

@override
void initState() {
	super.initState();
	slides = getSlides();
	_controller = PageController(initialPage: 0);
}
@override
void dispose(){
	_controller!.dispose();
	super.dispose();
}
@override
Widget build(BuildContext context) {
	return Scaffold(
	body: SafeArea(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(Images.slider_background))
          ),
        child: Column(
          children: [
          Expanded(
            child: PageView.builder(
           controller: _controller,
              scrollDirection: Axis.horizontal,
              onPageChanged: (value){
              setState(() {
                currentIndex = value;
              });
              },
              itemCount: slides.length,
              itemBuilder: (context, index){
         
              // contents of slider
              return Column(
             mainAxisAlignment: MainAxisAlignment.center,
                children: [
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                 child: Text(slides[index].getDescription(),
                   textAlign: TextAlign.center,
                   style: GoogleFonts.urbanist(
                     fontSize: 18.0,
                     color: Color(0xFF212121),
                     fontWeight: FontWeight.w500,
                   ),
                 ),
               ),
                  Slider(
                    image: slides[index].getImage(),
                  ),
                ],
              );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:20.0, bottom: 20.0),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(slides.length, (index) => buildDot(index, context),
            ),
            ),
          ),
            if(currentIndex == 0) 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SliderButton(
                text: 'التالي', 
                textColor: Colors.white, 
                buttonColor: ColorResources.THEMECOLOR, 
                onPressed: (){
                  _controller!.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
              ),
            )
            else if(currentIndex == 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: SliderButton(
                    text: 'رجوع', 
                    textColor: ColorResources.THEMECOLOR, 
                    buttonColor: ColorResources.BOTTOM_BAR, 
                    onPressed: (){
                      _controller!.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    },
                          ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                Expanded(
                  child: SliderButton(
                    text: 'التالي', 
                    textColor: Colors.white, 
                    buttonColor: ColorResources.THEMECOLOR, 
                    onPressed: (){
                      _controller!.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    },
                  ),
                ),
                ],
              ),
            )
            else if ( currentIndex == 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: SliderButton(
                    text: 'رجوع', 
                    textColor: ColorResources.THEMECOLOR, 
                    buttonColor: ColorResources.BOTTOM_BAR, 
                    onPressed: (){
                      _controller!.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    },
                          ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                Expanded(
                  child: SliderButton(
                    text: 'التالي', 
                    textColor: Colors.white, 
                    buttonColor: ColorResources.THEMECOLOR, 
                    onPressed: (){
                      _controller!.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    },
                  ),
                ),
                ],
              ),
            )
            else if (currentIndex == 3)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: SliderButton(
                    text: 'رجوع', 
                    textColor: ColorResources.THEMECOLOR, 
                    buttonColor: ColorResources.BOTTOM_BAR, 
                    onPressed: (){
                      _controller!.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    },
                          ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                Expanded(
                  child: SliderButton(
                    text: 'ابدأ الآن', 
                    textColor: Colors.white, 
                    buttonColor: ColorResources.THEMECOLOR, 
                    onPressed: (){
                      SharePrefs.setSliderValue(false);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage(selectedIndex: 2,info: "widget",)));
                    },
                  ),
                ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    ),
	);
}

// container created for dots
Container buildDot(int index, BuildContext context){
	return Container(
	height: 5,
	width: currentIndex == index ? 30 : 5,
	margin: const EdgeInsets.only(right: 10.0),
	decoration: BoxDecoration(
		borderRadius: BorderRadius.circular(20),
		color:currentIndex == index ? ColorResources.THEMECOLOR : Colors.grey.withOpacity(0.5),
	),
	);
}
}

class Slider extends StatelessWidget {
final String image;

const Slider({required this.image, Key? key}):super(key: key);

@override
Widget build(BuildContext context) {
	return Column(
	mainAxisAlignment: MainAxisAlignment.center,
	children: [
    Image.asset(image,height: 380.0,),
	],
	);
}
}

class SliderButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color buttonColor;
  final VoidCallback onPressed;
  const SliderButton({Key? key, required this.text, required this.textColor, required this.buttonColor, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
              color: textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
       ),
      ),
    );
  }
}