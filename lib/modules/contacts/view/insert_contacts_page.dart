// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:app_auth/app_auth.dart';
import 'package:app_core/app_core.dart';
import 'package:app_form_fields/app_form_fields.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneshout/modules/contacts/contacts.dart';

class InsertContactPage extends StatefulWidget with UiLogger {
  InsertContactPage({super.key, this.contact});
  final MyContact? contact;
  @override
  State<InsertContactPage> createState() => _InsertContactPageState();
}

class _InsertContactPageState extends State<InsertContactPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactsCubit(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: ContactFormWidget(contact: widget.contact),
    );
  }
}

class ContactFormWidget extends StatefulWidget {
  const ContactFormWidget({
    super.key,
    this.contact,
  });
  final MyContact? contact;

  @override
  State<ContactFormWidget> createState() => _ContactFormWidgetState();
}

class _ContactFormWidgetState extends State<ContactFormWidget> {
  final List<MyContact> selectedContacts = [];
  final nameTC = TextEditingController();
  final phoneTC = PhoneTextFieldController();
  late PhoneNumber phoneNumber;
  final phoneFN = FocusNode();
  bool dirty = false;
  @override
  void initState() {
    super.initState();
    start();
  }

  void start() {
    if (widget.contact != null) {
      nameTC.text = widget.contact!.name;
      final v = splitNumber(widget.contact!.phone);
      phoneTC
        ..text = v!['phone'].toString()
        ..dialCode = v['code'].toString();
      phoneNumber = PhoneNumber(
        number: v['phone'].toString(),
        countryCode: v['code'].toString(),
        country: '',
        countryISOCode: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // start();
    const styleActive = TextStyle(color: Colors.black, height: 1.2);
    const styleHint = TextStyle(color: Colors.black38, height: 1.2);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contact != null ? 'edit_contact'.tr() : 'add_a_contact'.tr(),
        ),
        // toolbarHeight: 40,
      ),
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Sizes.lg),
          child: Column(
            children: [
              TextField(
                controller: nameTC,
                decoration: const InputDecoration(
                  hintText: "Enter Contact's Full Name",
                  labelText: 'Full Name',
                ),
                onChanged: (v) {
                  setState(() {
                    dirty = true;
                  });
                },
              ),
              VSpace.lg,
              IntlPhoneField(
                decoration: const InputDecoration(
                  hintText: 'Enter Phone Number',
                  labelText: 'Phone number',
                ),
                // flagWidth: 24,
                focusNode: phoneFN,
                dropdownIconPosition: IconPosition.trailing,
                controller: phoneTC,
                onCountryChanged: (value) {
                  // phoneTC.text = value.dialCode;
                  setState(() {
                    dirty = true;
                  });
                },
                onChanged: (phone) {
                  setState(() {
                    phoneNumber = phone;
                    dirty = true;
                  });
                },
                context: context,
                initialCountryCode: 'NG',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryBtn(
                  onPressed: dirty ? insertContact : null,
                  child: Text(getBtnText()),
                ),
              ),
              VSpace.lg,
              SizedBox(
                width: double.infinity,
                child: OutlinedBtn(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('cancel').tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';

  void insertContact() {
    if (nameTC.text.isEmpty || phoneTC.text.isEmpty) {
      return;
    } else {
      Navigator.pop(
        context,
        MyContact(
          name: nameTC.text,
          phone: '${phoneNumber.countryCode}${phoneNumber.number}',
          phoneFormatted: '',
          initials: getInitials(nameTC.text),
          enabled: true,
        ),
      );
    }
  }

  String getBtnText() {
    final count =
        selectedContacts.length > 1 ? 'other' : '=${selectedContacts.length}';

    return widget.contact != null
        ? 'save_contact'.tr()
        : 'add_contact.plural:count.$count'
            .tr(namedArgs: {'count': selectedContacts.length.toString()});
  }

  void contactSelected(MyContact contact) {
    final exists = selectedContacts.indexWhere(
      (e) => e.phone == contact.phone.replaceAll('-', ''),
    );
    if (exists == -1) {
      //insert.
      setState(() => selectedContacts.add(contact));
    } else {
      //remove.
      setState(() {
        selectedContacts.removeWhere((e) => e.phone == contact.phone);
      });
    }
  }

  Map<String, dynamic>? splitNumber(String value) {
    final countryCodes = [
      '+91',
      '+1',
      '+44',
      '+93',
      '+355',
      '+213',
      '+376',
      '+244',
      '+54',
      '+374',
      '+297',
      '+61',
      '+43',
      '+994',
      '+973',
      '+880',
      '+375',
      '+32',
      '+501',
      '+229',
      '+975',
      '+591',
      '+387',
      '+267',
      '+55',
      '+246',
      '+673',
      '+359',
      '+226',
      '+257',
      '+855',
      '+237',
      '+238',
      '+599',
      '+236',
      '+235',
      '+56',
      '+86',
      '+57',
      '+269',
      '+243',
      '+242',
      '+682',
      '+506',
      '+225',
      '+385',
      '+53',
      '+357',
      '+420',
      '+45',
      '+253',
      '+593',
      '+20',
      '+503',
      '+240',
      '+291',
      '+372',
      '+251',
      '+500',
      '+298',
      '+679',
      '+358',
      '+33',
      '+594',
      '+689',
      '+241',
      '+220',
      '+995',
      '+49',
      '+233',
      '+350',
      '+30',
      '+299',
      '+590',
      '+502',
      '+224',
      '+245',
      '+592',
      '+509',
      '+504',
      '+852',
      '+36',
      '+354',
      '+62',
      '+98',
      '+964',
      '+353',
      '+972',
      '+39',
      '+81',
      '+962',
      '+7',
      '+254',
      '+686',
      '+383',
      '+965',
      '+996',
      '+856',
      '+371',
      '+961',
      '+266',
      '+231',
      '+218',
      '+423',
      '+370',
      '+352',
      '+853',
      '+389',
      '+261',
      '+265',
      '+60',
      '+960',
      '+223',
      '+356',
      '+692',
      '+596',
      '+222',
      '+230',
      '+262',
      '+52',
      '+691',
      '+373',
      '+377',
      '+976',
      '+382',
      '+212',
      '+258',
      '+95',
      '+264',
      '+674',
      '+977',
      '+31',
      '+687',
      '+64',
      '+505',
      '+227',
      '+234',
      '+683',
      '+672',
      '+850',
      '+47',
      '+968',
      '+92',
      '+680',
      '+970',
      '+507',
      '+675',
      '+595',
      '+51',
      '+63',
      '+48',
      '+351',
      '+974',
      '+40',
      '+250',
      '+290',
      '+508',
      '+685',
      '+378',
      '+239',
      '+966',
      '+221',
      '+381',
      '+248',
      '+232',
      '+65',
      '+421',
      '+386',
      '+677',
      '+252',
      '+27',
      '+82',
      '+211',
      '+34',
      '+94',
      '+249',
      '+597',
      '+268',
      '+46',
      '+41',
      '+963',
      '+886',
      '+992',
      '+255',
      '+66',
      '+670',
      '+228',
      '+690',
      '+676',
      '+216',
      '+90',
      '+993',
      '+688',
      '+256',
      '+380',
      '+971',
      '+598',
      '+998',
      '+678',
      '+58',
      '+84',
      '+681',
      '+967',
      '+260',
      '+263',
      '+358'
    ];

    for (var i = 0; i < countryCodes.length; i++) {
      if (value.startsWith(countryCodes[i])) {
        return <String, dynamic>{
          'phone': value.replaceAll(countryCodes[i], ''),
          'code': countryCodes[i]
        };
      }
    }
    final formatted = value;
    //value.startsWith('0') ? value.substring(1) : value;
    return {'phone': formatted, 'code': ''};
  }
}
