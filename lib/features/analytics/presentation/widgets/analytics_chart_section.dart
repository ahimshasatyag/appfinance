import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/analytics_entity.dart';
import '../../../../shared/theme/app_theme.dart';

class AnalyticsChartSection extends StatelessWidget {
  final AnalyticsEntity data;

  const AnalyticsChartSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Income vs Expense'),
        const SizedBox(height: 16),
        _buildIncomeExpenseLineChart(),
        const SizedBox(height: 32),
        
        _buildSectionTitle('Expense Breakdown'),
        const SizedBox(height: 16),
        _buildExpenseDonutChart(),
        const SizedBox(height: 32),
        
        _buildSectionTitle('Income Sources'),
        const SizedBox(height: 16),
        _buildIncomeDonutChart(),
        const SizedBox(height: 32),
        
        _buildSectionTitle('Monthly Comparison'),
        const SizedBox(height: 16),
        _buildMonthlyBarChart(),
        const SizedBox(height: 32),
        
        _buildSectionTitle('Cash Flow Analysis'),
        const SizedBox(height: 16),
        _buildCashFlowLineChart(),
        const SizedBox(height: 32),
        
        _buildSectionTitle('Financial Insights'),
        const SizedBox(height: 16),
        _buildInsights(),
        const SizedBox(height: 32),
        
        _buildSectionTitle('Savings & Goals'),
        const SizedBox(height: 16),
        _buildSavingsAnalysis(context),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildIncomeExpenseLineChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5000000,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value % 5000000 == 0) {
                    return Text('${(value / 1000000).toInt()}M', style: const TextStyle(fontSize: 10, color: Colors.grey));
                  }
                  return const Text('');
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < data.monthlyComparison.length) {
                    return Text(data.monthlyComparison[value.toInt()].month, style: const TextStyle(fontSize: 12, color: Colors.grey));
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data.monthlyComparison.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.income)).toList(),
              isCurved: true,
              color: AppTheme.primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: AppTheme.primaryColor.withOpacity(0.1)),
            ),
            LineChartBarData(
              spots: data.monthlyComparison.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.expense)).toList(),
              isCurved: true,
              color: Colors.redAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.redAccent.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseDonutChart() {
    return _buildDonutChartCore(
      items: data.expenseBreakdown.map((e) => _DonutData(e.categoryName, e.percentage, e.amount, e.colorHex)).toList(),
      centerText: 'Total Expense',
    );
  }
  
  Widget _buildIncomeDonutChart() {
    return _buildDonutChartCore(
      items: data.incomeSources.map((e) => _DonutData(e.sourceName, e.percentage, e.amount, e.colorHex)).toList(),
      centerText: 'Total Income',
    );
  }

  Widget _buildDonutChartCore({required List<_DonutData> items, required String centerText}) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: items.map((e) {
                      return PieChartSectionData(
                        color: Color(int.parse('0xFF${e.colorHex}')),
                        value: e.percentage,
                        title: '${e.percentage.toInt()}%',
                        radius: 20,
                        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(centerText, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        currencyFormatter.format(items.fold(0.0, (sum, item) => sum + item.amount)),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: Color(int.parse('0xFF${item.colorHex}')), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item.name, style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)))),
                    Text('${item.percentage.toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(width: 8),
                    Text(currencyFormatter.format(item.amount), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyBarChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 20000000,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value % 5000000 == 0) {
                    return Text('${(value / 1000000).toInt()}M', style: const TextStyle(fontSize: 10, color: Colors.grey));
                  }
                  return const Text('');
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < data.monthlyComparison.length) {
                    return Text(data.monthlyComparison[value.toInt()].month, style: const TextStyle(fontSize: 12, color: Colors.grey));
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: data.monthlyComparison.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(toY: e.value.income, color: AppTheme.primaryColor, width: 8, borderRadius: BorderRadius.circular(4)),
                BarChartRodData(toY: e.value.expense, color: Colors.redAccent, width: 8, borderRadius: BorderRadius.circular(4)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCashFlowLineChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5000000,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value % 5000000 == 0) {
                    return Text('${(value / 1000000).toInt()}M', style: const TextStyle(fontSize: 10, color: Colors.grey));
                  }
                  return const Text('');
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < data.cashFlowAnalysis.length) {
                    return Text(data.cashFlowAnalysis[value.toInt()].month, style: const TextStyle(fontSize: 12, color: Colors.grey));
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data.cashFlowAnalysis.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.moneyIn)).toList(),
              isCurved: true,
              color: AppTheme.primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
            ),
            LineChartBarData(
              spots: data.cashFlowAnalysis.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.moneyOut)).toList(),
              isCurved: true,
              color: Colors.redAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
            ),
            LineChartBarData(
              spots: data.cashFlowAnalysis.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.moneyIn - e.value.moneyOut)).toList(),
              isCurved: true,
              color: Colors.purple,
              barWidth: 2,
              dashArray: [5, 5],
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsights() {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildInsightItem(
            icon: Icons.lightbulb,
            color: Colors.amber,
            title: 'Your spending decreased by ${data.insights.spendingChangePercentage.abs()}%',
            subtitle: 'You spent ${currencyFormatter.format(data.insights.spendingDifference)} less than last month.',
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            icon: Icons.trending_up,
            color: Colors.green,
            title: 'Income is growing',
            subtitle: 'Your income increased by ${data.insights.incomeChangePercentage}% compared to last month.',
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            icon: Icons.warning_amber_rounded,
            color: Colors.orange,
            title: '${data.insights.topExpenseCategory} spending is high',
            subtitle: 'It represents ${data.insights.topExpensePercentage}% of your monthly expenses.',
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            icon: Icons.track_changes,
            color: AppTheme.primaryColor,
            title: 'You\'re on track',
            subtitle: 'You saved ${data.insights.savingsRate}% of your total income this month.',
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem({required IconData icon, required Color color, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsAnalysis(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
        ],
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
                  const Text('Monthly Savings', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(currencyFormatter.format(data.savingsAnalysis.monthlySavings), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Savings Rate', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('${data.savingsAnalysis.savingsRate}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Financial Goals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
              InkWell(
                onTap: () => _showAllFinancialGoals(context, data.savingsAnalysis.goals),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: const Text('See all', style: TextStyle(fontSize: 12, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...data.savingsAnalysis.goals.take(2).map((goal) {
            final progress = goal.currentAmount / goal.targetAmount;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(goal.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    color: AppTheme.primaryColor,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 4),
                  Text('${currencyFormatter.format(goal.currentAmount)} / ${currencyFormatter.format(goal.targetAmount)}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showAllFinancialGoals(BuildContext context, List<FinancialGoal> goals) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              const Text('All Financial Goals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2B3A4A))),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    final progress = goal.currentAmount / goal.targetAmount;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(goal.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2B3A4A))),
                              Text('${(progress * 100).toStringAsFixed(1)}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.shade200,
                              color: AppTheme.primaryColor,
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(currencyFormatter.format(goal.currentAmount), style: const TextStyle(fontSize: 13, color: Colors.grey)),
                              Text(currencyFormatter.format(goal.targetAmount), style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DonutData {
  final String name;
  final double percentage;
  final double amount;
  final String colorHex;
  _DonutData(this.name, this.percentage, this.amount, this.colorHex);
}
