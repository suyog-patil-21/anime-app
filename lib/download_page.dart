import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

var downloadList = [];

class _DownloadPageState extends State<DownloadPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isDownloading = false;
  @override
  void initState() {
    super.initState();

    //FIXME : Fixe the The Dissmissible Widget
    downloadList.add('a');
    downloadList.add('b');
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
  }

  void _handleOnPressed() {
    setState(() {
      isDownloading = !isDownloading;
      isDownloading
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: 2,
          itemBuilder: (BuildContext context, index) {
            final item = downloadList[index];
            return Dismissible(
              key: Key(item),
              onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  downloadList.removeAt(index);
                });
                // Then show a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$item close download')));
              },
              // Show a red background as the item is swiped away.
              background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  color: Colors.blueGrey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.delete_forever_rounded,
                      ),
                      const Icon(
                        Icons.delete_forever_rounded,
                      ),
                    ],
                  )),
              child: Card(
                  child: ListTile(
                title: Text(downloadList[index]),
                trailing: IconButton(
                  onPressed: () => _handleOnPressed(),
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.pause_play,
                    progress: _animationController,
                  ),
                ),
                // IconButton(
                //     onPressed: () {}, icon: const Icon(Icons.clear_rounded)),
                subtitle:
                    const Text('Progress bar ============================'),
              )),
            );
          }),
    );
  }
}
