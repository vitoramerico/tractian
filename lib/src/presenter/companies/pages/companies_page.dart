import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/utils/constants/assets.dart';
import '../view_models/companies_view_model.dart';
import 'components/item_widget.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({super.key});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  final _viewModel = Modular.get<CompaniesViewModel>();

  @override
  void initState() {
    super.initState();

    _viewModel.getCompanies.addListener(_listener);

    _viewModel.getCompanies.execute();
  }

  @override
  void dispose() {
    _viewModel.getCompanies.removeListener(_listener);
    Modular.dispose<CompaniesViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset(AppAssets.logo)),
      body: ListenableBuilder(
        listenable: _viewModel.getCompanies,
        builder: (_, child) {
          final isLoading = _viewModel.getCompanies.running;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.lstCompany.isEmpty) {
            return Center(child: Text('Nenhum registro encontrado'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _viewModel.lstCompany.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16);
            },
            itemBuilder: (context, index) {
              return ItemWidget(
                company: _viewModel.lstCompany[index],
                onPressed: _viewModel.openPageAssets,
              );
            },
          );
        },
      ),
    );
  }

  void _listener() {
    if (_viewModel.getCompanies.result != null) {
      if (_viewModel.getCompanies.error) {
        final errorMessage = _viewModel.getCompanies.errorMessage;

        _showMessage(errorMessage);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
