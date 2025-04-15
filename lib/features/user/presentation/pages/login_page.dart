import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/user/presentation/pages/otp_page.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();

  static Country _selectedFilteredDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode("84");
  String _countryCode = _selectedFilteredDialogCountry.phoneCode;
  String _phoneNumber = "";

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Verify phone number",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: tabColor,
                    ),
                  ),
                  Text(
                    "App  will sen to you SMS ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 30),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                    onTap: _openFilteredCountryPickerDialog,
                    title: _buildDialogItem(_selectedFilteredDialogCountry),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.50, color: tabColor),
                          ),
                        ),
                        width: 80,
                        height: 42,
                        alignment: Alignment.center,
                        child: Text(_selectedFilteredDialogCountry.phoneCode),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(top: 1.5),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: tabColor, width: 1.5),
                            ),
                          ),
                          child: TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              hintText: "Phone Number",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _submitVerifyPhoneNumber,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilteredCountryPickerDialog() {
    showDialog(
      context: context,
      builder:
          (_) => Theme(
            data: Theme.of(context).copyWith(primaryColor: tabColor),
            child: CountryPickerDialog(
              titlePadding: const EdgeInsets.all(8.0),
              searchCursorColor: tabColor,
              searchInputDecoration: const InputDecoration(hintText: "Search"),
              isSearchable: true,
              title: const Text("Select your phone code"),
              itemBuilder: _buildDialogItem,
              onValuePicked: (Country country) {
                setState(() {
                  _selectedFilteredDialogCountry = country;
                  _countryCode = country.phoneCode;
                });
              },
            ),
          ),
    );
  }

  Widget _buildDialogItem(Country country) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: tabColor, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Text(" +${country.phoneCode}"),
          Expanded(
            child: Text(
              " ${country.name}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  void _submitVerifyPhoneNumber() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => OtpPage()));
  }
}
