import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/custom_admin_drawer_widget.dart';
import '../../contollers/add_product_controller.dart';

class AdminMainScreen extends StatefulWidget {

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}
class _AdminMainScreenState extends State<AdminMainScreen> {
  AddProductController addProductController=Get.put(AddProductController());

  Stream<int> getAllOrders() {
    return FirebaseFirestore.instance
        .collectionGroup('confirmOrders')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      drawer: CustomAdminDrawerWidget(),
    body: Column(
      children: [
        StreamBuilder<int>(
          stream: getAllOrders(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading...");
            }else if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }else {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: Text("Total Orders: ${snapshot.data}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'Inter'),));
            }
          },
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collectionGroup('confirmOrders') // Searches all subcollections named 'confirmOrders'
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No Orders Found');
              }

              final orders = snapshot.data!.docs;


              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final data = orders[index].data() as Map<String, dynamic>;
                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min, // This ensures the row doesn't take up unnecessary space
                      children: [
                        Text('${index + 1}',style: TextStyle(fontSize: 12),),
                        SizedBox(width: 8), // Adding some spacing between the text and image
                        Container(
                          height: 40,
                          width: 40,
                          child: Image.network(
                            data['productImages'][0] ?? '', // Make sure this is not null or empty
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // Handle errors
                          ),
                        ),
                      ],
                    ),
                    title: Text(data['productName'],style: TextStyle(fontFamily: 'Inter',fontSize: 16),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Customer Name:-',style: TextStyle(fontFamily:'Inter',fontSize: 12),),
                            Text(data['customerName'],style: TextStyle(fontFamily:'Inter',fontSize: 12,fontWeight: FontWeight.w500),),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Status:-',style: TextStyle(fontFamily:'Inter',fontSize: 12),),
                            (data['status']==true)
                                ?Text('Delivered...',style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.bold,color: Colors.lightGreen,fontSize: 12),)
                                :Text('Pending...',style: TextStyle(fontFamily: 'Inter',color: Colors.red,fontSize: 12),),
                          ],
                        )
                      ],
                    ),

                    trailing: (data['isSale']==true)
                    ?Text('₹ '+data['salePrice'].toString(),style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.bold,color: Colors.green,fontSize: 12))
                    :Text('₹ '+data['fullPrice'].toString(),style: TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.bold,color: Colors.green,fontSize: 12)),
                  );
                },
              );
            },
          ),
        )
      ],
    ),
    );
  }
}