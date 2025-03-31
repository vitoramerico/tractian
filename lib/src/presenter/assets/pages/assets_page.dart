import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../view_models/assets_view_model.dart';
import 'components/filter_buttons_widget.dart';
import 'components/lazy_tree_node_widget.dart';
import 'components/search_widget.dart';

class AssetsPage extends StatefulWidget {
  final String companyId;

  const AssetsPage({super.key, required this.companyId});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  final _viewModel = Modular.get<AssetsViewModel>();

  @override
  void initState() {
    super.initState();

    _viewModel.getAssetsByCompany.addListener(_listener);
    _viewModel.getLocationsByCompany.addListener(_listener);
    _viewModel.getFilteredAssetsAndLocation.addListener(_listener);

    _viewModel.init(widget.companyId);
  }

  @override
  void dispose() {
    _viewModel.getFilteredAssetsAndLocation.removeListener(_listener);
    Modular.dispose<AssetsViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Assets')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchWidget(
                  onChanged: (text) {
                    if (_viewModel.filter == null) return;
                    _viewModel.setFilter(
                      _viewModel.filter!.copyWith(query: text),
                    );
                  },
                ),
                const SizedBox(height: 10),
                FilterButtonsWidget(viewModel: _viewModel),
              ],
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: Listenable.merge([
                _viewModel.buildTreeStructure,
                _viewModel.getFilteredAssetsAndLocation,
                _viewModel.getLocationsByCompany,
                _viewModel.getAssetsByCompany,
              ]),
              builder: (_, child) {
                final isLoading =
                    _viewModel.buildTreeStructure.running ||
                    _viewModel.getFilteredAssetsAndLocation.running ||
                    _viewModel.getLocationsByCompany.running ||
                    _viewModel.getAssetsByCompany.running;

                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_viewModel.lstTreeNode.isEmpty) {
                  return Center(child: Text('Nenhum registro encontrado'));
                }

                return ListView.builder(
                  itemCount: _viewModel.lstTreeNode.length,
                  itemBuilder: (context, index) {
                    return LazyTreeNode(node: _viewModel.lstTreeNode[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _listener() {
    if (_viewModel.getLocationsByCompany.result != null) {
      if (_viewModel.getLocationsByCompany.error) {
        final errorMessage = _viewModel.getLocationsByCompany.errorMessage;

        _showMessage(errorMessage);
      }
    }

    if (_viewModel.getAssetsByCompany.result != null) {
      if (_viewModel.getAssetsByCompany.error) {
        final errorMessage = _viewModel.getAssetsByCompany.errorMessage;

        _showMessage(errorMessage);
      }
    }

    if (_viewModel.getFilteredAssetsAndLocation.result != null) {
      if (_viewModel.getFilteredAssetsAndLocation.error) {
        final errorMessage =
            _viewModel.getFilteredAssetsAndLocation.errorMessage;

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
