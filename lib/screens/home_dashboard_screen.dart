import 'package:flutter/material.dart';
import '../models/permission.dart';
import '../models/request_model.dart';
import '../services/auth_manager.dart';
import '../services/request_service.dart';
import '../widgets/cta_banner.dart';
import '../widgets/mentara_bottom_nav.dart';
import '../widgets/metric_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/recent_request_card.dart';
import '../widgets/weekly_summary_card.dart';
import 'role_selection_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  final String userName;
  final String department;
  final RequestService requestService;

  const HomeDashboardScreen({
    super.key,
    this.userName = 'Ava',
    this.department = 'Northstar HQ · Human Resources',
    RequestService? requestService,
  }) : requestService = requestService ?? const _DefaultRequestServiceFactory();

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _DefaultRequestServiceFactory implements RequestService {
  const _DefaultRequestServiceFactory();

  @override
  Future<List<RequestModel>> getRecentRequests() => RequestServiceImpl().getRecentRequests();

  @override
  Future<Map<String, int>> getRequestMetrics() => RequestServiceImpl().getRequestMetrics();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _navIndex = 0;
  List<RequestModel> _recentRequests = [];
  Map<String, int> _metrics = {'open': 3, 'inProgress': 1, 'resolved': 8};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final requests = await widget.requestService.getRecentRequests();
    final metrics = await widget.requestService.getRequestMetrics();

    if (mounted) {
      setState(() {
        _recentRequests = requests;
        _metrics = metrics;
        _isLoading = false;
      });
    }
  }

  void _showActionFeedback(String actionName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF234B3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          actionName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() => _navIndex = index);
    if (index == 4) {
      // Profile tab -> Show Profile & Authorization Dialog with Sign Out
      _showProfileDialog();
    }
  }

  void _showProfileDialog() {
    final user = AuthManager.instance.currentUser;
    final permissions = AuthManager.instance.currentPermissions;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFE8F5EE),
                      child: Text(
                        user != null && user.name.isNotEmpty ? user.name[0] : 'A',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D5B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? widget.userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A2E26),
                            ),
                          ),
                          Text(
                            user?.email ?? 'olivia@northstar.com',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF7D8E87),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5EE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user?.role.title ?? 'Employee',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D5B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const Text(
                  'Authorized Permissions:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2E26),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: permissions.map((p) {
                    return Chip(
                      label: Text(
                        p.name,
                        style: const TextStyle(fontSize: 10.5, color: Color(0xFF2E7D5B)),
                      ),
                      backgroundColor: const Color(0xFFE8F5EE),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      await AuthManager.instance.signOut();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthManager.instance.currentUser;
    final displayName = currentUser?.name ?? widget.userName;
    final displayDept = currentUser?.department ?? widget.department;
    final canCreate = AuthManager.instance.hasPermission(AppPermission.createMaintenanceRequest);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      bottomNavigationBar: MentaraBottomNav(
        currentIndex: _navIndex,
        onTap: _onBottomNavTap,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF234B3C)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top App Bar / Location + Notification Bell
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Location Selector
                              InkWell(
                                onTap: () => _showActionFeedback('Switch Location'),
                                borderRadius: BorderRadius.circular(6),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'NORTHSTAR HQ',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: Color(0xFF7D8E87),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 16,
                                      color: Color(0xFF7D8E87),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Greeting (Dynamic via AuthManager)
                              Text(
                                'Good morning, $displayName',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                  color: Color(0xFF1A2E26),
                                ),
                              ),
                              const SizedBox(height: 2),

                              // Department (Dynamic via AuthManager)
                              Text(
                                displayDept,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF7D8E87),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Notification Bell Button
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFE8ECE9),
                              width: 1.0,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.notifications_none_rounded,
                                size: 22,
                                color: Color(0xFF4A6157),
                              ),
                              Positioned(
                                top: 12,
                                right: 13,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF2E7D5B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Metrics Row (Open, In progress, Resolved)
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            count: _metrics['open'] ?? 3,
                            label: 'Open requests',
                            icon: Icons.assignment_outlined,
                            iconColor: const Color(0xFF2E7D5B),
                            badgeBackgroundColor: const Color(0xFFE8F5EE),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MetricCard(
                            count: _metrics['inProgress'] ?? 1,
                            label: 'In progress',
                            icon: Icons.handyman_outlined,
                            iconColor: const Color(0xFF3B739E),
                            badgeBackgroundColor: const Color(0xFFEAF2F8),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MetricCard(
                            count: _metrics['resolved'] ?? 8,
                            label: 'Resolved',
                            icon: Icons.check_rounded,
                            iconColor: const Color(0xFFB8722E),
                            badgeBackgroundColor: const Color(0xFFFDF3E7),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // CTA Banner ("Something not working?")
                    CtaBanner(
                      onTap: () {
                        if (canCreate) {
                          _showActionFeedback('Opening Maintenance Request form...');
                        } else {
                          _showActionFeedback('You do not have permission to create requests.');
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // Quick Actions Title
                    const Text(
                      'Quick actions',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2E26),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Quick Actions Row
                    Row(
                      children: [
                        Expanded(
                          child: QuickActionCard(
                            title: 'Report an issue',
                            icon: Icons.add_rounded,
                            onTap: () {
                              if (canCreate) {
                                _showActionFeedback('Report an issue');
                              } else {
                                _showActionFeedback('Permission denied');
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: QuickActionCard(
                            title: 'Browse\nequipment',
                            icon: Icons.inventory_2_outlined,
                            onTap: () => _showActionFeedback('Browse equipment'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: QuickActionCard(
                            title: 'Track requests',
                            icon: Icons.location_on_outlined,
                            onTap: () => _showActionFeedback('Track requests'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Recent Requests Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your recent requests',
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A2E26),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Updated just now',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF7D8E87),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => _showActionFeedback('View All Requests'),
                          borderRadius: BorderRadius.circular(4),
                          child: const Text(
                            'View all',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF234B3C),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Recent Requests List
                    ..._recentRequests.map(
                      (request) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: RecentRequestCard(
                          request: request,
                          onTap: () => _showActionFeedback('Viewing ${request.code}'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Weekly Summary Card
                    const WeeklySummaryCard(resolvedCount: 2),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }
}
