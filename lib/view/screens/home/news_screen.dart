import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_shared/model/news/news_model.dart';
import 'package:todo_shared/view_model/bloc/news_cubit/news_cubit.dart';
import '../../../view_model/bloc/news_cubit/news_state.dart';
import '../../components/news/new_widget.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<NewsCubit, NewsState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = NewsCubit.get(context);
          return cubit.newsModel == null
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.all(12.w),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return NewWidget(
                        article: cubit.newsModel?.articles?[index] ?? Article(),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10.h,
                    ),
                    itemCount: cubit.newsModel?.articles?.length ?? 0,
                  ),
                );
        },
      ),
    );
  }
}
