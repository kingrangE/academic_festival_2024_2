// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late UserProvider _userProvider;
  double _currentSliderValue = 60;
  bool _isEditing = false;
  bool _showSuccess = false;
  bool _notifyTimeAlert = true;
  bool _notifyReturnAlert = true;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );
    _controller.forward();

    // 초기값 설정
    if (_userProvider.user?.customAwayDuration != null) {
      _currentSliderValue = _userProvider.user!.customAwayDuration!.inMinutes.toDouble();
    }
  }

  void _saveSettings() {
    _userProvider.setCustomAwayDuration(Duration(minutes: _currentSliderValue.toInt()));
    setState(() {
      _isEditing = false;
      _showSuccess = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSuccess = false;
        });
      }
    });
  }
  void _handleQuickTimeSelection(double minutes) {
    setState(() => _currentSliderValue = minutes);
    _userProvider.setCustomAwayDuration(Duration(minutes: minutes.toInt()));
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(double minutes) {
    int hours = (minutes ~/ 60);
    int mins = (minutes % 60).round();
    return '${hours > 0 ? '$hours시간 ' : ''}${mins > 0 ? '$mins분' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFC31632),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFC31632),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFC31632),
                const Color(0xFFC31632).withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimeSettingCard(),
                    const SizedBox(height: 20),
                    _buildQuickSettingsCard(),
                    const SizedBox(height: 20),
                    _buildNotificationSettingsCard(),
                  ],
                ),
              ),
              if (_showSuccess)
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.check_circle, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            '설정이 저장되었습니다',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSettingCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTimeDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFC31632), Color(0xFF990000)],
          ).createShader(bounds),
          child: const Text(
            '자리 비움 시간 설정',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          icon: Icon(_isEditing ? Icons.check : Icons.edit),
          color: const Color(0xFFC31632),
          onPressed: () {
            if (_isEditing) {
              _saveSettings();
            } else {
              setState(() {
                _isEditing = true;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildTimeDisplay() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: Color(0xFFC31632),
                    size: 36,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatDuration(_currentSliderValue),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC31632),
                    ),
                  ),
                ],
              ),
              if (_isEditing) ...[
                const SizedBox(height: 20),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFFC31632),
                    inactiveTrackColor: const Color(0xFFC31632).withOpacity(0.2),
                    thumbColor: const Color(0xFFC31632),
                    overlayColor: const Color(0xFFC31632).withOpacity(0.2),
                    valueIndicatorColor: const Color(0xFFC31632),
                    valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                  ),
                  child: Slider(
                    value: _currentSliderValue,
                    min: 0,
                    max: 120,
                    divisions: 24,
                    label: _formatDuration(_currentSliderValue),
                    onChanged: (value) => setState(() => _currentSliderValue = value),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_isEditing)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('0분'),
                Text('2시간'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuickSettingsCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity, // 이 줄을 추가하여 박스 크기를 맞춥니다.
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '자주 사용하는 시간',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC31632),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickTimeButton('30분', 30),
                _buildQuickTimeButton('1시간', 60),
                _buildQuickTimeButton('1시간 30분', 90),
                _buildQuickTimeButton('2시간', 120),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTimeButton(String label, double minutes) {
    final isSelected = _currentSliderValue == minutes;
    return ElevatedButton(
      onPressed: () => _handleQuickTimeSelection(minutes),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFFC31632) : Colors.white,
        foregroundColor: isSelected ? Colors.white : const Color(0xFFC31632),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: isSelected ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: const Color(0xFFC31632),
            width: isSelected ? 0 : 1,
          ),
        ),
      ),
      child: Text(label),
    );
  }

  // _buildNotificationSettingsCard 함수 수정
  Widget _buildNotificationSettingsCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '알림 설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC31632),
              ),
            ),
            const SizedBox(height: 16),
            _buildNotificationOption(
              Icons.notification_important,
              '자리 비움 시간 알림',
              '설정한 시간의 80% 경과 시 알림',
              _notifyTimeAlert,
                  (value) {
                setState(() {
                  _notifyTimeAlert = value;
                });
              },
            ),
            const Divider(),
            _buildNotificationOption(
              Icons.timer,
              '자리 반납 예정 알림',
              '설정한 시간 만료 10분 전 알림',
              _notifyReturnAlert,
                  (value) {
                setState(() {
                  _notifyReturnAlert = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // _buildNotificationOption 함수 수정
  Widget _buildNotificationOption(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: const Color(0xFFC31632)),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      activeColor: const Color(0xFFC31632),
      onChanged: onChanged,
    );
  }
}