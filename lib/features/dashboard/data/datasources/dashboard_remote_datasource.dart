import '../models/dashboard_data_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardDataModel> getDashboardData();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<DashboardDataModel> getDashboardData() async {
    // Simulasi delay jaringan (Mocking API Call)
    await Future.delayed(const Duration(seconds: 1));
    
    // Data mock (JSON Response)
    final jsonResponse = {
      "userName": "Enjelin Morgeana",
      "totalBalance": 2957.0,
      "income": 1450.0,
      "expenses": 450.0,
      "recentTransactions": [
        {
          "id": "1",
          "title": "Education",
          "date": "Sunday 2022-10-30",
          "amount": 580.0,
          "isExpense": true,
          "iconUrl": "education"
        },
        {
          "id": "2",
          "title": "Shopping",
          "date": "Monday 2022-10-31",
          "amount": 120.0,
          "isExpense": true,
          "iconUrl": "shopping"
        },
        {
          "id": "3",
          "title": "Salary",
          "date": "Tuesday 2022-11-01",
          "amount": 3500.0,
          "isExpense": false,
          "iconUrl": "salary"
        },
        {
          "id": "4",
          "title": "Grocery",
          "date": "Wednesday 2022-11-02",
          "amount": 250.0,
          "isExpense": true,
          "iconUrl": "food"
        },
        {
          "id": "5",
          "title": "Netflix Subscription",
          "date": "Thursday 2022-11-03",
          "amount": 15.0,
          "isExpense": true,
          "iconUrl": "movie"
        },
        {
          "id": "6",
          "title": "Freelance Project",
          "date": "Friday 2022-11-04",
          "amount": 850.0,
          "isExpense": false,
          "iconUrl": "salary"
        },
        {
          "id": "7",
          "title": "Starbucks Coffee",
          "date": "Saturday 2022-11-05",
          "amount": 8.0,
          "isExpense": true,
          "iconUrl": "coffee"
        }
      ]
    };

    return DashboardDataModel.fromJson(jsonResponse);
  }
}
