import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:console/console.dart';
import 'package:path/path.dart' as path;
import 'package:yaml_writer/yaml_writer.dart';

import 'config.dart';
import 'utils.dart';

const _helpText = """
Flutter Releaser v{version}
by Tomás Weigenast
github.com/tomasweigenast/flutter-releaser

Commands:
  - init (options)   Initializes the current directory as a Flutter project
  - build            Builds the current proj9ect

""";

late final Logger logger;
Future<void> main(List<String> args) async {
  Console.init();
  logger = Logger.standard(ansi: Ansi(true));

  var parser = ArgParser();
  var initCommand = parser.addCommand("init");
  initCommand.addOption("dir", abbr: "d");

  parser.addCommand("build");

  var results = parser.parse(args);
  if(results.command == null) {
    Console.write(_helpText.replaceAll("{version}", Utils.getCurrentVersion()));
  } else {
    switch(results.command!.name) {
      case "init":
        await _initCommand(results.command!);
        break;
    }
  }

}

Future<void> _initCommand(ArgResults result) async {
  String p = Directory.current.path;
  if(result.options.contains("dir")) {
    p = result["dir"];
  }

  var progress = logger.progress("Detecting your platforms...");
  var platforms = await Utils.getPlatforms(p);
  progress.finish();

  if(platforms.isEmpty) {
    logger.write(logger.ansi.error("No platforms detected. Is this a Flutter project directory?\n"));
  }

  var config = Config(
    platforms: platforms.map((e) => TargetPlatform(name: e)).toList()
  );

  String output = YAMLWriter().write(config.toMap());
  await File(path.join(p, "flutter-releaser.yaml")).writeAsString(output);
  logger.write("${logger.ansi.emphasized("flutter-releaser.yaml")} written.\n");
}


/**

bool verbose = args.contains('-v');
  Logger logger = verbose ? Logger.verbose() : Logger.standard();

  logger.stdout('Hello world!');
  logger.trace('message 1');
  await Future.delayed(Duration(milliseconds: 200));
  logger.trace('message 2');
  logger.trace('message 3');

  Progress progress = logger.progress("Doing some work...");
  await Future.delayed(Duration(seconds: 2));
  progress.finish(showTiming: false);

  logger.stdout('All ${logger.ansi.emphasized('done')}.');
 */