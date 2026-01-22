import 'package:appwidgetflutter/utills/images_sources.dart';

class SliderModel{
String? image;
String? description;


SliderModel({this.description, this.image});

void setImage(String getImage){
	image = getImage;
}

void setDescription(String getDescription){
	description = getDescription;
}

String getImage(){
	return image!;
}

String getDescription(){
	return description!;
}
}

List<SliderModel> getSlides(){
List<SliderModel> slides = <SliderModel>[];
SliderModel sliderModel = SliderModel();

sliderModel.setImage(Images.slider1);
sliderModel.setDescription('تخيل في كل مرة تفتح فيها هاتفك تجد آية تناسب حالتك النفسية، هذا تماماً ما يقوم به التطبيق');
slides.add(sliderModel);

sliderModel = SliderModel();

sliderModel.setImage(Images.slider2);
sliderModel.setDescription("تخيل انك مهموما أو تشعر بالحيرة فتجد مثل هذه الآيات");
slides.add(sliderModel);

sliderModel = SliderModel();

sliderModel.setImage(Images.slider3);
sliderModel.setDescription("أو انك تشعر بضيق الرزق فتجد مثل هذه الآيات");
slides.add(sliderModel);

sliderModel = SliderModel();

sliderModel.setImage(Images.slider4);
sliderModel.setDescription("كل ما عليك فعله هو اختيار حالتك المزاجيه من بين العشرات من الحالات مع تفعيل القالب على شاشة الموبايل واجعل القرآن يداوي ما في قلبك");
slides.add(sliderModel);

sliderModel = SliderModel();
return slides;
}
