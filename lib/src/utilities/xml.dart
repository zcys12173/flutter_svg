import 'dart:ffi';

import 'package:xml/xml_events.dart';

/// The namespace for xlink from the SVG 1.1 spec.
const String kXlinkNamespace = 'http://www.w3.org/1999/xlink';

/// Get the `xlink:href` or `href` attribute, preferring `xlink`.
///
/// SVG 1.1 specifies that these attributes should be in the xlink namespace.
/// SVG 2 deprecates that namespace.
String? getHrefAttribute(Map<String, String> attributes) => getAttribute(
      attributes,
      'href',
      def: getAttribute(attributes, 'href'),
    );

/// Gets the attribute, trims it, and returns the attribute or default if the attribute
/// is null or ''.
///
/// Will look to the style first if it can.
String? getAttribute(
  Map<String, String> el,
  String name, {
  String? def = '',
  bool checkStyle = true,
}) {
  String raw = '';
  if (checkStyle) {
    final String? style = _getAttribute(el, 'style');
    if (style != '' && style != null) {
      // Probably possible to slightly optimize this (e.g. use indexOf instead of split),
      // but handling potential whitespace will get complicated and this just works.
      // I also don't feel like writing benchmarks for what is likely a micro-optimization.
      final List<String> styles = style.split(';');
      raw = styles.firstWhere(
          (String str) => str.trimLeft().startsWith(name + ':'),
          orElse: () => '');

      if (raw != '') {
        raw = raw.substring(raw.indexOf(':') + 1).trim();
      }
    }

    if (raw == '') {
      raw = _getAttribute(el, name);
    }
  } else {
    raw = _getAttribute(el, name);
  }

  return raw == '' ? def : raw;
}

String appendRotateCenter(String transform,double cx,double cy){
  if(!transform.contains("rotate")){
    return transform;
  }

  int startIndex = transform.indexOf("rotate(");
  int appendIndex = transform.indexOf(")",startIndex);
  String finalStr =  transform.substring(0,appendIndex)+",$cx,$cy"+transform.substring(appendIndex);
  print(finalStr);
  return finalStr;
}

String _getAttribute(
  Map<String, String> attributes,
  String localName, {
  String def = '',
}) {
  String result = attributes[localName] ?? def;
  if(localName=="transform"){
    double cx = double.parse(attributes["width"]??"0")/2;
    double cy = double.parse(attributes["height"]??"0")/2;
    result = appendRotateCenter(result, cx, cy);
  }
  return result;
}

/// Extension on List<XmlEventAttribute> for easy conversion to an attribute
/// map.
extension AttributeMapXmlEventAttributeExtension on List<XmlEventAttribute> {
  /// Converts the List<XmlEventAttribute> to an attribute map.
  Map<String, String> toAttributeMap() => <String, String>{
        for (final XmlEventAttribute attribute in this)
          attribute.localName: attribute.value.trim(),
      };
}
