import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  InAppWebViewController webView;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('InAppWebView Example'),
        ),
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
              child: InAppWebView(
                  initialData: InAppWebViewInitialData(data: """
<!DOCTYPE html>
<html>
<head>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/tinymce/5.2.1/tinymce.min.js"></script>
</head>
<body>
<textarea id="demo"></textarea>
<script>
  tinymce.init({
    selector: 'textarea#demo',
    height: 500, 
    menubar: true,
    plugins: ['print', 'preview', 'powerpaste', 'casechange', 'importcss', 'tinydrive', 'searchreplace', 'autolink', 'autosave', 'save', 'directionality', 'advcode', 'visualblocks', 'visualchars', 'fullscreen', 'image', 'link', 'media', 'mediaembed', 'template', 'codesample', 'table', 'charmap', 'hr', 'pagebreak', 'nonbreaking', 'anchor', 'toc', 'insertdatetime', 'advlist', 'lists', 'checklist', 'wordcount', 'tinymcespellchecker', 'a11ychecker', 'imagetools', 'textpattern', 'noneditable', 'help', 'formatpainter', 'permanentpen', 'pageembed', 'charmap', 'tinycomments', 'mentions', 'quickbars', 'linkchecker', 'emoticons','advtable'],
   mobile: {
    plugins: 'print preview powerpaste casechange importcss tinydrive searchreplace autolink autosave save directionality advcode visualblocks visualchars fullscreen image link media mediaembed template codesample table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists checklist wordcount tinymcespellchecker a11ychecker textpattern noneditable help formatpainter pageembed charmap mentions quickbars linkchecker emoticons advtable'
  },
   contextmenu: "link image imagetools table configurepermanentpen",
   menubar: 'file edit view insert format tools table tc help',
   toolbar: 'undo redo | bold italic underline strikethrough | fontselect fontsizeselect formatselect | alignleft aligncenter alignright alignjustify | outdent indent |  numlist bullist checklist | forecolor backcolor casechange permanentpen formatpainter removeformat | pagebreak | charmap emoticons | fullscreen  preview save print | insertfile image media pageembed template link anchor codesample | a11ycheck ltr rtl | showcomments addcomment',
  });
 
   window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
     window.flutter_inappwebview.callHandler('testjs','WebView Ready').then(function(result) {
       console.log(result); 
     });

     function getdata(){
     window.flutter_inappwebview.callHandler('testjs', 1, true, ['bar', 5], {foo: 'baz'}).then(function(result) {
       console.log(result);
     });
     }
   });
</script>
</body>
</html>
"""),
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        debuggingEnabled: true,
                      ),
                      android: AndroidInAppWebViewOptions(
                          builtInZoomControls: true)),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                    webView.addJavaScriptHandler(
                        handlerName: "testjs",
                        callback: (List data) {
                          debugPrint(data.toString());
                        });
                  },
                  onLoadStart:
                      (InAppWebViewController controller, String url) {},
                  onLoadStop:
                      (InAppWebViewController controller, String url) {}))
        ])),
        bottomNavigationBar: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: MaterialButton(
              onPressed: () {
                webView.evaluateJavascript(source: """
            window.flutter_inappwebview.callHandler('testjs',tinymce.activeEditor.getContent()).then(function(result) {
              console.log(result);
            });
            """);
              },
              child: Text("Get Text"),
            )),
            Padding(padding: EdgeInsets.all(10)),
            Expanded(
                child: MaterialButton(
              onPressed: () {
                webView.evaluateJavascript(source: """
            window.flutter_inappwebview.callHandler('testjs',tinymce.activeEditor.setContent("<b>Demo text</b>")).then(function(result) {
              console.log(result);
            });
            """);
              },
              child: Text("Set Text"),
            ))
          ],
        ),
      ),
    );
  }
}
