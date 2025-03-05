import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../../theme/app_theme.dart';
import 'dashboard_bloc/dashboard_bloc.dart';
import 'stat_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardBloc _dashboardBloc = DashboardBloc();

  Map<String, dynamic> _dashboardData = {};
  List _users = [];

  @override
  void initState() {
    getDashboardData();
    super.initState();
  }

  void getDashboardData() {
    _dashboardBloc.add(FetchDashboardDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _dashboardBloc,
      child: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: 'Failed to load data',
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getDashboardData();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is DashboardSuccessState) {
            _dashboardData = state.data;
            _users = _dashboardData['latest_users'];
            Logger().w(_dashboardData);
            setState(() {});
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state is DashboardLoadingState) LinearProgressIndicator(),
                if (state is DashboardSuccessState) ...[
                  Wrap(
                    children: [
                      StatCard(
                        title: 'Total Clinics',
                        value: _dashboardData['total_clinics'].toString(),
                        isPositive: true,
                        icon: Icons.business,
                      ),
                      StatCard(
                        title: 'Total PetStore',
                        value: _dashboardData['total_petstores'].toString(),
                        isPositive: true,
                        icon: Icons.pets,
                      ),
                      StatCard(
                        title: 'Total Users',
                        value: _dashboardData['total_users'].toString(),
                        isPositive: true,
                        icon: Icons.people,
                      ),
                      StatCard(
                        title: 'Total Pets',
                        value: _dashboardData['total_pets'].toString(),
                        isPositive: true,
                        icon: Icons.star,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'New Users',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                  ),
                  const SizedBox(height: 15),
                  if (_users.isEmpty)
                    Text(
                      'No new users found.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  else
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF1D8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DataTable2(
                          columns: const [
                            DataColumn2(
                              label: Text('ID'),
                              size: ColumnSize.S,
                            ),
                            DataColumn2(
                                label: Text('Name'), size: ColumnSize.L),
                            DataColumn2(
                                label: Text('Email'), size: ColumnSize.L),
                            DataColumn2(
                                label: Text('Joined Date'), size: ColumnSize.M),
                          ],
                          rows: List<DataRow>.generate(
                            _users.length,
                            (index) => DataRow(
                              cells: [
                                DataCell(Text(_users[index]['id'].toString())),
                                DataCell(Text(_users[index]['name'])),
                                DataCell(Text(_users[index]['email'])),
                                DataCell(Text(_users[index]['created_at'])),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
