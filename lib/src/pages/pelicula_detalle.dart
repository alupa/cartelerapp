import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/utils/media_utils.dart' as utils;

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(context, pelicula),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            utils.isMobileLayout(context)
                ? Column(
                    children: <Widget>[
                      _posterTitulo(context, pelicula),
                      _descripcion(pelicula),
                      _crearCasting(pelicula),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: _posterTitulo(context, pelicula),
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(children: <Widget>[
                          _descripcion(pelicula),
                          _crearCasting(pelicula)
                        ]),
                      )
                    ],
                  )
          ]),
        ),
      ],
    ));
  }

  Widget _crearAppbar(BuildContext context, Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      leading: BackButton(
        color: Colors.grey,
      ),
      backgroundColor: Colors.indigoAccent,
      expandedHeight: utils.isMobileLayout(context) ? 200.0 : 300.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            pelicula.title,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FadeInImage(
              image: NetworkImage(pelicula.getBackgroundImg()),
              placeholder: AssetImage('assets/img/loading.gif'),
              fadeInDuration: Duration(milliseconds: 150),
              fit: BoxFit.cover,
            ),
            DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
              Color(0x90000000),
              Color(0x00000000),
            ], begin: Alignment(0.0, 0.9), end: Alignment(0.0, 0.0))))
          ],
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: utils.isMobileLayout(context)
          ? Row(
              children: <Widget>[
                _poster(context, pelicula),
                SizedBox(width: 10.0),
                Flexible(
                  child: _titulo(context, pelicula),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _titulo(context, pelicula),
                SizedBox(height: 10.0),
                _poster(context, pelicula)
              ],
            ),
    );
  }

  Widget _poster(BuildContext context, Pelicula pelicula) {
    return Hero(
      tag: pelicula.uniqueId,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image(
          image: NetworkImage(pelicula.getPosterImg()),
          height: utils.isMobileLayout(context) ? 150 : 300,
        ),
      ),
    );
  }

  Widget _titulo(BuildContext context, Pelicula pelicula) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          pelicula.originalTitle,
          style: Theme.of(context).textTheme.title,
        ),
        Row(
          children: <Widget>[
            Icon(Icons.star_border),
            Text(pelicula.voteAverage.toString()),
          ],
        ),
      ],
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(pelicula.overview, style: TextStyle(fontSize: 16)),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final movieProvider = new PeliculasProvider();
    return FutureBuilder(
      future: movieProvider.getCast(pelicula.id.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData)
          return _crearActoresPageView(snapshot.data, context);
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores, BuildContext context) {
    return SizedBox(
      height: utils.isMobileLayout(context) ? 200 : 230,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i], context),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: utils.isMobileLayout(context) ? 150 : 200,
              fit: BoxFit.cover,
            ),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
