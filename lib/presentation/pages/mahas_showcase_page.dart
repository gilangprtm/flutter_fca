import 'package:flutter/material.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_accordion.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_alert.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_avatar.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_badge.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_bottomsheet.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_button.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_card.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_grid.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_image.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_loader.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_menubar.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_responsive.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_searchbar.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_snackbar.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_tab.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_tile.dart';
import 'package:flutter_fca/core/mahas/widget/mahas_toast.dart';
import 'package:flutter_fca/core/mahas/mahas_type.dart';
import 'package:flutter_fca/core/theme/app_color.dart';

class MahasShowcasePage extends StatefulWidget {
  const MahasShowcasePage({Key? key}) : super(key: key);

  @override
  State<MahasShowcasePage> createState() => _MahasShowcasePageState();
}

class _MahasShowcasePageState extends State<MahasShowcasePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bottom Sheet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('This is a bottom sheet content'),
            const SizedBox(height: 20),
            MahasButton(
              text: 'Close',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Buttons',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            MahasButton(
              text: 'Primary',
              onPressed: () => _showSnackbar('Primary button pressed'),
            ),
            MahasButton(
              text: 'Secondary',
              type: ButtonType.secondary,
              onPressed: () => _showSnackbar('Secondary button pressed'),
            ),
            MahasButton(
              text: 'Outline',
              type: ButtonType.outline,
              onPressed: () => _showSnackbar('Outline button pressed'),
              color: AppColors.primaryColor,
            ),
            MahasButton(
              text: 'Text',
              type: ButtonType.text,
              onPressed: () => _showSnackbar('Text button pressed'),
            ),
            MahasButton(
              text: 'Loading',
              isLoading: _isLoading,
              isDisabled: _isLoading,
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                });
              },
            ),
            const MahasButton(
              text: 'Disabled',
              onPressed: null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Badges',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            MahasBadge(
              text: 'Primary',
              backgroundColor: AppColors.primaryColor,
            ),
            MahasBadge(
              text: 'Secondary',
              backgroundColor: AppColors.lightSecondaryColor,
            ),
            MahasBadge(
              text: 'Success',
              backgroundColor: AppColors.successColor,
            ),
            MahasBadge(
              text: 'Warning',
              backgroundColor: AppColors.warningColor,
            ),
            MahasBadge(
              text: 'Error',
              backgroundColor: AppColors.errorColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlertsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alerts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: AppColors.infoColor),
                    SizedBox(width: 8),
                    Text('Info Alert',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Text('This is an info alert'),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.successColor),
                    SizedBox(width: 8),
                    Text('Success Alert',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Text('This is a success alert'),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: AppColors.warningColor),
                    SizedBox(width: 8),
                    Text('Warning Alert',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Text('This is a warning alert'),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error, color: AppColors.errorColor),
                    SizedBox(width: 8),
                    Text('Error Alert',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Text('This is an error alert'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cards',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          margin: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Card',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10.0),
                const Text('This is a basic card content'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          margin: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Interactive Card',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10.0),
                const Text('This is an interactive card with button'),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () => _showSnackbar('Card button pressed'),
                  child: const Text('Action'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTilesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tiles',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        MahasTile(
          leading: const Icon(Icons.person),
          title: const Text('User Profile'),
          subtitle: const Text('View your profile'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showSnackbar('User profile tile pressed'),
        ),
        const SizedBox(height: 8),
        MahasTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          subtitle: const Text('Configure app settings'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showSnackbar('Settings tile pressed'),
        ),
      ],
    );
  }

  Widget _buildAvatarsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Avatars',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            MahasAvatar(
              iconData: Icons.person,
              backgroundColor: AppColors.primaryColor,
              type: MahasAvatarType.icon,
            ),
            MahasAvatar(
              iconData: Icons.photo_camera,
              backgroundColor: AppColors.lightSecondaryColor,
              type: MahasAvatarType.icon,
            ),
            MahasAvatar(
              iconData: Icons.check,
              backgroundColor: AppColors.successColor,
              type: MahasAvatarType.icon,
            ),
            MahasAvatar(
              avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
              type: MahasAvatarType.image,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccordionSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Accordion',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        MahasAccordion(
          title: 'Accordion 1',
          content: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('This is the content of accordion 1'),
          ),
        ),
        SizedBox(height: 8),
        MahasAccordion(
          title: 'Accordion 2',
          content: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('This is the content of accordion 2'),
          ),
        ),
      ],
    );
  }

  Widget _buildTabsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tabs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          color: Colors.grey[200],
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
              Tab(text: 'Tab 4'),
              Tab(text: 'Tab 5'),
            ],
          ),
        ),
        Container(
          height: 100,
          padding: const EdgeInsets.all(16),
          child: TabBarView(
            controller: _tabController,
            children: const [
              Center(child: Text('Tab 1 Content')),
              Center(child: Text('Tab 2 Content')),
              Center(child: Text('Tab 3 Content')),
              Center(child: Text('Tab 4 Content')),
              Center(child: Text('Tab 5 Content')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGridSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Grid',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: [
              Container(
                color: AppColors.primaryColor.withOpacity(0.3),
                child: const Center(child: Text('Grid Item 1')),
              ),
              Container(
                color: AppColors.lightSecondaryColor.withOpacity(0.3),
                child: const Center(child: Text('Grid Item 2')),
              ),
              Container(
                color: AppColors.infoColor.withOpacity(0.3),
                child: const Center(child: Text('Grid Item 3')),
              ),
              Container(
                color: AppColors.successColor.withOpacity(0.3),
                child: const Center(child: Text('Grid Item 4')),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiscSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Miscellaneous',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Row(
          children: [
            Text('Loader: '),
            SizedBox(width: 8),
            CircularProgressIndicator(strokeWidth: 2),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  _showSnackbar('Searching for: $value');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MahasButton(
              text: 'Show Toast',
              onPressed: () => _showToast('This is a toast message'),
            ),
            MahasButton(
              text: 'Show Bottom Sheet',
              onPressed: _showBottomSheet,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahas Widget Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildButtonsSection(),
            const SizedBox(height: 32),
            _buildBadgesSection(),
            const SizedBox(height: 32),
            _buildAlertsSection(),
            const SizedBox(height: 32),
            _buildCardsSection(),
            const SizedBox(height: 32),
            _buildTilesSection(),
            const SizedBox(height: 32),
            _buildAvatarsSection(),
            const SizedBox(height: 32),
            _buildAccordionSection(),
            const SizedBox(height: 32),
            _buildTabsSection(),
            const SizedBox(height: 32),
            _buildGridSection(),
            const SizedBox(height: 32),
            _buildMiscSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}
