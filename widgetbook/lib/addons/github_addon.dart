import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: implementation_imports
import 'package:widgetbook/src/settings/setting.dart';
import 'package:widgetbook/widgetbook.dart';

class GitHubAddon extends WidgetbookAddon<void> {
  GitHubAddon(this.repository) : super(name: 'GitHub');

  final String repository;

  @override
  List<Field> get fields {
    return [
      StringField(name: ''),
    ];
  }

  @override
  void valueFromQueryGroup(Map<String, String> group) {}

  @override
  Widget buildFields(BuildContext context) {
    return Setting(
      name: 'Repository',
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
        icon: const Icon(
          FontAwesomeIcons.github,
        ),
        label: Text(
          repository,
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: () => launchUrl(
          Uri.parse('https://github.com/$repository'),
        ),
      ),
    );
  }
}
