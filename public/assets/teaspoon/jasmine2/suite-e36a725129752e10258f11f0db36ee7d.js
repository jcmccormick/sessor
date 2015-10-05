(function() {
  Teaspoon.Jasmine2.Suite = (function() {
    function Suite(suite) {
      this.suite = suite;
      this.fullDescription = this.suite.fullName;
      this.description = this.suite.description;
      this.link = "?grep=" + (encodeURIComponent(this.fullDescription));
      this.parent = this.suite.parent;
      this.viewId = this.suite.id;
    }

    return Suite;

  })();

}).call(this);
