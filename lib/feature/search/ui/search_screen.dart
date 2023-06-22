import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/search/bloc/search_cubit.dart';
import 'package:sound_machines/feature/search/repository/search_repository.dart';

import '../../../models/track.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import '../../../widgets/treck/small_treck.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSuccess = false;
  final _searchController = TextEditingController();
  List<Track> list = [];

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<SearchRepository>(context);
    BlocProvider.of<SearchCubit>(context).initialLoadSearch();

    return BlocBuilder<SearchCubit, SearchState>(builder: (context, state) {
      if (state is SearchSuccessState) {isSuccess = true;}
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  child: const Icon(Icons.search),
                  onTap: () {
                    BlocProvider.of<SearchCubit>(context)
                        .loadTracks(_searchController.text);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomTextField(
                  borderRadius: 20,
                  height: 50,
                  controller: _searchController,
                  isError: false,
                )
              ],
            ),
          ),
          body: isSuccess ? RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<SearchCubit>(context).initialLoadSearch();
            },
            child: SingleChildScrollView(
              child: Column(
                  children: repository.searchTracks!
                      .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: SmallTrekScreen(
                              track: e,
                            ),
                      ))
                      .toList()),
            ),
          ) : const Center(child: CircularProgressIndicator()));
    });
  }
}
