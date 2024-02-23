import 'package:flutter/material.dart'; // Add this import statement

import '../Schemas/requisition.dart'; // Import the Requisition class


class RequisitionDetailsView extends StatelessWidget {
  final Requisition requisition;

  const RequisitionDetailsView({Key? key, required this.requisition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requisition Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Req ID: ${requisition.reqID}'),
            Text('User: ${requisition.user}'),
            // Add more details here as needed
          ],
        ),
      ),
    );
  }
}
