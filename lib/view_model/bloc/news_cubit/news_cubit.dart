import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_shared/model/news/news_model.dart';
import 'package:todo_shared/view_model/servises/network/DioHelper.dart';
import 'package:todo_shared/view_model/servises/network/endPoints.dart';

import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  static NewsCubit get(context) => BlocProvider.of<NewsCubit>(context);

  NewsModel? newsModel;

  Future<void> getSportsNews() async {
    emit(GetSportsNewsLoadingState());
    DioHelper.get(endPoint: topHeadlines, queryParameters: {
      'apiKey' : 'dba90520a2b243ffaaa8296d5b973d47',
      'category' : 'sports',
      'country' : 'eg',
    }).then((value) {
      print(value?.data.toString());
      newsModel = NewsModel.fromJson(value?.data);
      print(newsModel?.articles?.length ?? 'No Articles');
      emit(GetSportsNewsSuccessState());
    }).catchError((onError){
      emit(GetSportsNewsErrorState());
    });
  }
}
