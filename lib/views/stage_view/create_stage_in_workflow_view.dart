import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_flow/viewmodels/stage_view_model.dart/create_stage_client_view_model.dart';
import 'package:work_flow/viewmodels/stage_view_model.dart/fecth_name_workflow_view_model.dart';

class CreateStageInWorkflow extends StatefulWidget {
  final dynamic workflowId;
  const CreateStageInWorkflow({super.key, required this.workflowId});

  @override
  State<CreateStageInWorkflow> createState() => _CreateStageInWorkflowState();
}

class _CreateStageInWorkflowState extends State<CreateStageInWorkflow> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context
        .read<FecthNameWorkflowViewModel>()
        .fetchNameWorkflow(widget.workflowId));
  }

  @override
  Widget build(BuildContext context) {
    final viewModelCreateStage = context.watch<CreateStageClientViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<FecthNameWorkflowViewModel>(
          builder: (context, viewModel, child) {
            return GestureDetector(
              onTap: viewModel.toggleEditing,
              child: viewModel.isEditing
                  ? TextFormField(
                      initialValue: viewModel.title,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      autofocus: true,
                      onFieldSubmitted: (value) {
                        viewModel.setTitle(value);
                        viewModel.toggleEditing();
                      },
                    )
                  : Text(
                      viewModel.title,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: viewModelCreateStage.toggleEditing,
              child: viewModelCreateStage.isEditing
                  ? TextField(
                      controller: viewModelCreateStage.titleController,
                      decoration: const InputDecoration(labelText: 'Tên Stage'),
                    )
                  : Text(
                      viewModelCreateStage.titleController.text.isNotEmpty
                          ? viewModelCreateStage.titleController.text
                          : 'Tên Stage',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
            ),
            const SizedBox(height: 20),
            viewModelCreateStage.isEditing
                ? TextField(
                    controller: viewModelCreateStage.descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Mô tả Stage',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  )
                : Text(
                    viewModelCreateStage.descriptionController.text.isNotEmpty
                        ? viewModelCreateStage.descriptionController.text
                        : 'Chưa có mô tả',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: viewModelCreateStage.isLoading
                    ? null
                    : () async {
                        bool success = await viewModelCreateStage.createStage(
                          workflowId: widget.workflowId,
                        );
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Tạo Stage thành công!"),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(viewModelCreateStage.errorMessage ??
                                  "Có lỗi xảy ra!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                child: viewModelCreateStage.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Tạo stage",
                        style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
