(function() {
  Teaspoon.Jasmine1.Suite = (function() {
    function Suite(suite) {
      this.suite = suite;
      this.fullDescription = this.suite.getFullName();
      this.description = this.suite.description;
      this.link = "?grep=" + (encodeURIComponent(this.fullDescription));
      this.parent = this.suite.parentSuite;
      this.viewId = this.suite.viewId;
    }

    return Suite;

  })();

}).call(this);
