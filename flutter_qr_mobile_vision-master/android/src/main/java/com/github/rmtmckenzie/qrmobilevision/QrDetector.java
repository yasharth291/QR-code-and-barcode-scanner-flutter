package com.github.rmtmckenzie.qrmobilevision;

import android.util.Log;

import androidx.annotation.GuardedBy;
import androidx.annotation.NonNull;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.mlkit.vision.barcode.Barcode;
import com.google.mlkit.vision.barcode.BarcodeScanner;
import com.google.mlkit.vision.barcode.BarcodeScannerOptions;
import com.google.mlkit.vision.barcode.BarcodeScanning;
import com.google.mlkit.vision.common.InputImage;

import java.util.List;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import android.graphics.Rect;
import java.util.Arrays;
import android.graphics.Point;
/**
 * Allows QrCamera classes to send frames to a Detector
 */

class QrDetector implements OnSuccessListener<List<Barcode>>, OnFailureListener {
    private static final String TAG = "cgr.qrmv.QrDetector";
    private final QrReaderCallbacks communicator;
    private final BarcodeScanner detector;
    Map<String, Object> returnVal = new HashMap<>();
    List<Map<String, Object>> barcodeList = new ArrayList<>();



    public interface Frame {
        InputImage toImage();

        void close();
    }

    @GuardedBy("this")
    private Frame latestFrame;

    @GuardedBy("this")
    private Frame processingFrame;

    QrDetector(QrReaderCallbacks communicator, BarcodeScannerOptions options) {
        this.communicator = communicator;
        this.detector = BarcodeScanning.getClient(options);
    }

    void detect(Frame frame) {
        if (latestFrame != null) latestFrame.close();
        latestFrame = frame;

        if (processingFrame == null) {
            processLatest();
        }
    }

    private synchronized void processLatest() {
        if (processingFrame != null) processingFrame.close();
        processingFrame = latestFrame;
        latestFrame = null;
        if (processingFrame != null) {
            processFrame(processingFrame);
        }
    }

    private void processFrame(Frame frame) {
        InputImage image;
        barcodeList.clear();
        try {
            image = frame.toImage();
        } catch (IllegalStateException ex) {
            // ignore state exception from making frame to image
            // as the image may be closed already.
            return;
        }

        detector.process(image)
            .addOnSuccessListener(this)
            .addOnFailureListener(this);
    }

    @Override
    public void onSuccess(List<Barcode> firebaseVisionBarcodes) {
        List<double[]> points = new ArrayList<>();
        Map<String, Object> typeValue = new HashMap<>();
                  
        if (firebaseVisionBarcodes != null && !firebaseVisionBarcodes.isEmpty()) {
            for (Barcode barcode : firebaseVisionBarcodes) {
                Rect rect = barcode.getBoundingBox();
                Map<String, Object> ret = new HashMap<>();
                ret.put("displayValue", barcode.getDisplayValue());
                ret.put("rawValue", barcode.getRawValue());
                ret.put("valueType", barcode.getValueType());
                ret.put("format", barcode.getFormat());
                ret.put("top", rect.top);
                ret.put("width", rect.width());
                ret.put("left", rect.left);
                ret.put("height", rect.height());
                barcodeList.add(ret);

                if (barcode.getCornerPoints() != null) {
                    for (Point point : barcode.getCornerPoints()) {
                      points.add(new double[] {(double) point.x, (double) point.y});
                    }
                  }
                  ret.put("points",points);

                  switch (barcode.getValueType()) {
                    case Barcode.TYPE_EMAIL:
                      Barcode.Email email = barcode.getEmail();

                      typeValue.put("type", email.getType());
                      typeValue.put("address", email.getAddress());
                      typeValue.put("body", email.getBody());
                      typeValue.put("subject", email.getSubject());

                      ret.put("email", typeValue);
                      break;
                    case Barcode.TYPE_PHONE:
                      Barcode.Phone phone = barcode.getPhone();

                      typeValue.put("number", phone.getNumber());
                      typeValue.put("type", phone.getType());

                      ret.put("phone", typeValue);
                      break;
                    case Barcode.TYPE_SMS:
                      Barcode.Sms sms = barcode.getSms();

                      typeValue.put("message", sms.getMessage());
                      typeValue.put("phoneNumber", sms.getPhoneNumber());

                      ret.put("sms", typeValue);
                      break;
                    case Barcode.TYPE_URL:
                      Barcode.UrlBookmark urlBookmark = barcode.getUrl();

                      typeValue.put("title", urlBookmark.getTitle());
                      typeValue.put("url", urlBookmark.getUrl());

                      ret.put("url", typeValue);
                      break;
                    case Barcode.TYPE_WIFI:
                      Barcode.WiFi wifi = barcode.getWifi();

                      typeValue.put("ssid", wifi.getSsid());
                      typeValue.put("password", wifi.getPassword());
                      typeValue.put("encryptionType", wifi.getEncryptionType());

                      ret.put("wifi", typeValue);
                      break;
                    case Barcode.TYPE_GEO:
                      Barcode.GeoPoint geoPoint = barcode.getGeoPoint();

                      typeValue.put("latitude", geoPoint.getLat());
                      typeValue.put("longitude", geoPoint.getLng());

                      ret.put("geoPoint", typeValue);
                      break;
                    case Barcode.TYPE_CONTACT_INFO:
                      Barcode.ContactInfo contactInfo = barcode.getContactInfo();

                      List<Map<String, Object>> addresses = new ArrayList<>();
                      for (Barcode.Address address : contactInfo.getAddresses()) {
                        Map<String, Object> addressMap = new HashMap<>();
                        if (address.getAddressLines() != null) {
                          addressMap.put("addressLines", Arrays.asList(address.getAddressLines()));
                        }
                        addressMap.put("type", address.getType());

                        addresses.add(addressMap);
                      }
                      typeValue.put("addresses", addresses);

                      List<Map<String, Object>> emails = new ArrayList<>();
                      for (Barcode.Email contactEmail : contactInfo.getEmails()) {
                        Map<String, Object> emailMap = new HashMap<>();
                        emailMap.put("address", contactEmail.getAddress());
                        emailMap.put("type", contactEmail.getType());
                        emailMap.put("body", contactEmail.getBody());
                        emailMap.put("subject", contactEmail.getSubject());

                        emails.add(emailMap);
                      }
                      typeValue.put("emails", emails);

                      Map<String, Object> nameMap = new HashMap<>();
                      Barcode.PersonName name = contactInfo.getName();
                      if (name != null) {
                        nameMap.put("formattedName", name.getFormattedName());
                        nameMap.put("first", name.getFirst());
                        nameMap.put("last", name.getLast());
                        nameMap.put("middle", name.getMiddle());
                        nameMap.put("prefix", name.getPrefix());
                        nameMap.put("pronunciation", name.getPronunciation());
                        nameMap.put("suffix", name.getSuffix());
                      }
                      typeValue.put("name", nameMap);

                      List<Map<String, Object>> phones = new ArrayList<>();
                      for (Barcode.Phone contactPhone : contactInfo.getPhones()) {
                        Map<String, Object> phoneMap = new HashMap<>();
                        phoneMap.put("number", contactPhone.getNumber());
                        phoneMap.put("type", contactPhone.getType());

                        phones.add(phoneMap);
                      }
                      typeValue.put("phones", phones);

                      if (contactInfo.getUrls() != null) {
                        typeValue.put("urls", contactInfo.getUrls());
                      }
                      typeValue.put("jobTitle", contactInfo.getTitle());
                      typeValue.put("organization", contactInfo.getOrganization());

                      ret.put("contactInfo", typeValue);
                      break;
                    case Barcode.TYPE_CALENDAR_EVENT:
                      Barcode.CalendarEvent calendarEvent =
                          barcode.getCalendarEvent();

                      typeValue.put("eventDescription", calendarEvent.getDescription());
                      typeValue.put("location", calendarEvent.getLocation());
                      typeValue.put("organizer", calendarEvent.getOrganizer());
                      typeValue.put("status", calendarEvent.getStatus());
                      typeValue.put("summary", calendarEvent.getSummary());
                      if (calendarEvent.getStart() != null) {
                        typeValue.put("start", calendarEvent.getStart().getRawValue());
                      }
                      if (calendarEvent.getEnd() != null) {
                        typeValue.put("end", calendarEvent.getEnd().getRawValue());
                      }

                      ret.put("calendarEvent", typeValue);
                      break;
                    case Barcode.TYPE_DRIVER_LICENSE:
                      Barcode.DriverLicense driverLicense =
                          barcode.getDriverLicense();

                      typeValue.put("firstName", driverLicense.getFirstName());
                      typeValue.put("middleName", driverLicense.getMiddleName());
                      typeValue.put("lastName", driverLicense.getLastName());
                      typeValue.put("gender", driverLicense.getGender());
                      typeValue.put("addressCity", driverLicense.getAddressCity());
                      typeValue.put("addressStreet", driverLicense.getAddressStreet());
                      typeValue.put("addressState", driverLicense.getAddressState());
                      typeValue.put("addressZip", driverLicense.getAddressZip());
                      typeValue.put("birthDate", driverLicense.getBirthDate());
                      typeValue.put("documentType", driverLicense.getDocumentType());
                      typeValue.put("licenseNumber", driverLicense.getLicenseNumber());
                      typeValue.put("expiryDate", driverLicense.getExpiryDate());
                      typeValue.put("issuingDate", driverLicense.getIssueDate());
                      typeValue.put("issuingCountry", driverLicense.getIssuingCountry());

                      ret.put("driverLicense", typeValue);
                      break;
                  }
            }}
            if(barcodeList.size()>0){
              returnVal.put("containsBarcode", true);
          }
          returnVal.put("barcodes", barcodeList);
          communicator.qrRead(returnVal);
        processLatest();
    }

    @Override
    public void onFailure(@NonNull Exception e) {
        Log.w(TAG, "Barcode Reading Failure: ", e);
    }
}
