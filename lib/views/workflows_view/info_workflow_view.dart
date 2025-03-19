import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_flow/viewmodels/workflow_view_model/load_stage_in_workflow_view_model.dart';
import 'package:work_flow/viewmodels/workflow_view_model/load_workflow_id_view_model.dart';
import 'package:work_flow/views/stage_view/create_stage_in_workflow_view.dart';
import 'package:work_flow/views/stage_view/stage_info_view.dart';

class InfoCreateWorkflow extends StatefulWidget {
  final dynamic workflowId;
  const InfoCreateWorkflow({super.key, required this.workflowId});

  @override
  State<InfoCreateWorkflow> createState() => _InfoCreateWorkflowState();
}

class _InfoCreateWorkflowState extends State<InfoCreateWorkflow> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context
        .read<LoadWorkflowIdViewModel>()
        .fetchWorkflow(widget.workflowId));

    WidgetsBinding.instance.addPostFrameCallback((_) => context
        .read<LoadStageInWorkflowViewModel>()
        .loadStages(widget.workflowId));
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<LoadWorkflowIdViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                viewmodel.enableEditing();
              },
              child: viewmodel.isEditing
                  ? TextFormField(
                      initialValue: viewmodel.title,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      onFieldSubmitted: (value) {
                        viewmodel.updateTitle(value);
                        viewmodel.disableEditing();
                      },
                      autofocus: true,
                    )
                  : Text(
                      viewmodel.title,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Xử lý menu
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Consumer<LoadStageInWorkflowViewModel>(
        builder: (context, stageViewModel, _) {
          final workflowId = widget.workflowId;

          if ((stageViewModel.getStages(workflowId)?.isEmpty ?? true) &&
              !stageViewModel.isLoading(workflowId)) {
            stageViewModel.loadStages(workflowId);
          }

          final stages = stageViewModel.getStages(workflowId);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _quickActionButton(
                  Icons.add,
                  'Thêm Stage',
                  Colors.green,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: stageViewModel.isLoading(workflowId)
                      ? const Center(child: CircularProgressIndicator())
                      : stages.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Không có stages",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : Column(
                              children: stages.map<Widget>((stage) {
                                final String stageName =
                                    stage['NameStage']?.toString() ?? 'Unknown';
                                final String stageIdString =
                                    stage['IdStage'].toString();

                                final int stageId =
                                    int.tryParse(stageIdString) ?? 0;

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Stages(
                                            stageId: stageId,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              stageName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.more_horiz,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _quickActionButton(IconData icon, String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CreateStageInWorkflow(workflowId: widget.workflowId),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 5),
          SizedBox(
            width: 80,
            height: 20,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
