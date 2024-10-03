import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:SpotiDom/bloc/weather/weather_event.dart';
import 'package:SpotiDom/bloc/weather/weather_state.dart';
import 'package:SpotiDom/data/repositories/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    // Đăng ký sự kiện FetchWeatherByLocation
    on<FetchWeatherByCity>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await weatherRepository.getWeatherByCity(event.city);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError('Failed to load weather for city'));
      }
    });

    on<FetchWeatherByLocation>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await weatherRepository.getWeatherByLocation();
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError('Failed to load weather by location'));
      }
    });
  }
}
