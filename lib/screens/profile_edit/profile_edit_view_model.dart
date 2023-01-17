import 'dart:io';
import 'package:tomas/localization/app_translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/helpers/custom_cupertino_picker.dart';
import 'package:tomas/helpers/utils.dart';
import 'package:tomas/providers/providers.dart';
import 'package:tomas/redux/app_state.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:tomas/widgets/custom_toast.dart';
import './profile_edit.dart';

abstract class ProfileEditViewModel extends State<ProfileEdit> {
  Store<AppState> store;
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nipController = TextEditingController();

  final picker = ImagePicker();
  File file;

  List divisionList = List();

  int selectedDivision;
  int selectedPicker;

  String fileName = "";
  String selectedDivisionName = '';
  String errorFullname = "";
  String errorPhoneNumber = "";
  String errorEmail = "";
  String errorFile = "";
  String errorDivision = "";
  String errorNip = "";

  bool isLoading = true;

  void toggleLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  void selectImage() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          child: CustomText(
            'Cancel',
            color: ColorsCustom.primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          fileName != null || fileName != ""
              ? CupertinoActionSheetAction(
                  child: CustomText(
                    AppTranslations.of(context).currentLanguage == 'id'
                        ? "Hapus Photo"
                        : 'Delete Photo',
                    color: ColorsCustom.primary,
                  ),
                  onPressed: () async {
                    clearFile();
                    Navigator.pop(context);
                  },
                )
              : SizedBox(),
          CupertinoActionSheetAction(
            child: CustomText(
              AppTranslations.of(context).currentLanguage == 'id'
                  ? "Ambil Photo"
                  : 'Take Photo',
              color: ColorsCustom.blueSystem,
            ),
            onPressed: () async {
              await getCamera();
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: CustomText(
              AppTranslations.of(context).currentLanguage == 'id'
                  ? "Pilih dari Galeri"
                  : 'Choose from Gallery',
              color: ColorsCustom.blueSystem,
            ),
            onPressed: () async {
              await getImage();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 15);

    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 15);

    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void onShowDivision() {
    FocusScope.of(context).requestFocus(new FocusNode());
    clearError("division");
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.white.withOpacity(0.2),
            child: Container(
              height: 260.0,
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: CustomCupertinoPicker(
                        itemExtent: 32.0,
                        backgroundColor: Colors.white,
                        // useMagnifier: true,
                        onSelectedItemChanged: (value) => toggleDivision(value),
                        children: new List<Widget>.generate(divisionList.length,
                            (index) {
                          return new Center(
                            child:
                                new Text(divisionList[index]['division_name']),
                          );
                        })),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 1, color: ColorsCustom.softGrey))),
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                          height: 40,
                          child: TextButton(
                            style: TextButton.styleFrom(),
                            //materialTapTargetSize:
                            //materialTapTargetSize.shrinkWrap,
                            // color: Colors.white,
                            onPressed: () => Navigator.pop(context),
                            child: CustomText(
                              AppTranslations.of(context).currentLanguage ==
                                      'id'
                                  ? "Batalkan"
                                  : "Cancel",
                              color: ColorsCustom.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        )),
                        Container(
                            width: 1, height: 40, color: ColorsCustom.softGrey),
                        Expanded(
                            child: SizedBox(
                          height: 40,
                          child: TextButton(
                            style: TextButton.styleFrom(),
                            //materialTapTargetSize:
                            //materialTapTargetSize.shrinkWrap,
                            // color: Colors.white,
                            onPressed: () {
                              selectedDivision == null
                                  ? toggleDivision(0)
                                  : print(selectedDivision);
                              Navigator.pop(context);
                            },
                            child: CustomText(
                              AppTranslations.of(context).currentLanguage ==
                                      'id'
                                  ? "Selesai"
                                  : "Done",
                              color: ColorsCustom.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          );
        });
  }

  void onVerify(mode) {
    print("verify" + mode);
  }

  void toggleDivision(int value) {
    setState(() {
      selectedDivision = value;
    });
  }

  void clearFile() {
    setState(() {
      file = null;
    });
  }

  void clearFullName() {
    setState(() {
      fullnameController.clear();
    });
  }

  Future<void> onSuccess() async {
    showDialog(
        context: context,
        barrierColor: Colors.white24,
        builder: (BuildContext context) {
          return CustomToast(
            image: "success_icon_white.svg",
            title: "Update Profile Successfully",
            color: ColorsCustom.primaryGreen,
            duration: Duration(seconds: 3),
          );
        });
  }

  void setError({String type, String value}) {
    setState(() {
      if (type == 'phoneNumber') {
        errorPhoneNumber = value;
      } else if (type == 'email') {
        errorEmail = value;
      } else if (type == 'nip') {
        errorNip = value;
      } else if (type == 'division') {
        errorDivision = value;
      } else if (type == 'fullname') {
        errorFullname = value;
      } else if (type == 'file') {
        errorFile = value;
      }
      isLoading = false;
    });
  }

  void clearError(String type) {
    setState(() {
      if (type == 'phoneNumber') {
        errorPhoneNumber = "";
      } else if (type == 'email') {
        errorEmail = "";
      } else if (type == 'nip') {
        errorEmail = "";
      } else if (type == 'division') {
        errorDivision = "";
      } else if (type == 'fullname') {
        errorFullname = "";
      } else if (type == 'file') {
        errorFile = "";
      }
    });
  }

  Future<void> uploadImage() async {
    try {
      dynamic res = await Providers.uploadImage(file: file);
      print(res.data);
      setState(() {
        fileName = res.data['filename'];
      });
    } catch (e) {
      setError(type: 'file', value: e.toString());
    }
  }

  Future<void> onSubmit() async {
    if (fullnameController.text.length <= 0) {
      setError(type: "fullname", value: "Please fill in your full name");
    }

    if (errorFullname == "") {
      toggleLoading(true);
      try {
        if (file != null) {
          await uploadImage();
        }
        print(fileName);
        dynamic res = await Providers.updateUser(
          name: fullnameController.text,
          photo: fileName == "" ? null : fileName,
          nip: nipController.text,
        );

        print(res);

        if (res.data['code'] == 'SUCCESS') {
          Navigator.pop(context);
          onSuccess();
        } else {
          if (res.data['message'].contains("name")) {
            setError(type: "name", value: Utils.inCaps(res.data['message']));
          } else if (res.data['message'].contains("phone_number")) {
            setError(
                type: "phoneNumber",
                value: Utils.inCaps(res.data['message'][0]));
          } else if (res.data['message'].contains("email")) {
            setError(type: "email", value: Utils.inCaps(res.data['message']));
          } else if (res.data['message'].contains("email")) {
            setError(type: "email", value: Utils.inCaps(res.data['message']));
          }
          // else {
          //   setError(
          //       type: "register",
          //       value: res.data['message'][0].toUpperCase() +
          //           res.data['message'].substring(1));
          // }
        }
      } catch (e) {
        print(e);
        // setError(type: "register", value: e.toString());
      } finally {
        toggleLoading(false);
      }
    }
  }

  Future<void> initDivision() async {
    try {
      dynamic res = await Providers.getDivision();

      setState(() {
        divisionList = res.data['data'];
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        selectedDivision = divisionList.indexWhere((element) =>
            element['division_id'] ==
            store.state.userState.userDetail['division']['division_id']);
      });
    }
  }

  Future<bool> onWillPop() async {
    if (store.state.userState.userDetail['name'] != fullnameController.text ||
        store.state.userState.userDetail['photo'] != fileName) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: CustomText(
              AppTranslations.of(context).currentLanguage == 'id'
                  ? "Konfirmasi"
                  : 'Confirmation',
              color: ColorsCustom.black,
            ),
            content: CustomText(
              AppTranslations.of(context).currentLanguage == 'id'
                  ? 'Perubahan Anda belum disimpan, apakah Anda yakin ingin kembali?'
                  : 'Your changes have not been saved, are you sure want to go back?',
              color: ColorsCustom.generalText,
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: CustomText(
                  AppTranslations.of(context).currentLanguage == 'id'
                      ? "Ya"
                      : 'Yes',
                  color: ColorsCustom.black,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () => Navigator.pop(context),
                child: CustomText(
                  AppTranslations.of(context).currentLanguage == 'id'
                      ? "Tidak"
                      : 'No',
                  color: ColorsCustom.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
      );
      return false;
    } else {
      Navigator.pop(context);
      return false;
    }
  }

  String makeSpaceString() {
    String _temp = store.state.userState.userDetail['phone_number'];

    // if (_temp == null) {
    //   return "";
    // }

    if (_temp.contains(" ")) {
      return _temp;
    } else {
      var buffer = new StringBuffer();
      for (int i = 0; i < _temp.length; i++) {
        buffer.write(_temp[i]);
        int nonZeroIndex = i + 1;
        if (nonZeroIndex % 4 == 0 && nonZeroIndex != _temp.length) {
          buffer.write(' ');
        }
      }
      var string = buffer.toString();

      return string;
    }
  }

  void initData() {
    try {
      setState(() {
        nipController = TextEditingController(
            text: store.state.userState.userDetail['nip']);
        fullnameController = TextEditingController(
            text: store.state.userState.userDetail['name']);
        emailController = TextEditingController(
            text: store.state.userState.userDetail['email']);
        phoneNumberController = TextEditingController(text: makeSpaceString());
        selectedDivisionName =
            store.state.userState.userDetail['division']['division_name'];
        fileName = store.state.userState.userDetail['photo'];
      });
      print(store.state.userState.userDetail);
    } catch (e) {
      print(e.toString());
    } finally {
      toggleLoading(false);
    }
  }

  @override
  void initState() {
    initDivision();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store = StoreProvider.of<AppState>(context);
      initData();
    });
  }
}
