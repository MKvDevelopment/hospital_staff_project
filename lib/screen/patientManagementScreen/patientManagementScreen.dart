import 'package:flutter/material.dart';
import 'package:hospital_staff_project/common_code/custom_text_style.dart';
import 'package:hospital_staff_project/constants.dart';
import 'package:hospital_staff_project/provider/StudentProvider.dart';
import 'package:hospital_staff_project/screen/auth/EmployeModel.dart';
import 'package:hospital_staff_project/screen/auth/StudentModel.dart';
import 'package:provider/provider.dart';

import '../../route_constants.dart';

class PatientManagementScreen extends StatefulWidget {
  const PatientManagementScreen({super.key});

  @override
  State<PatientManagementScreen> createState() =>
      _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<StudentModel> searchResults = [];
  bool _isSearching = false; // To toggle the search field visibility

  late StudentProvider studentProvider;


@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchAllStudents();
  }
  @override
  void initState() {
    super.initState();
    Constants().backButtonDisabled(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        // Define margins and paddings based on screen size
        double horizontalMargin = screenWidth * 0.02;
        double verticalMargin = screenHeight * 0.02;
        double padding = screenWidth * 0.01;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            title: _isSearching
                ? TextField(
                  controller: _searchController,
                  cursorColor: Colors.white,
                  style: CustomTextStyles.titleMedium.copyWith(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by Mobile No.',
                    hintStyle: CustomTextStyles.titleMedium.copyWith(color: Colors.white),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),

                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),

                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),

                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear,color: Colors.white,),
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          _searchController.clear(); // Clear text
                          searchResults = []; // Reset search results
                          studentProvider.notifyListeners();
                        } else {
                          _toggleSearch(); // Collapse search bar
                        }
                      },
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      searchResults =
                          studentProvider.searchStudentsByMobile(query);
                     // studentProvider.notifyListeners(); // Trigger UI update
                    });
                  },
                )
                : const Text('Patient Management'),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search),
                onPressed: _toggleSearch,
              ),
              const SizedBox(width: 10,),
              IconButton(
                icon: const Icon( Icons.refresh),
                onPressed: () {
                  fetchAllStudents();
                },
              ),
              const SizedBox(width: 10,),
            ],
          ),

          body: Consumer<StudentProvider>(
            builder: (context, studentProvider, child) {
              if(studentProvider.isLoading){
                return  Container(
                  color: Colors.black54, // Optional dimmed background
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.red,),
                  ),
                );
              }
              if (searchResults.isEmpty) {
                if (studentProvider.studentList.isEmpty) {
                  return Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'No students found'
                          : 'No results match your query',
                      style: CustomTextStyles.titleLarge,
                    ),
                  );
                } else {
                  searchResults = studentProvider.studentList;
                  // studentProvider.notifyListeners();
                }
              }
              return Stack(
                children: [
                  ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (ctx, i) {
                      final student = searchResults[i];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalMargin, vertical: 1),
                        child: InkWell(
                          onTap: () {
                            Constants.userSearchId = student.studentId;
                            Navigator.pushNamed(
                              context,
                              studentDetailScreenRoute,
                              arguments: {'studentId': student.studentId},
                            );
                          },
                          child: Card(
                            surfaceTintColor: Colors.white,
                            elevation: 5,
                            color: Theme.of(context).primaryColorLight,
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: Row(
                                children: [
                                  SizedBox(width: horizontalMargin),
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Text(
                                      student.name.isNotEmpty
                                          ? student.name[0]
                                          : 'A',
                                    ),
                                  ),
                                  SizedBox(width: horizontalMargin),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name: ${student.name}',
                                          style: CustomTextStyles.titleSmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Mobile No: ${student.mobileNo}',
                                          style: CustomTextStyles.titleSmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Role: ${student.email}',
                                          style: CustomTextStyles.titleSmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Branch: ${student.branch}',
                                          style: CustomTextStyles.titleSmall,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (studentProvider.isLoading)
                    Container(
                      color: Colors.black54, // Optional dimmed background
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white,),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _toggleSearch() {
    setState(() {
      if (_isSearching) {
        _searchController.clear(); // Clear text when hiding search
        searchResults = [];
      }
      _isSearching = !_isSearching;
    });
  }

  void fetchAllStudents() {
    studentProvider = Provider.of<StudentProvider>(context, listen: false);
    //studentProvider.fetchAllStudents();
    try {
      studentProvider.fetchAllStudents();
    } catch (e, stackTrace) {
      flushBarErrorMsg(context, 'Error', 'Error in fetchAllStudents');
      print('Error in fetchAllStudents: $e\n$stackTrace');
    }

  }
}
