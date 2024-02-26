// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../widget/drawer_widget.dart';
import '../Schemas/requisition.dart';
import 'package:blackseaproduct/Schemas/user.dart';

class UserDetails extends StatefulWidget {
  final List<Requisition> requisitions;
  final User user;
  const UserDetails({Key? key, required this.requisitions, required this.user}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Row(
          children: [
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(
                  'assets/images/appbar2.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('User Information'),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 50,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              widget.user.userName ?? '', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.user.jobTitle ?? '', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.user.email ?? '', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
              height: 24,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.requisitions.length,
                itemBuilder: (context, index) {
                  final requisition = widget.requisitions[index];
                  return Container(
                    color: Colors.grey.shade200,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Req ID: ${requisition.reqID}'),
                        const SizedBox(height: 8),
                        Text('Product Name: ${requisition.productName}'),
                        const SizedBox(height: 8),
                        Text('Quantity: ${requisition.quantity}'),
                        const SizedBox(height: 8),
                        Text('Status: ${requisition.status}'),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// String _getStatusTag(List<Requisition> requisitions) {
//     // Check if any requisition has 'Accepted' status
//     if (requisitions.any((requisition) => requisition.status == 'Accepted')) {
//       return 'Requisition Accepted';
//     }
//     // Check if any requisition has 'Rejected' status
//     else if (requisitions.any((requisition) => requisition.status == 'Rejected')) {
//       return 'Requisition Rejected';
//     }
//     // If no 'Accepted' or 'Rejected', default to 'Pending'
//     else {
//       return 'Pending';
//     }
// }

