import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_shared/model/news/news_model.dart';

class NewWidget extends StatelessWidget {
  Article article;
  NewWidget({required this.article, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          Image.network(
            article.urlToImage ?? '',
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 50,);
            },
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Text(
                  // 'إيميليانو: أحترم مبابي على المستوى الشخصي.. وهذا سر احتفالي المثير للجدل',
                  article.title ?? '',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      article.source?.name ?? '',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    Spacer(),
                    Text(
                      article.publishedAt ?? '',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
