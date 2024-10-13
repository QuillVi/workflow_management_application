import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:work_flow/api_constants.dart';

class InfoJob extends StatefulWidget {
  final dynamic jobId;
  const InfoJob({super.key, required this.jobId});

  @override
  State<InfoJob> createState() => _InfoJobState();
}

class _InfoJobState extends State<InfoJob> {
  bool _isEditing = false;
  String _title = '';

  Job? job;

  Future<void> _loadJobs() async {
    final token = await _getToken();

    if (token != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/job/${widget.jobId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _title = jsonData['NameJob'] ?? 'No Title';
        });
      } else {
        print('Failed to load jobs');
      }
    } else {
      print('Token not found');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                child: _isEditing
                    ? TextFormField(
                        initialValue: _title,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        onFieldSubmitted: (value) {
                          setState(() {
                            _title = value;
                            _isEditing = false;
                          });
                        },
                      )
                    : Text(
                        _title,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Text('data'),
          ],
        ));
  }
}

class Job {
  final String IDJob;
  final String NameJob;
  Job({required this.IDJob, required this.NameJob});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      IDJob: json['IDJob'],
      NameJob: json['NameJob'],
    );
  }
}
