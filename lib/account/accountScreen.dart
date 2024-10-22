import 'package:avatar_glow/avatar_glow.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiten/models/user.dart';
import 'package:hiten/providers/userProvider.dart';
import 'package:hiten/screens/auth/auth.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class UserAccountScreen extends StatefulWidget {
  static const routeName = '/accountScreen';
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    ModelUser user = Provider.of<UserProvider>(context).getUser;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 35),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  tooltip: 'Logout',
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.routeName, (route) => false);
                  },
                  icon: Icon(Iconsax.logout)),
            ),
            BuildProfileAnimation(
              userType: user.userType,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 5, right: 20, left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Personal Details',
                  style: GoogleFonts.getFont('Poppins',
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 22),
                ),
              ),
            ),
            BuildPersonalInfo(
              user: user,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 5, right: 20, left: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'My Certifications',
                  style: GoogleFonts.getFont('Poppins',
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 22),
                ),
              ),
            ),
            BuildMySkills(),
          ],
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key, required this.callback, required this.buttonTitle});
  final VoidCallback callback;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          buttonTitle,
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class BuildMySkills extends StatelessWidget {
  const BuildMySkills({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Material(
        elevation: 10,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Column(
          children: [
            BuildInfoTile(title: 'Driving License', value: 'Submitted'),
            BuildInfoTile(title: 'Aadhar Card', value: 'Submitted'),
            BuildInfoTile(title: 'Work Permit', value: 'Submitted')
          ],
        ),
      ),
    );
  }
}

class BuildPersonalInfo extends StatelessWidget {
  const BuildPersonalInfo({super.key, required this.user});
  final ModelUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Material(
        color: Colors.white,
        elevation: 10,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Column(
          children: [
            BuildInfoTile(
              title: 'Name',
              value: user.name,
            ),
            BuildInfoTile(
              title: 'Email',
              value: user.email,
            ),
            BuildInfoTile(
              title: 'Phone',
              value: user.phoneNumber.isEmpty ? '-' : user.phoneNumber,
            ),
            BuildInfoTile(
              title: 'Role',
              value: user.userType,
            ),
            CustomTextButton(
              callback: () {},
              buttonTitle: 'Edit My Profile',
            )
          ],
        ),
      ),
    );
  }
}

class BuildInfoTile extends StatelessWidget {
  const BuildInfoTile({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        title,
        style: TextStyle(
            color: Colors.lightGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
      trailing: Text(
        value,
        style: GoogleFonts.getFont('Poppins',
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
      ),
    );
  }
}

class BuildProfileAnimation extends StatelessWidget {
  BuildProfileAnimation({super.key, required this.userType});
  final String userType;

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        (userType != 'worker') ? 'assets/manager.jpg' : 'assets/labour.png';

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      width: 160,
      height: 160,
      child: AvatarGlow(
        glowColor: Color.fromARGB(255, 15, 233, 106),
        duration: Duration(milliseconds: 2000),
        repeat: true,
        child: DottedBorder(
          radius: Radius.circular(10),
          color: Colors.greenAccent,
          strokeWidth: 8,
          borderType: BorderType.Circle,
          dashPattern: [1, 12],
          strokeCap: StrokeCap.butt,
          child: Center(
            child: SizedBox(
              width: 130,
              height: 130,
              child: CircleAvatar(
                foregroundImage: AssetImage(imageUrl),
                radius: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
