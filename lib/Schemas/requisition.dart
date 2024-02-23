import '../Schemas/requisitionLineItem.dart';
class Requisition {
  final int reqID;
  final int locationID;
  final DateTime reqDate;
  final String user;
  final List<RequisitionLineItem> lineItems;
  final String userRemarks;
  final String approver;
  final String approverRemarks;
  final String status;
  final String procurementRemarks;
  final DateTime? procurementCompletedOn;
  final DateTime? closureDate;
  final String powerAppsId;

  Requisition({
    required this.reqID,
    required this.locationID,
    required this.reqDate,
    required this.user,
    required this.lineItems,
    required this.userRemarks,
    required this.approver,
    required this.approverRemarks,
    required this.status,
    required this.procurementRemarks,
    this.procurementCompletedOn,
    this.closureDate,
    required this.powerAppsId,
  });

  factory Requisition.fromJson(Map<String, dynamic> json) {
    // Convert line items list from JSON to List<RequisitionLineItem>
    List<dynamic> lineItemsJson = json['lineItems'] ?? [];
    List<RequisitionLineItem> lineItems = lineItemsJson.map((itemJson) => RequisitionLineItem.fromJson(itemJson)).toList();

    return Requisition(
      reqID: json['reqID'],
      locationID: json['locationID'],
      reqDate: DateTime.parse(json['reqDate']),
      user: json['user'],
      lineItems: lineItems,
      userRemarks: json['userRemarks'] ?? '',
      approver: json['approver'] ?? '',
      approverRemarks: json['approverRemarks'] ?? '',
      status: json['status'] ?? '',
      procurementRemarks: json['procurementRemarks'] ?? '',
      procurementCompletedOn: json['procurementCompletedOn'] != null ? DateTime.parse(json['procurementCompletedOn']) : null,
      closureDate: json['closureDate'] != null ? DateTime.parse(json['closureDate']) : null,
      powerAppsId: json['powerAppsId'] ?? '',
    );
  }
}
