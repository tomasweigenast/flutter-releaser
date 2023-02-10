const kDefaultConfig = {
  ""
};

class Config {
  final List<TargetPlatform> platforms;

  Config({required this.platforms});

  Map toMap() {
    var out = <String, dynamic>{
      "platforms": {}
    };

    for(var platform in platforms) {
      out["platforms"][platform.name] = platform.toMap();
    }


    return out;
  }
}

class TargetPlatform {
  final String name;
  final bool enabled;

  TargetPlatform({required this.name, this.enabled = true});

  Map toMap() => {
    "enabled": enabled
  };
}