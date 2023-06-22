import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../utils/constants.dart';
import '../repository/search_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchRepository searchRepository;

  SearchCubit({required this.searchRepository}) : super(SearchInitial()) {
    searchRepository.searchLoadingState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(SearchLoadingState());
      if (event == LoadingStateEnum.success) emit(SearchSuccessState());
      if (event == LoadingStateEnum.fail) emit(SearchFailState());
    });
  }

  initialLoadSearch() {
    searchRepository.initialLoadTracks();
  }

  loadTracks(String str) {
    print(str);
    print('--------------');
    searchRepository.searchTrackByCharElem(str);
  }
}
