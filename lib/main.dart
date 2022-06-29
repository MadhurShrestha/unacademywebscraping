import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String>? titleList;

  @override
  void initState() {
    super.initState();
    initChaptersTitleScrap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Scrapping'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 56),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Scrapped data is: ',
                style: TextStyle(fontSize: 22, color: Colors.indigo),
              ),
              const SizedBox(
                height: 16,
              ),
              if (titleList != null)
                for (final title in titleList!)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Future initChaptersTitleScrap() async {
    //loading circle

    const rawUrl =
        'https://unacademy.com/course/gravitation-for-iit-jee/D5A8YSAJ';
    final webScraper = WebScraper('https://unacademy.com');
    final endpoint = rawUrl.replaceAll(r'https://unacademy.com', '');
    if (await webScraper.loadWebPage(endpoint)) {
      final titleElements = webScraper.getElement(
          'div.css-1fcnvud-Wrapper > a.css-1xmk4yu-StyledAnchor  > div.itemContainer > div.css-5yqm8a-FlexContent > div.lessonWrapper  > div.css-1cdehjt-ItemInfo > h3.css-aqed61-H6-LessonName',
          []);
      final titleList = <String>[];
      titleElements.forEach((element) {
        final title = element['title'];
        titleList.add('$title');
        print(titleList);
      });
      if (mounted) {
        setState(() {
          this.titleList = titleList;
        });
      }
    } else {
      print('Cannot load url');
    }
  }
}
