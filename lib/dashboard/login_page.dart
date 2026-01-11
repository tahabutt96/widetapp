import 'package:appwidgetflutter/dashboard/dashboard_common/custom_textfield.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/form_validator.dart';
import 'package:appwidgetflutter/dashboard/dashboard_layout/dashboard_layout.dart';
import 'package:appwidgetflutter/dashboard/done_button.dart';
import 'package:appwidgetflutter/dashboard/models/user_model.dart';
import 'package:appwidgetflutter/dashboard/provider/login_provider.dart';
import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:appwidgetflutter/utills/images_sources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    late final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController(text: 'admin@gmail.com');
    final passwordController = TextEditingController(text: '12345678');
    Column formView() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Image.asset(Images.splash_logo,width: 300,),
          Column(
            children: [
              _UserDetailsState(
                  emailController: emailController,
                  passwordController: passwordController),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          if(loginProvider.isLoading) 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: ColorResources.THEMECOLOR,),
            )
          else if(loginProvider.error)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(loginProvider.message,
              style: GoogleFonts.lexend(
                color: ColorResources.redColor,
              ),
             ),
            ),
          DoneButton(
            onPressed: (){
              loginProvider.loginUser(UserModel(email: emailController.text, password: passwordController.text)).then((value){
                if(value.userCredential!=null) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage()));
                }
              });

            },
            text: "Login",  
          ),
        ],
      );
    }

    return Scaffold(
      body: Form(
        key: formKey,
        child: SafeArea(
          child: ScreenTypeLayout(
            mobile:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: formView(),
                   )),
              ],
            ),
            desktop: FormView(child: formView()),
            tablet: Column(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: formView(),
                )),
              ],
            ),
          ),    
        ),
      ),
    );
  }
}

class FormView extends StatelessWidget {
  final Widget child;
  const FormView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorResources.THEMECOLOR),
                  ),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height/1.5,
                  width: MediaQuery.of(context).size.width/2,
                  child: child)
            ],
          ),
        ),
      ],
    );
  }
}

class _UserDetailsState extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const _UserDetailsState(
      {required this.emailController, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Column(
        children: [
          CustomTextField(
              showCursor: true,
              showErrorBorder: true,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefix: SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: Icon(Icons.email),
                ),
              ),
              hintText: "Email",
              validator: FormValidator.emailValidator),
          const SizedBox(
            height: 20,
          ),
          CustomTextField(
              showCursor: true,
              showErrorBorder: true,
              controller: passwordController,
              textInputAction: TextInputAction.next,
              prefix: SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: Icon(Icons.password),
                ),
              ),
              hintText: "Password",
              keyboardType: TextInputType.visiblePassword,
              validator: FormValidator.passwordValidator),
        ],
      ),
    );
  }
}
