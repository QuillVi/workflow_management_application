import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_flow/viewmodels/workflow_view_model/load_stage_in_workflow_view_model.dart';
import 'package:work_flow/viewmodels/workflow_view_model/load_workflow_client_view_model.dart';
import 'package:work_flow/views/workflows_view/create_workflow.dart';
import 'package:work_flow/views/workflows_view/info_workflow_view.dart';

class CreateWorkflow extends StatefulWidget {
  const CreateWorkflow({super.key});

  @override
  State<CreateWorkflow> createState() => _CreateWorkflowState();
}

class _CreateWorkflowState extends State<CreateWorkflow> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<LoadWorkflowClientViewModel>().loadWorkflows());

    Future.microtask(() {
      final workflowViewModel =
          Provider.of<LoadWorkflowClientViewModel>(context, listen: false);
      final stageViewModel =
          Provider.of<LoadStageInWorkflowViewModel>(context, listen: false);

      for (var workflow in workflowViewModel.workflows) {
        stageViewModel.loadStages(workflow['IDWorkFlow']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Workflow của bạn',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateNewWorkflow(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_none_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<LoadWorkflowClientViewModel>(
        builder: (context, workflowViewModel, _) {
          if (workflowViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final workflows = workflowViewModel.workflows;

          return ListView.builder(
            itemCount: workflows.length,
            itemBuilder: (context, index) {
              final workflow = workflows[index];

              return Consumer<LoadStageInWorkflowViewModel>(
                builder: (context, stageViewModel, _) {
                  final stages =
                      stageViewModel.getStages(workflow['IDWorkFlow']);
                  final isLoading =
                      stageViewModel.isLoading(workflow['IDWorkFlow']);
                  final errorMessage =
                      stageViewModel.getErrorMessage(workflow['IDWorkFlow']);

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  workflow['Name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert,
                                      color: Colors.white),
                                  onSelected: (value) {
                                    if (value == 'view') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InfoCreateWorkflow(
                                                  workflowId:
                                                      workflow['IDWorkFlow']),
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'view',
                                      child: Text('Xem Workflow'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              workflow['Description'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (isLoading)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else if (errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  errorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            else
                              ExpansionTile(
                                title: const Text(
                                  'Stages',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: stages.isNotEmpty
                                    ? stages
                                        .map<Widget>(
                                          (stage) => Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.white),
                                            ),
                                            child: Text(
                                              stage['NameStage'] ?? 'No Name',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList()
                                    : [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Không có stages",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
