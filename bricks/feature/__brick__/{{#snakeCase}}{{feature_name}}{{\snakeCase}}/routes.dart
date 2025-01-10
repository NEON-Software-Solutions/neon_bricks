/// All the route paths for the {{feature_name}} feature.
class {{#pascalCase}}{{feature_name}}Router{{/pascalCase}} {
  /// The path for the {{feature_name}} overview route.
  static const String overview = '/{{feature_name}}-overview';
}

//TODO: make sure to add this route either in the NavBarItems or as a sub-route
// of another route.