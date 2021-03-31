import 'package:flutter/material.dart';

export 'qr_barcode.dart';

class Barcode {
  final String displayValue;
  final int format;
  final String rawValue;
  final BarcodeValueType valueType;
  final Rect boundingBox;
  final BarcodeEmail email;
  final BarcodePhone phone;
  final BarcodeSMS sms;
  final BarcodeURL url;
  final BarcodeWiFi wifi;
  final BarcodeGeoPoint geoPoint;
  final BarcodeContactInfo contactInfo;
  final BarcodeCalendarEvent calendarEvent;
  final BarcodeDriverLicense driverLicense;
  final List<Offset> cornerPoints;

  Barcode(
      {this.rawValue,
      this.displayValue,
      this.boundingBox,
      this.calendarEvent,
      this.contactInfo,
      this.cornerPoints,
      this.driverLicense,
      this.email,
      this.format,
      this.geoPoint,
      this.phone,
      this.sms,
      this.url,
      this.valueType,
      this.wifi});

  factory Barcode.fromJson(Map<String, dynamic> json) {
    return Barcode(
      displayValue: json['displayValue'],
      format: json['format'],
      rawValue: json['rawValue'],
      valueType: json['valueType'] != null ? BarcodeValueType.values[json['valueType']] : BarcodeValueType.unknown,
      boundingBox: Rect.fromLTWH(double.parse(json['left'].toString()), double.parse(json['top'].toString()), double.parse(json['width'].toString()), double.parse(json['height'].toString())),
      email: json['email'] != null ? BarcodeEmail.fromJson(Map<String, dynamic>.from(json['email'])) : null,
      calendarEvent: json['calendarEvent'] != null ? BarcodeCalendarEvent.fromJson(Map<String, dynamic>.from(json['calendarEvent'])) : null,
      contactInfo: json['contactInfo'] != null ? BarcodeContactInfo.fromJson(Map<String, dynamic>.from(json['contactInfo'])) : null,
      cornerPoints: json['points'] != null
          ? json['points']
              .map<Offset>((dynamic item) => Offset(
                    item[0],
                    item[1],
                  ))
              .toList()
          : null,
      driverLicense: json['driverLicense'] != null ? BarcodeDriverLicense.fromJson(Map<String, dynamic>.from(json['driverLicense'])) : null,
      geoPoint: json['geoPoint'] != null ? BarcodeGeoPoint.fromJson(Map<String, dynamic>.from(json['geoPoint'])) : null,
      phone: json['phone'] != null ? BarcodePhone.fromJson(Map<String, dynamic>.from(json['phone'])) : null,
      sms: json['sms'] != null ? BarcodeSMS.fromJson(Map<String, dynamic>.from(json['sms'])) : null,
      url: json['url'] != null ? BarcodeURL.fromJson(Map<String, dynamic>.from(json['url'])) : null,
      wifi: json['wifi'] != null ? BarcodeWiFi.fromJson(Map<String, dynamic>.from(json['wifi'])) : null,
    );
  }
}

class BarcodeEmail {
  final String address;
  final String body;
  final String subject;
  final BarcodeEmailType type;

  BarcodeEmail({this.address, this.body, this.subject, this.type});

  factory BarcodeEmail.fromJson(Map<String, dynamic> json) {
    return BarcodeEmail(address: json['address'], body: json['body'], subject: json['subject'], type: BarcodeEmailType.values[json['type']]);
  }
}

class BarcodePhone {
  final String number;

  final BarcodePhoneType type;

  BarcodePhone({this.number, this.type});

  factory BarcodePhone.fromJson(Map<String, dynamic> json) {
    return BarcodePhone(
      number: json['number'],
      type: BarcodePhoneType.values[json['type']],
    );
  }
}

class BarcodeSMS {
  final String message;
  final String phoneNumber;

  BarcodeSMS({this.message, this.phoneNumber});

  factory BarcodeSMS.fromJson(Map<String, dynamic> json) {
    return BarcodeSMS(
      message: json['message'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class BarcodeURL {
  final String title;
  final String url;
  BarcodeURL({this.title, this.url});
  factory BarcodeURL.fromJson(Map<String, dynamic> json) {
    return BarcodeURL(
      title: json['title'],
      url: json['url'],
    );
  }
}

class BarcodeWiFi {
  final String ssid;
  final String password;
  final BarcodeWiFiEncryptionType encryptionType;

  BarcodeWiFi({this.encryptionType, this.password, this.ssid});
  factory BarcodeWiFi.fromJson(Map<String, dynamic> json) {
    return BarcodeWiFi(ssid: json['ssid'], password: json['password'], encryptionType: BarcodeWiFiEncryptionType.values[json['encryptionType']]);
  }
}

class BarcodeGeoPoint {
  final double latitude;
  final double longitude;
  BarcodeGeoPoint({this.latitude, this.longitude});
  factory BarcodeGeoPoint.fromJson(Map<String, dynamic> json) {
    return BarcodeGeoPoint(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class BarcodeContactInfo {
  final List<BarcodeAddress> addresses;
  final List<BarcodeEmail> emails;
  final BarcodePersonName name;
  final List<BarcodePhone> phones;
  final List<String> urls;
  final String jobTitle;
  final String organization;
  BarcodeContactInfo({this.addresses, this.emails, this.jobTitle, this.name, this.phones, this.organization, this.urls});

  factory BarcodeContactInfo.fromJson(Map<String, dynamic> json) {
    var addressList = json['addresses'] as List;
    List<BarcodeAddress> addressses = addressList.map((i) => BarcodeAddress.fromJson(Map<String, dynamic>.from(i))).toList();

    var emailList = json['emails'] as List;
    List<BarcodeEmail> emails = emailList.map((i) => BarcodeEmail.fromJson(Map<String, dynamic>.from(i))).toList();

    var phoneList = json['phones'] as List;
    List<BarcodePhone> phones = phoneList.map((i) => BarcodePhone.fromJson(Map<String, dynamic>.from(i))).toList();

    return BarcodeContactInfo(
        addresses: addressses,
        emails: emails,
        phones: phones,
        urls: json['urls'].map<String>((dynamic item) {
          final String s = item;
          return s;
        }).toList(),
        jobTitle: json['jobTitle'],
        name: BarcodePersonName.fromJson(Map<String, dynamic>.from(json['name'])),
        organization: json['organization']);
  }
}

class BarcodeAddress {
  final List<String> addressLines;

  final BarcodeAddressType type;

  BarcodeAddress({this.addressLines, this.type});
  factory BarcodeAddress.fromJson(Map<String, dynamic> json) {
    return BarcodeAddress(
      addressLines: json['addressLines'].map<String>((dynamic item) {
        final String s = item;
        return s;
      }).toList(),
      type: BarcodeAddressType.values[json['type']],
    );
  }
}

class BarcodePersonName {
  final String formattedName;
  final String first;
  final String last;
  final String middle;
  final String prefix;
  final String pronunciation;
  final String suffix;
  BarcodePersonName({this.first, this.formattedName, this.last, this.middle, this.prefix, this.pronunciation, this.suffix});
  factory BarcodePersonName.fromJson(Map<String, dynamic> json) {
    return BarcodePersonName(
      formattedName: json['formattedName'],
      first: json['first'],
      last: json['last'],
      middle: json['middle'],
      prefix: json['prefix'],
      pronunciation: json['pronunciation'],
      suffix: json['suffix'],
    );
  }
}

class BarcodeCalendarEvent {
  final String eventDescription;
  final String location;
  final String organizer;
  final String status;
  final String summary;
  final String start;
  final String end;
  BarcodeCalendarEvent({this.end, this.eventDescription, this.location, this.organizer, this.start, this.status, this.summary});

  factory BarcodeCalendarEvent.fromJson(Map<String, dynamic> json) {
    return BarcodeCalendarEvent(
      eventDescription: json['eventDescription'],
      location: json['location'],
      organizer: json['organizer'],
      status: json['status'],
      summary: json['summary'],
      start: json['start'],
      end: json['end'],
    );
  }
}

class BarcodeDriverLicense {
  final String firstName;
  final String middleName;
  final String lastName;
  final String gender;
  final String addressCity;
  final String addressState;
  final String addressStreet;
  final String addressZip;
  final String birthDate;
  final String documentType;
  final String licenseNumber;
  final String expiryDate;
  final String issuingDate;
  final String issuingCountry;

  BarcodeDriverLicense(
      {this.addressCity,
      this.addressState,
      this.addressStreet,
      this.addressZip,
      this.birthDate,
      this.documentType,
      this.expiryDate,
      this.firstName,
      this.gender,
      this.issuingCountry,
      this.issuingDate,
      this.lastName,
      this.licenseNumber,
      this.middleName});

  factory BarcodeDriverLicense.fromJson(Map<String, dynamic> json) {
    return BarcodeDriverLicense(
      addressCity: json['addressCity'],
      addressState: json['addressState'],
      addressStreet: json['addressStreet'],
      addressZip: json['addressZip'],
      birthDate: json['birthDate'],
      documentType: json['documentType'],
      expiryDate: json['expiryDate'],
      firstName: json['firstName'],
      gender: json['gender'],
      issuingCountry: json['issuingCountry'],
      issuingDate: json['issuingDate'],
      lastName: json['lastName'],
      licenseNumber: json['licenseNumber'],
      middleName: json['middleName'],
    );
  }
}

enum BarcodeValueType {
  unknown,
  contactInfo,
  email,
  isbn,
  phone,
  product,
  sms,
  text,
  url,
  wifi,
  geographicCoordinates,
  calendarEvent,
  driverLicense,
}

enum BarcodeEmailType {
  unknown,
  work,
  home,
}

enum BarcodePhoneType {
  unknown,
  work,
  home,
  fax,
  mobile,
}

enum BarcodeWiFiEncryptionType {
  unknown,
  open,
  wpa,
  wep,
}

enum BarcodeAddressType {
  unknown,
  work,
  home,
}
