import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_project/common_code/custom_text_style.dart';
import 'package:hospital_staff_project/common_code/custome_text_form_field.dart';
import 'package:hospital_staff_project/screen/ambulanceDriver/DriverModel.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../provider/DriverProvider.dart';

class DriverManagementPage extends StatefulWidget {
  const DriverManagementPage({super.key});

  @override
  State<DriverManagementPage> createState() => _DriverManagementPageState();
}

class _DriverManagementPageState extends State<DriverManagementPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchAllDriver();
  }
  @override
  void initState() {
    super.initState();
    Constants().backButtonDisabled(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      // Define margins and paddings based on screen size
      double horizontalMargin = screenWidth * 0.02; // 5% of screen width
      double verticalMargin = screenHeight * 0.02; // 2% of screen height
      double padding = screenWidth * 0.01; // 3% of screen width

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          title: Text(
            'My Ambulance Driver',
            style: CustomTextStyles.titleMedium.copyWith(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  fetchAllDriver();
                },
                icon: const Icon(Icons.refresh)),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body:
            Consumer<DriverProvider>(builder: (context, driverProvider, child) {
          return Stack(
            children: [
              ListView.builder(
                itemCount: driverProvider.drivers.length,
                itemBuilder: (ctx, i) {
                  final driver = driverProvider.drivers[i];
                  return Padding(
                    padding: EdgeInsets.all(padding),
                    child: InkWell(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (context) => _buildDriverDialog(context, driver),
                        );
                      },
                      child: Card(
                          surfaceTintColor: Colors.white,
                          elevation: 5,
                          color: Theme.of(context).cardColor,
                          child: Padding(
                            padding: EdgeInsets.all(padding),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: horizontalMargin,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Text(
                                    driver.name.isEmpty?'A':driver.name[0].toUpperCase(),
                                    style: CustomTextStyles.titleMedium,
                                  ),
                                ),
                                SizedBox(
                                  width: horizontalMargin,
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          maxLines: 1,
                                          minFontSize: 12,
                                          softWrap: true,
                                          'Name : ${driver.name}',
                                          style: CustomTextStyles.titleMedium
                                              .copyWith(fontSize: 20),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        AutoSizeText(
                                          minFontSize: 12,
                                          maxLines: 1,
                                          softWrap: true,
                                          'Mobile No : ${driver.mobileNo}',
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyles.titleSmall
                                              .copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        AutoSizeText(
                                          minFontSize: 12,
                                          softWrap: true,
                                          maxLines: 1,
                                          'Vehicle No : ${driver.vehicleNo}',
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyles.titleSmall
                                              .copyWith(color: Colors.grey),
                                        ),
                                        AutoSizeText(
                                          minFontSize: 12,
                                          maxLines: 1,
                                          softWrap: true,
                                          'Address : ${driver.address}',
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyles.titleSmall
                                              .copyWith(color: Colors.grey),
                                        ),
                                      ]),
                                ),
                                const Spacer(),
                                screenWidth <= 600
                                    ? Container()
                                    : Column(
                                  children: [
                                    Text(
                                      driver.status,
                                      style: CustomTextStyles.titleSmall
                                          .copyWith(
                                          color: driver.status ==
                                              'Online'
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: AppBarTheme.of(context)
                                                .backgroundColor,
                                          ),
                                          onPressed: () =>
                                              _showEditDriverDialog(
                                                  context,
                                                  driverProvider,
                                                  driver),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: AppBarTheme.of(context)
                                                .backgroundColor,
                                          ),
                                          onPressed: () =>
                                              driverProvider.deleteDriver(
                                                  driver.driverId),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),
                  );
                },
              ),
              if (driverProvider.isLoading)
                Container(
                  color: Colors.black54, // Optional dimmed background
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.red,),
                  ),
                ),
            ],
          );
        }),
      );
    });
  }

  Widget _buildDriverDialog(BuildContext parentContext, DriverModel driver) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        width: 650,
        height: 250,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.blue,
              child: Image.asset(
                "assets/images/gents.png",
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      driver.name,
                      style: CustomTextStyles.titleLarge,
                    ),
                    const Divider(color: Colors.grey,height: 1,),
                    Text(
                      'Mobile No: ${driver.mobileNo}',
                      style: CustomTextStyles.titleMedium,
                    ),
                    const Divider(color: Colors.grey,height: 1,),
                    Text(
                      'Email: ${driver.email}',
                      style: CustomTextStyles.titleMedium,
                    ),
                    const Divider(color: Colors.grey,height: 1,),
                    Text(
                      'Experience: ${driver.experience} years',
                      style: CustomTextStyles.titleMedium,
                    ),
                    const Divider(color: Colors.grey,height: 1,),
                    Text(
                      'Vehicle No: ${driver.vehicleNo}',
                      style: CustomTextStyles.titleMedium,
                    ),
                    const Divider(color: Colors.grey,height: 1,),
                    Text(
                      'Status: ${driver.status}',
                      style: CustomTextStyles.titleMedium,
                    ),
                    const Divider(color: Colors.grey,height: 1,),
                    Text(
                      'Address: ${driver.address}',
                      style: CustomTextStyles.titleMedium,
                    ),
                    const Divider(color: Colors.grey,height: 1,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showEditDriverDialog(
      BuildContext context, DriverProvider provider, DriverModel driver) {
    final nameController = TextEditingController(text: driver.name);
    final phoneController = TextEditingController(text: driver.mobileNo);
    final addController = TextEditingController(text: driver.address);
    final emailController = TextEditingController(text: driver.email);
    final vhecialController = TextEditingController(text: driver.vehicleNo);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Edit Driver Details',
          style: CustomTextStyles.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              labelText: 'Name',
              hintText: 'Enter Driver Name',
              controller: nameController,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTextFormField(
              controller: phoneController,
              labelText: 'Phone Number',
              hintText: 'Enter Phone Number',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTextFormField(
              controller: vhecialController,
              labelText: 'Vehicle No',
              hintText: 'Enter Vehicle No',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTextFormField(
              controller: addController,
              labelText: 'Address',
              hintText: 'Enter Address',
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTextFormField(
              controller: emailController,
              labelText: 'Email',
              hintText: 'Enter Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: CustomTextStyles.titleSmall,
            ),
          ),
          TextButton(
            onPressed: () {
              final updatedDriver = DriverModel(
                driverId: driver.driverId,
                name: nameController.text,
                mobileNo: phoneController.text,
                email: emailController.text,
                status: driver.status,
                address: addController.text,
                experience: driver.experience,
                vehicleNo: vhecialController.text,
              );
              provider.updateDriver(driver.driverId, updatedDriver);
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Update',
              style: CustomTextStyles.titleSmall,
            ),
          ),
        ],
      ),
    );
  }

  void fetchAllDriver() {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    driverProvider.fetchDrivers();
  }

  // void addDriver(DriverModel model) {
  //   final driverProvider = Provider.of<DriverProvider>(context, listen: false);
  //   driverProvider.addDriver(model);
  // }
}
