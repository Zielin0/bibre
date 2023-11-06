import 'package:bibre/bloc/bible_bloc.dart';
import 'package:bibre/bloc/bible_event.dart';
import 'package:bibre/bloc/bible_state.dart';
import 'package:bibre/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();

    context.read<BibleInfoBloc>().add(LoadBibleInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<BibleInfoBloc, BibleState>(
          builder: (context, state) {
            if (state is BibleInfoInit) {
              return Container();
            } else if (state is BibleInfoLoading) {
              return const Center(
                child: Constants.loadingSpinner,
              );
            } else if (state is BibleInfoResponse) {
              return state.either.fold(
                (error) {
                  return BibreErrorWidget(
                    message: error,
                  );
                },
                (bibleInfoModel) {
                  Future.delayed(Duration.zero, () {
                    Navigator.pushReplacementNamed(context, "/home",
                        arguments: {
                          "infoModel": bibleInfoModel,
                        });
                  });

                  return Container();
                },
              );
            }

            return const Center(
              child: Text("should not be seen"),
            );
          },
        ),
      ),
    );
  }
}
