
abstract class NewsState {}

class NewsInitial extends NewsState {}

class GetSportsNewsLoadingState extends NewsState {}
class GetSportsNewsSuccessState extends NewsState {}
class GetSportsNewsErrorState extends NewsState {}