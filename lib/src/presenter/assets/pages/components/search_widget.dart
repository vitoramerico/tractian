import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final void Function(String text) onChanged;

  const SearchWidget({super.key, required this.onChanged});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _tecSearch = TextEditingController();

  bool _hasText = false;

  @override
  void dispose() {
    _tecSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _tecSearch,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Buscar Ativo ou Local',
        suffixIcon:
            _hasText
                ? IconButton(
                  onPressed: () {
                    _tecSearch.clear();
                    widget.onChanged('');
                    setState(() {
                      _hasText = false;
                    });
                  },
                  icon: const Icon(Icons.clear),
                )
                : null,
      ),
      onChanged: (v) {
        widget.onChanged(v);
        setState(() {
          _hasText = v.isNotEmpty;
        });
      },
    );
  }
}
