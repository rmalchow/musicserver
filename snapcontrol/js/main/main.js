if (!String.prototype.includes) {
	String.prototype.includes = function(search, start) {
		if (typeof start !== 'number') {
			start = 0;
		}
		if (start + search.length > this.length) {
			return false;
		} else {
			return this.indexOf(search, start) !== -1;
		}
	};
}

if (!Array.prototype.includes) {
	Array.prototype.includes = function(search, start) {
		if (typeof start !== 'number') {
			start = 0;
		}
		if (start + search.length > this.length) {
			return false;
		} else {
			return this.indexOf(search, start) !== -1;
		}
	};
}

var app = angular.module("snapcontrol",	["templates","ngRoute" , "restangular" ]);

angular.module("snapcontrol").config(function($routeProvider) {
  $routeProvider
  .when("/main", {
    templateUrl : "main.html",
		controller: "MainController",
		controllerAs: "main"
  })
	.otherwise({
    redirectTo: '/main'
  });
});
