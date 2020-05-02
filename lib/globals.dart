import 'package:flutter/material.dart';
//memberNo is member table primary key
//memberID is member RFID card number
//memberLoginID is member login account number

int memberNo,memberTypeNo, memberLevelNo,memberPoint;
String memberLoginID,memberID,memberName,memberRegisterDate,memberExpireDate,memberLevelName,memberPhoto;

Divider myDivider=Divider(color: Colors.blueGrey,);
//String localServerLink = 'http://192.168.1.5:8080/fitnessConcepts/';
//String localServerLink ='http://localhost:8080/fitnessConcepts/';
//String serverLink = 'http://192.168.100.32:90/fitnessConcepts/';
//String serverLink = 'http://192.168.1.10:8080/fitnessConcepts/';

//mdy fitness
String localServerLink = 'http://192.168.1.10:90/fitnessConcepts/';
//internet server link
String internetServerLink = 'https://unityitsolutionprovider.com/fitnessConceptsInternet/';
const weightTblSqlite='BodyWeight';
const userProfileTblSqlite='UserProfile';
