// ignore_for_file: avoid_print, prefer_const_constructors, use_build_context_synchronously

import 'package:admin/users/update_users.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class GetAllUsers extends StatefulWidget {
  const GetAllUsers({super.key});

  @override
  State<GetAllUsers> createState() => _GetAllUsersState();
}

class _GetAllUsersState extends State<GetAllUsers> {
  List<Map<String, dynamic>> users = [];
  String? token;
  late GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    initAsync();
  }

  void initAsync() async {
    await getToken();
    fetchData();
  }

  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedToken = prefs.getString('token');
    setState(() {
      token = storedToken;
    });
    print(token);
  }

  Future<void> fetchData() async {
    const String apiUrl =
        'http://192.168.43.207:5000/api/user/getusers'; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse the response body
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          users = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Error: ${response.statusCode}');
        print('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
      print('Failed to fetch data');
    }
  }

  Future<void> onRefresh() async {
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Users',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: onRefresh,
        child: Container(
          padding: EdgeInsets.all(size.width * 0.03),
          height: double.infinity,
          width: size.width,
          decoration: const BoxDecoration(color: Colors.blueAccent),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return UserContainer(
                userId: users[index]['_id'],
                firstName: users[index]['Firstname'],
                lastName: users[index]['Lastname'],
                email: users[index]['email'],
                mobile: users[index]['mobile'],
                isBlock: users[index]['isBlocked'],
                token: token!,
                role: users[index]['role'],
              );
            },
          ),
        ),
      ),
    );
  }
}

class UserContainer extends StatefulWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final bool isBlock;
  final String token;
  final String role;

  const UserContainer({
    super.key,
    required this.role,
    required this.token,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.isBlock,
  });

  @override
  State<UserContainer> createState() => _UserContainerState();
}

class _UserContainerState extends State<UserContainer> {
  Future<void> blockUser(String userId) async {
    try {
      String apiUrl =
          'http://192.168.43.207:5000/api/user/block-user?id=$userId';
      String token = widget.token;
      print(apiUrl);
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Handle the success response
        print('Post request successful');
      } else {
        // Handle the error response
        print('Error: ${response.statusCode}');
        print('Failed to make the post request');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }

  Future<void> unBlockUser(String userId) async {
    try {
      String apiUrl =
          'http://192.168.43.207:5000/api/user/unblock-user?id=$userId';
      String token = widget.token;
      print(apiUrl);
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Handle the success response
        print('Post request successful');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User Unblocked!'),
            backgroundColor: Color.fromARGB(255, 243, 33, 86),
          ),
        );
      } else {
        // Handle the error response
        print('Error: ${response.statusCode}');
        print('Failed to make the post request');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Network Error!'),
          backgroundColor: Color.fromARGB(255, 243, 33, 86),
        ),
      );
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Color.fromARGB(255, 243, 33, 86),
        ),
      );
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User ID: ${widget.userId}',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text('Name: ${widget.firstName} ${widget.lastName}'),
          Text('Email: ${widget.email}'),
          Text('Mobile: ${widget.mobile}'),
          Text('Role: ${widget.role}'),
          // Add more user details as needed
          SizedBox(
            height: size.width * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This functionality not completed yet!'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      132, 255, 214, 64), // Set the background color
                ),
                child: Text(
                  'Delete',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateUsers(
                              id: widget.userId,
                              token: widget.token,
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                              mobile: widget.mobile,
                              role: widget.role,
                              emailId: widget.email)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      132, 255, 214, 64), // Set the background color
                ),
                child: Text(
                  'Update',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              widget.isBlock
                  ? ElevatedButton(
                      onPressed: () {
                        unBlockUser(widget.userId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            132, 255, 214, 64), // Set the background color
                      ),
                      child: Text(
                        'Unblock',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        blockUser(widget.userId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User is Blocked!'),
                            backgroundColor: Color.fromARGB(255, 243, 33, 33),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            132, 255, 214, 64), // Set the background color
                      ),
                      child: Text(
                        'Block',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
