import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quelendar/preference_provider.dart';
import 'package:quelendar/util/card_table.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  FilterViewState createState() => FilterViewState();
}

class FilterViewState extends State<FilterView> {
  String questNameFilter = "";
  String tagNameFilter = "";

  @override
  void initState() {
    super.initState();
    final preferenceProvider = context.read<PreferenceProvider>();
    questNameFilter = preferenceProvider.questNameFilter ?? "";
    tagNameFilter = preferenceProvider.tagNameFilter ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final preferenceProvider = context.watch<PreferenceProvider>();

    final listViewChildren = [
      CardTable(data: {
        '퀘스트': TextFormField(
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          onChanged: (text) {
            setState(() {
              questNameFilter = text;
            });
          },
          initialValue: questNameFilter,
          decoration: const InputDecoration(
            hintText: "퀘스트 이름으로 검색하기",
          ),
          keyboardType: TextInputType.text,
        ),
        '태그': TextFormField(
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          onChanged: (text) {
            setState(() {
              tagNameFilter = text;
            });
          },
          initialValue: tagNameFilter,
          decoration: const InputDecoration(
            hintText: "태그 이름으로 검색하기",
          ),
          keyboardType: TextInputType.text,
        ),
      }),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            preferenceProvider.setQuestNameFilter(questNameFilter);
            preferenceProvider.setTagNameFilter(tagNameFilter);
            Navigator.of(context).pop();
          },
          child: Text('적용', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: const Text("검색"),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: listViewChildren),
      ),
    );
  }
}
