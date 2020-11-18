import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Doodle {
  final String name;
  final String time;
  final String content;
  final String status;
  final String doodle;
  final Color iconBackground;
  final Icon icon;
  Doodle(
      {this.name,
      this.time,
      this.content,
      this.status,
      this.doodle,
      this.icon,
      this.iconBackground});
}

class TimelinePage extends StatefulWidget {
  TimelinePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final PageController pageController =
      PageController(initialPage: 1, keepPage: true);
  int pageIx = 1;
  /*List<Doodle> doodles = [
    Doodle(
        name: "Donor : KALAI VANI",
        time: "Sat 7 Nov",
        content:
            "One of Al-Sufi's greatest works involved fact-checking the Greek astronomer Ptolemy's measurements of the brightness and size of stars. In the year 964 AD, Al-Sufi published his findings in a book titled Kitab al-Kawatib al-Thabita al-Musawwar, or The Book of Fixed Stars. In many cases, he confirmed Ptolemy’s discoveries, but he also improved upon his work by illustrating the constellations and correcting some of Ptolemy’s observations about the brightness of stars.",
        doodle: "assets/images/topmenu/ic_burger.png",
        icon: Icon(FontAwesomeIcons.donate, color: Colors.white),
        iconBackground: Colors.greenAccent),
    Doodle(
        name: "ramu",
        time: "Sun 25 oct",
        content:
            " Abu al-Wafa' is an innovator whose contributions to science include one of the first known introductions to negative numbers, and the development of the first quadrant, a tool used by astronomers to examine the sky. His pioneering work in spherical trigonometry was hugely influential for both mathematics and astronomy.",
        doodle: "assets/images/topmenu/ic_books.png",
        icon: Icon(
          Icons.blur_circular,
          color: Colors.white,
        ),
        iconBackground: Colors.indigo),
    Doodle(
        name: "Donor : vaish",
        time: "Fri 31 sep",
        content:
            "Ibn al-Haytham was the first to explain through experimentation that vision occurs when light bounces on an object and then is directed to one's eyes. He was also an early proponent of the concept that a hypothesis must be proved by experiments based on confirmable procedures or mathematical evidence—hence understanding the scientific method five centuries before Renaissance scientists.",
        doodle: "assets/images/topmenu/ic_clothes.png",
        icon: Icon(
          FontAwesomeIcons.donate,
          color: Colors.white,
          size: 32.0,
        ),
        iconBackground: Colors.greenAccent),
    Doodle(
        name: "Donor: Jothi Ram",
        time: "Fri 25 sep",
        content:
            "Biruni is regarded as one of the greatest scholars of the Golden Age of Muslim civilisation and was well versed in physics, mathematics, astronomy, and natural sciences, and also distinguished himself as a historian, chronologist and linguist. He studied almost all fields of science and was compensated for his research and strenuous work. Royalty and powerful members of society sought out Al-Biruni to conduct research and study to uncover certain findings.",
        doodle: "assets/images/topmenu/ic_elec.png",
        icon: Icon(
          FontAwesomeIcons.donate,
          color: Colors.white,
        ),
        iconBackground: Colors.greenAccent),
    Doodle(
        name: "ramu",
        time: "Tue 22 sep",
        content:
            "Avicenna (Ibn Sīnā) was a Persian polymath who is regarded as one of the most significant physicians, astronomers, thinkers and writers of the Islamic Golden Age. He has been described as the father of early modern medicine. Of the 450 works he is known to have written, around 240 have survived, including 150 on philosophy and 40 on medicine.\nHis most famous works are The Book of Healing, a philosophical and scientific encyclopedia, and The Canon of Medicine, a medical encyclopedia which became a standard medical text at many medieval universities and remained in use as late as 1650. In 1973, Avicenna's Canon Of Medicine was reprinted in New York.\nBesides philosophy and medicine, Avicenna's corpus includes writings on astronomy, alchemy, geography and geology, psychology, Islamic theology, logic, mathematics, physics and works of poetry.",
        doodle: "assets/images/topmenu/ic_books.png",
        icon: Icon(
          FontAwesomeIcons.donate,
          color: Colors.white,
        ),
        iconBackground: Colors.greenAccent),
    Doodle(
        name: "ramu",
        time: "Tue 22 sep",
        content:
            "Averroes was an Andalusian philosopher and thinker who wrote about many subjects, including philosophy, theology, medicine, astronomy, physics, Islamic jurisprudence and law, and linguistics. His philosophical works include numerous commentaries on Aristotle, for which he was known in the West as The Commentator. He also served as a judge and a court physician for the Almohad Caliphate.",
        doodle: "assets/images/topmenu/ic_books.png",
        icon: Icon(
          Icons.blur_circular,
          color: Colors.white,
        ),
        iconBackground: Colors.indigo),
    Doodle(
        name: "Donor : Kalai",
        time: "Tue 17 sep",
        content:
            "Tusi was a Persian polymath, architect, philosopher, physician, scientist, and theologian. He is often considered the creator of trigonometry as a mathematical discipline in its own right. Ibn Khaldun (1332–1406) considered Al-Tusi to be the greatest of the later Persian scholars.",
        doodle: "assets/images/topmenu/ic_burger.png",
        icon: Icon(
          FontAwesomeIcons.donate,
          color: Colors.white,
        ),
        iconBackground: Colors.greenAccent),
  ];*/
  List<Doodle> doodles = [];
  populatehistory() async {
    String id = FirebaseAuth.instance.currentUser.uid;

    var s = await FirebaseFirestore.instance.collection('Donation').snapshots();
    s.toList();
    s.forEach((element) {
      element.docs.forEach((element) {
        var elt = element.data();
        String imageurl = "assets/images/topmenu/ic_burger.png";
        switch (elt['Itemtype']) {
          case 'Clothes':
            imageurl = "assets/images/topmenu/ic_clothes.png";
            break;
          case 'Education':
            imageurl = "assets/images/topmenu/ic_books.png";
            break;
          case 'Medicine':
            imageurl = "assets/images/topmenu/ic_others.png";
            break;
          case 'Food':
            imageurl = "assets/images/topmenu/ic_burger.png";
            break;
          default:
            imageurl = "assets/images/topmenu/ic_others.png";
            break;
        }
        if (elt['Benefactor'] == id) {
          setState(() {
            doodles.add(Doodle(
                name: elt['Itemcontact'],
                time: elt['Itemloc'],
                content: elt['Itemname'],
                status: elt['Status'],
                doodle: imageurl,
                icon: Icon(
                  Icons.blur_circular,
                  color: Colors.white,
                ),
                iconBackground: Colors.indigo));
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    populatehistory();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      timelineModel(TimelinePosition.Left),
      timelineModel(TimelinePosition.Center),
      timelineModel(TimelinePosition.Right)
    ];

    return Scaffold(
        /*bottomNavigationBar: BottomNavigationBar(
            currentIndex: pageIx,
            onTap: (i) => pageController.animateToPage(i,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.format_align_left),
                title: Text("LEFT"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.format_align_center),
                title: Text("CENTER"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.format_align_right),
                title: Text("RIGHT"),
              ),
            ]),*/
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.green,
        ),
        body: PageView(
          onPageChanged: (i) => setState(() => pageIx = i),
          controller: pageController,
          children: pages,
        ));
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      itemBuilder: centerTimelineBuilder,
      itemCount: doodles.length,
      physics: position == TimelinePosition.Left
          ? ClampingScrollPhysics()
          : BouncingScrollPhysics(),
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = doodles[i];
    final textTheme = Theme.of(context).textTheme;
    return TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  doodle.doodle,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text("Item: " + doodle.content,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 15)),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "    Contact:" + doodle.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "Loc: " + doodle.time,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "Status: " + doodle.status,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        position:
            i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == doodles.length,
        iconBackground: doodle.iconBackground,
        icon: doodle.icon);
  }
}
