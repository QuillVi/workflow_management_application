import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_flow/viewmodels/job_view_model/load_job_view_model.dart';
import 'package:work_flow/views/jobs_view/info_job.dart';
import 'package:work_flow/views/tasks_view/create_task.dart';

class Job extends StatefulWidget {
  const Job({super.key});

  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoadJobViewModel>().fetchJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<LoadJobViewModel>(context);
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
                viewmodel.toggleEditing();
              },
              child: viewmodel.isEditing
                  ? TextFormField(
                      initialValue: viewmodel.title,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      autofocus: true,
                      onFieldSubmitted: (value) {
                        viewmodel.updateTitle(value);
                      },
                    )
                  : Text(
                      viewmodel.title,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTask(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.add, color: Colors.blue),
                      SizedBox(height: 5),
                      Container(
                        width: 120,
                        height: 20,
                        child: Text(
                          'Tạo Task',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {},
                  child: Column(
                    children: [
                      Icon(Icons.delete_outline_outlined, color: Colors.red),
                      SizedBox(height: 5),
                      Container(
                        width: 120,
                        height: 20,
                        child: Text(
                          'Xoá Task',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Consumer<LoadJobViewModel>(
              builder: (context, viewmodel, child) {
                if (viewmodel.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (viewmodel.jobs.isEmpty) {
                  return Center(child: Text('Không có công việc nào.'));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: viewmodel.jobs.length,
                    itemBuilder: (context, index) {
                      final job = viewmodel.jobs[index];
                      final jobName = job['NameJob'] ?? 'Không có tên dự án';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoJob(
                                jobId: job['IDJob'] ?? '',
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  jobName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
