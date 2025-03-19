import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_flow/viewmodels/stage_view_model.dart/info_stage_view_model.dart';

class Stages extends StatefulWidget {
  final dynamic stageId;

  const Stages({super.key, required this.stageId});

  @override
  State<Stages> createState() => _StagesState();
}

class _StagesState extends State<Stages> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        context.read<InfoStageViewModel>().loadStageInfo(widget.stageId));
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
        title: Consumer<InfoStageViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    viewModel.toggleEditing();
                  },
                  child: viewModel.isEditing
                      ? TextFormField(
                          initialValue: viewModel.title,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          onFieldSubmitted: (value) {
                            viewModel.updateTitle(value);
                            viewModel.toggleEditing();
                          },
                        )
                      : Text(
                          viewModel.title,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Consumer<InfoStageViewModel>(
        builder: (context, viewModel, child) {
          print('Dữ liệu của stageInfo: ${viewModel.stageInfo}');

          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage.isNotEmpty) {
            return Center(child: Text(viewModel.errorMessage));
          }

          if (viewModel.stageInfo == null) {
            return Center(child: Text("Dữ liệu Stage chưa có."));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stage Info:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text('Stage ID: ${viewModel.stageInfo!['IdStage']}'),
                  Text('Stage Name: ${viewModel.stageInfo!['NameStage']}'),
                  Text(
                      'Description: ${viewModel.stageInfo!['DescriptionStatus'] ?? 'Không có mô tả'}'),
                  Text(
                      'Previous Stage: ${viewModel.stageInfo!['previousStage'] ?? 'Không có'}'),
                  Text(
                      'Next Stage: ${viewModel.stageInfo!['nextStage'] ?? 'Không có'}'),
                  Text(
                      'Recipient Email: ${viewModel.stageInfo!['EmailRecipient']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
