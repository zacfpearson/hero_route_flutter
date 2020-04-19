import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class ScrollLeagues extends StatefulWidget{
  String initialTeam = "";
  double width = 0;
  ScrollLeagues(this.initialTeam, this.width);

  @override
  ScrollLeagueState createState() => new ScrollLeagueState(initialTeam, width);
}

class ScrollLeagueState extends State<ScrollLeagues> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  ScrollController _scrollController = new ScrollController();
  Animation<Offset> _animRtoLTop;
  Animation<Offset> _animRtoLBottom;
  Animation<Offset> _animLtoRTop;
  Animation<Offset> _animLtoRBottom;
  bool _swipeRightToLeft = true;
  int _currentIndex = 0;
  double _cardWidth = 300.0;
  double _cardMargin = 10.0;
  String initialTeam = "";
  List<String> nationalLeague = ["Dodgers", "Cubs", "Mets", "Braves", "Cardinals", "Brewers", "Phillies", "Giants", "Nationals", "Reds", "Pirates", "Diamondbacks", "Marlins", "Rockies", "Padres"];
  List<String> americanLeague = ["Redsox", "Yankees", "Astros", "Indians", "Angels", "Athletics", "Orioles", "Bluejays", "Rangers", "Whitesox", "Twins", "Rays", "Royals", "Mariners"];

  ScrollLeagueState(String team, double width){
    initialTeam = team;
    if( americanLeague.contains(initialTeam)){
      _currentIndex = 1;
    }
    _scrollController = new ScrollController(initialScrollOffset: width * _currentIndex);
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animRtoLTop = Tween(begin: Offset(0.0, 0.0), end: Offset(50.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
          ..addListener(() {
            setState(() {});
          });

    _animRtoLBottom = Tween(begin: Offset(0.0, 0.0), end: Offset(100.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _animLtoRTop = Tween(begin: Offset(0.0, 0.0), end: Offset(25.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _animLtoRBottom = Tween(begin: Offset(0.0, 0.0), end: Offset(-20.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24 - 70) / 5;
    final double itemWidth = size.width / 3;

    return GestureDetector(
          onHorizontalDragEnd: _onHorizontalDragEnd,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            height: MediaQuery.of(context).size.height-kToolbarHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              controller: _scrollController,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height-kToolbarHeight,
                  child: GridView.count(
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 0.0,
                    crossAxisCount: 3,
                    childAspectRatio: (itemWidth / itemHeight),
                    children: List.generate(15, (index) {
                      return GestureDetector(
                        onTap: (){
                          _selectedTeam(nationalLeague[index]);
                        },
                        child: Hero(
                            tag: nationalLeague[index],
                            child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.contain,
                                  image: new ExactAssetImage(
                                    "assets/images/"+nationalLeague[index]+".png"
                                  ),
                              ),
                            ),
                          ), 
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height-kToolbarHeight,
                  child: GridView.count(
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 0.0,
                    crossAxisCount: 3,
                    childAspectRatio: (itemWidth / itemHeight),
                    children: List.generate(14, (index) {
                      return GestureDetector(
                        onTap: (){
                          _selectedTeam(americanLeague[index]);
                        },
                        child: Hero(
                            tag: americanLeague[index],
                            child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.contain,
                                  image: new ExactAssetImage(
                                    "assets/images/"+americanLeague[index]+".png"
                                  ),
                              ),
                            ),
                          ), 
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
  }


  _selectedTeam(String team){
    Navigator.pop(context, team);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity < 0) {
      //SWIPED Right to Left!!

      if (_currentIndex < (2) - 1) {
        setState(() {
          _swipeRightToLeft = true;
          _currentIndex += 1;
        });
        double offset = MediaQuery.of(context).size.width;
        _scrollController.animateTo(offset * _currentIndex,
            duration: Duration(milliseconds: 400), curve: Curves.easeOut);

        _controller.forward().then((s) {
          _controller.reverse();
        });
      }
    } else if (details.primaryVelocity > 0) {
      //SWIPED Left to Right!
      if (_currentIndex > 0) {
        setState(() {
          _swipeRightToLeft = false;
          _currentIndex -= 1;
        });
        double offset = MediaQuery.of(context).size.width;
        _scrollController.animateTo(offset * _currentIndex,
            duration: Duration(milliseconds: 400), curve: Curves.easeOut);

        _controller.forward().then((s) {
          _controller.reverse();
        });
      }
    }
  }
}

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String selectedTeam = "Phillies";

  @override
  Widget build(BuildContext context) {
    timeDilation = 5.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('HeroRoute'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: (){
            _navigateAndDisplaySelection(context, selectedTeam, MediaQuery.of(context).size.width);
          },
          child: Hero(
            tag: selectedTeam,
            flightShuttleBuilder: (
                BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext,
              ) {
                final Hero toHero = toHeroContext.widget;
                return RotationTransition(
                  turns: animation,
                  child: toHero.child,
                );
              },
            child: Container(
              width:100,
              height: 100,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.contain,
                    image: new ExactAssetImage(
                      "assets/images/"+selectedTeam+".png"
                    ),
                ),
              ), 
            ),
          ),
        ),
      ),
    );
  }

  _navigateAndDisplaySelection(BuildContext context, String team, double width) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Scaffold(
                  appBar: AppBar(
                    leading: Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () { Navigator.pop(context, team); },
                          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                        );
                      },
                    ),
                    title: Text('Leagues'),
                  ),
                  body: new ScrollLeagues(team, width),
                ),
      ),
    );
    selectedTeam = result;
  }

}