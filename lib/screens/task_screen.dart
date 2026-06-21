import 'package:flutter/material.dart';
import '../theme.dart';
import '../task_data.dart';
import '../settings_data.dart';

String _formatDate(DateTime? date) {
  if (date == null) return 'Pilih Tanggal Deadline';
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Ags',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int _selectedTab = 0;
  int _getTaskCount(int statusIndex) =>
      AppTasks.instance.tasks.where((t) => t.statusIndex == statusIndex).length;

  Future<void> _showDeleteModal(
    String id,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.danger,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Hapus Tugas?',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tugas ini akan dihapus secara permanen dan tidak dapat dikembalikan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: subTextColor, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: subTextColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Batal', style: TextStyle(color: textColor)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      AppTasks.instance.deleteTask(id);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Hapus',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskModal(
    Color bgColor,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = 'Design';
    String priority = 'Medium';
    DateTime? dueDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: subTextColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tambah Tugas Baru',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Isi detail tugas kamu di bawah ini',
                        style: TextStyle(color: subTextColor, fontSize: 12),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: subTextColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildInputLabel('Nama Tugas', Icons.title, subTextColor),
                    TextField(
                      controller: titleCtrl,
                      style: TextStyle(color: textColor),
                      decoration: _inputDeco(
                        'Contoh: Belajar State Management',
                        cardColor,
                        subTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputLabel(
                      'Deskripsi (Opsional)',
                      Icons.notes,
                      subTextColor,
                    ),
                    TextField(
                      controller: descCtrl,
                      maxLines: 3,
                      style: TextStyle(color: textColor),
                      decoration: _inputDeco(
                        'Tambahkan deskripsi tugas...',
                        cardColor,
                        subTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputLabel(
                      'Kategori',
                      Icons.category_outlined,
                      subTextColor,
                    ),
                    Wrap(
                      spacing: 8,
                      children: ['Design', 'Dev', 'Personal', 'Other']
                          .map(
                            (c) => ChoiceChip(
                              label: Text(
                                c,
                                style: TextStyle(
                                  color: category == c
                                      ? Colors.white
                                      : subTextColor,
                                ),
                              ),
                              selected: category == c,
                              selectedColor: AppColors.primary,
                              backgroundColor: cardColor,
                              onSelected: (val) =>
                                  setModalState(() => category = c),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    _buildInputLabel(
                      'Prioritas',
                      Icons.flag_outlined,
                      subTextColor,
                    ),
                    Row(
                      children: [
                        _buildPriorityChip(
                          'High',
                          priority,
                          cardColor,
                          subTextColor,
                          (v) => setModalState(() => priority = v),
                        ),
                        const SizedBox(width: 8),
                        _buildPriorityChip(
                          'Medium',
                          priority,
                          cardColor,
                          subTextColor,
                          (v) => setModalState(() => priority = v),
                        ),
                        const SizedBox(width: 8),
                        _buildPriorityChip(
                          'Low',
                          priority,
                          cardColor,
                          subTextColor,
                          (v) => setModalState(() => priority = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null)
                          setModalState(() => dueDate = picked);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: subTextColor.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: subTextColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _formatDate(dueDate),
                                  style: TextStyle(
                                    color: dueDate == null
                                        ? subTextColor
                                        : textColor,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.chevron_right, color: subTextColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleCtrl.text.trim().isEmpty) return;
                    AppTasks.instance.addTask(
                      Task(
                        id: DateTime.now().toString(),
                        title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        category: category,
                        priority: priority,
                        dueDate: dueDate,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Simpan Tugas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  Widget _buildInputLabel(String text, IconData icon, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
  InputDecoration _inputDeco(String hint, Color fill, Color hintCol) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: hintCol),
        filled: true,
        fillColor: fill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: hintCol.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      );
  Widget _buildPriorityChip(
    String label,
    String current,
    Color cardColor,
    Color subTextColor,
    Function(String) onSelect,
  ) {
    final isActive = label == current;
    Color dotColor = label == 'High'
        ? AppColors.danger
        : (label == 'Medium' ? Colors.orange : AppColors.success);
    return Expanded(
      child: InkWell(
        onTap: () => onSelect(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: cardColor,
            border: Border.all(
              color: isActive ? dotColor : subTextColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, size: 8, color: dotColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? (AppSettings.isDarkMode.value
                            ? Colors.white
                            : Colors.black)
                      : subTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- BUNGKUS DENGAN LISTENER TEMA ---
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isDarkMode,
      builder: (context, isDark, child) {
        Color bgColor = isDark
            ? const Color(0xFF0D0E15)
            : const Color(0xFFFFFFFF);
        Color cardColor = isDark ? AppColors.cardDark : const Color(0xFFF8F9FA);
        Color textColor = isDark ? Colors.white : const Color(0xFF1E1F29);
        Color subTextColor = isDark
            ? AppColors.textGrey
            : const Color(0xFF6C6D75);

        return Scaffold(
          backgroundColor: bgColor,
          body: ListenableBuilder(
            listenable: AppTasks.instance,
            builder: (context, child) {
              final filteredTasks = AppTasks.instance.tasks
                  .where((t) => t.statusIndex == _selectedTab)
                  .toList();
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tugas Saya',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Selamat datang kembali 👋',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.5),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: () => _showAddTaskModal(
                                bgColor,
                                cardColor,
                                textColor,
                                subTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildTabButton('To Do', 0, subTextColor),
                            _buildTabButton('In Progress', 1, subTextColor),
                            _buildTabButton('Done', 2, subTextColor),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildStatCard(
                            _getTaskCount(0).toString(),
                            'To Do',
                            Colors.orangeAccent,
                            cardColor,
                            textColor,
                            subTextColor,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            _getTaskCount(1).toString(),
                            'Berjalan',
                            AppColors.primary,
                            cardColor,
                            textColor,
                            subTextColor,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            _getTaskCount(2).toString(),
                            'Selesai',
                            AppColors.success,
                            cardColor,
                            textColor,
                            subTextColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _selectedTab == 0
                            ? 'Tugas Menunggu'
                            : (_selectedTab == 1
                                  ? 'Tugas Berjalan'
                                  : 'Tugas Selesai'),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: filteredTasks.isEmpty
                            ? Center(
                                child: Text(
                                  'Tidak ada tugas di kategori ini.',
                                  style: TextStyle(color: subTextColor),
                                ),
                              )
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: filteredTasks.length,
                                itemBuilder: (context, index) => _buildTaskCard(
                                  filteredTasks[index],
                                  cardColor,
                                  textColor,
                                  subTextColor,
                                  bgColor,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String title, int index, Color subTextColor) {
    bool isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : subTextColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String count,
    String label,
    Color accentColor,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: subTextColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    Task task,
    Color cardColor,
    Color textColor,
    Color subTextColor,
    Color bgColor,
  ) {
    Color prioColor = task.priority == 'High'
        ? AppColors.danger
        : (task.priority == 'Medium' ? Colors.orange : AppColors.success);
    bool isDone = task.statusIndex == 2;
    Color progColor = isDone ? AppColors.success : AppColors.primary;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: isDone ? AppColors.success : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            if (task.description != null &&
                                task.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                task.description!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (task.statusIndex > 0)
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 14,
                          color: subTextColor,
                        ),
                        onPressed: () => AppTasks.instance.updateTaskStatus(
                          task.id,
                          task.statusIndex - 1,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    if (task.statusIndex < 2)
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: subTextColor,
                        ),
                        onPressed: () => AppTasks.instance.updateTaskStatus(
                          task.id,
                          task.statusIndex + 1,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    if (task.statusIndex == 2)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.danger,
                        ),
                        onPressed: () => _showDeleteModal(
                          task.id,
                          cardColor,
                          textColor,
                          subTextColor,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.category,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (isDone)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.check_circle_outline,
                          size: 12,
                          color: AppColors.success,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Completed',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: prioColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${task.priority} Priority',
                      style: TextStyle(color: prioColor, fontSize: 10),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: TextStyle(color: subTextColor, fontSize: 12),
                ),
                Text(
                  '${(task.progress * 100).toInt()}%',
                  style: TextStyle(
                    color: progColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: task.progress,
                backgroundColor: bgColor,
                valueColor: AlwaysStoppedAnimation<Color>(progColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: subTextColor.withOpacity(0.2)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: subTextColor),
                    const SizedBox(width: 8),
                    Text(
                      isDone
                          ? 'Selesai: ${_formatDate(DateTime.now())}'
                          : 'Due: ${_formatDate(task.dueDate)}',
                      style: TextStyle(color: subTextColor, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(
                  width: 50,
                  height: 24,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.orange,
                          child: const Text(
                            'B',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primary,
                          child: const Text(
                            'A',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});
  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _currentTask;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _currentTask = Task(
      id: widget.task.id,
      title: widget.task.title,
      description: widget.task.description,
      category: widget.task.category,
      priority: widget.task.priority,
      progress: widget.task.progress,
      dueDate: widget.task.dueDate,
      statusIndex: widget.task.statusIndex,
    );
    _descCtrl = TextEditingController(text: _currentTask.description);
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isDarkMode,
      builder: (context, isDark, child) {
        Color bgColor = isDark
            ? const Color(0xFF0D0E15)
            : const Color(0xFFFFFFFF);
        Color cardColor = isDark ? AppColors.cardDark : const Color(0xFFF8F9FA);
        Color textColor = isDark ? Colors.white : const Color(0xFF1E1F29);
        Color subTextColor = isDark
            ? AppColors.textGrey
            : const Color(0xFF6C6D75);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Detail Tugas',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildBox(
                  label: 'NAMA TUGAS',
                  cardColor: cardColor,
                  subTextColor: subTextColor,
                  child: Text(
                    _currentTask.title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildBox(
                  label: 'DESKRIPSI TUGAS',
                  cardColor: cardColor,
                  subTextColor: subTextColor,
                  child: TextField(
                    controller: _descCtrl,
                    maxLines: 3,
                    style: TextStyle(color: textColor, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Tambahkan deskripsi tugas...',
                      hintStyle: TextStyle(
                        color: subTextColor.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (val) => _currentTask.description = val,
                  ),
                ),
                const SizedBox(height: 16),
                _buildBox(
                  label: 'KATEGORI',
                  cardColor: cardColor,
                  subTextColor: subTextColor,
                  child: Wrap(
                    spacing: 8,
                    children: ['Dev', 'Design', 'Personal', 'Other'].map((c) {
                      bool isActive = _currentTask.category == c;
                      return ChoiceChip(
                        label: Text(
                          c,
                          style: TextStyle(
                            color: isActive ? Colors.white : subTextColor,
                          ),
                        ),
                        selected: isActive,
                        selectedColor: AppColors.primary,
                        backgroundColor: bgColor,
                        onSelected: (val) =>
                            setState(() => _currentTask.category = c),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildBox(
                  label: 'PROGRESS',
                  trailing: '${(_currentTask.progress * 100).toInt()}%',
                  cardColor: cardColor,
                  subTextColor: subTextColor,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: bgColor,
                      thumbColor: Colors.white,
                      overlayColor: AppColors.primary.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _currentTask.progress,
                      onChanged: (val) =>
                          setState(() => _currentTask.progress = val),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildBox(
                  label: 'PRIORITAS',
                  cardColor: cardColor,
                  subTextColor: subTextColor,
                  child: Row(
                    children: [
                      _buildPrioBtn(
                        'High',
                        AppColors.danger,
                        bgColor,
                        subTextColor,
                      ),
                      const SizedBox(width: 8),
                      _buildPrioBtn(
                        'Medium',
                        Colors.orange,
                        bgColor,
                        subTextColor,
                      ),
                      const SizedBox(width: 8),
                      _buildPrioBtn(
                        'Low',
                        AppColors.success,
                        bgColor,
                        subTextColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildBox(
                  label: 'TENGGAT WAKTU',
                  cardColor: cardColor,
                  subTextColor: subTextColor,
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _currentTask.dueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null)
                        setState(() => _currentTask.dueDate = picked);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: subTextColor,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _formatDate(_currentTask.dueDate),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right, color: subTextColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AppTasks.instance.updateTaskDetail(_currentTask);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    AppTasks.instance.deleteTask(_currentTask.id);
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.danger,
                  ),
                  label: const Text(
                    'Hapus Tugas',
                    style: TextStyle(color: AppColors.danger),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrioBtn(
    String label,
    Color color,
    Color bgColor,
    Color subTextColor,
  ) {
    bool isActive = _currentTask.priority == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTask.priority = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.1) : bgColor,
            border: Border.all(
              color: isActive ? color : subTextColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? color : subTextColor,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBox({
    required String label,
    required Widget child,
    String? trailing,
    required Color cardColor,
    required Color subTextColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              if (trailing != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    trailing,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
