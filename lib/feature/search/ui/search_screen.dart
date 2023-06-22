import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_machines/feature/search/bloc/search_cubit.dart';
import 'package:sound_machines/feature/search/repository/search_repository.dart';

import '../../../models/track.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../widgets/sliverAppBar/sliver_playlistContainer.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import '../../../widgets/text_field/dynamic_text_field.dart';
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
  bool whatSearch = true;

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<SearchRepository>(context);
    BlocProvider.of<SearchCubit>(context).initialLoadSearch();

    return BlocBuilder<SearchCubit, SearchState>(builder: (context, state) {
      if (state is SearchSuccessState) {
        isSuccess = true;
      }
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
                        .searchTracks(_searchController.text);
                    BlocProvider.of<SearchCubit>(context)
                        .searchPlayList(_searchController.text);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                DynamicTextField(
                  borderRadius: 20,
                  height: 50,
                  controller: _searchController,
                  changed: (String str) {
                    BlocProvider.of<SearchCubit>(context).searchTracks(str);
                    BlocProvider.of<SearchCubit>(context).searchPlayList(str);
                  },
                  color: AppColors.colorTextField,
                )
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<SearchCubit>(context).initialLoadSearch();
            },
            child: CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            whatSearch = !whatSearch;
                            setState(() {});
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: whatSearch
                                  ? AppColors.colorTextField
                                  : AppColors.blackColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Center(
                                child: Text(
                              'Музыка',
                              style: AppTypography.font20fff,
                            )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            whatSearch = !whatSearch;
                            setState(() {});
                          },
                          child: Container(
                            width: 130,
                            height: 30,
                            decoration: BoxDecoration(
                              color: whatSearch
                                  ? AppColors.blackColor
                                  : AppColors.colorTextField,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Center(
                                child: Text(
                              'Плейлисты',
                              style: AppTypography.font20fff,
                            )),
                          ),
                        )
                      ],
                    )),
              ),
              whatSearch
                  ? SliverList(
                      delegate: SliverChildListDelegate(repository.searchTracks!
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: SmallTrekScreen(
                                  track: e,
                                ),
                              ))
                          .toList()),
                    )
                  : SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        mainAxisExtent: 250,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 4.0,
                      ),
                      delegate:
                          SliverChildListDelegate(repository.searchPLayList!
                              .map((e) => PlaylistWidget(
                                    playlist: e,
                                  ))
                              .toList()),
                    ),
            ]),
          ));
    });
  }
}
