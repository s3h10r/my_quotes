import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/dimens.dart';
import 'package:my_quotes/commons/utils/presentation_formatter.dart';
import 'package:my_quotes/model/quote.dart';
import 'package:my_quotes/commons/architecture/resource.dart';
import 'package:provider/provider.dart';

import 'quotes_tab_bloc.dart';

class QuotesTab extends StatefulWidget {

  @override
  _QuotesTabState createState() => _QuotesTabState();
}

class _QuotesTabState extends State<QuotesTab> {

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<QuotesTabBloc>(context);
    return StreamBuilder<Resource<List<Quote>>>(
        initialData: Resource.loading(),
        stream: bloc.quotesStream,
        builder: (_, AsyncSnapshot<Resource<List<Quote>>> snapshot) {
          final resource = snapshot.data;

          switch (resource.status) {
            case Status.LOADING:
              return _buildProgressIndicator();
            case Status.SUCCESS:
              return _buildQuotesList(resource.data);
            case Status.ERROR:
              return Text(resource.message);
          }
          return Text('Unknown error');
        });
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildQuotesList(List<Quote> quotes) {
    return ListView.builder(
      itemCount: quotes.length,
      itemBuilder: (BuildContext context, int index) {
        final quote = quotes[index];

        return _buildQuoteTile(quote);
      },
    );
  }

  Widget _buildQuoteTile(Quote quote) {
    return Card(
      elevation: Dimens.oneThirdDefaultSpacing,
      margin: const EdgeInsets.all(Dimens.halfDefaultSpacing),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.defaultSpacing),
        child: Column(
          children: [
            Text(
              "${quote.content}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: Dimens.halfDefaultSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(PresentationFormatter.formatAuthor(quote.author)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
