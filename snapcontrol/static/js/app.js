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

app = angular.module("snapcontrol");


app.controller(
	"MainController",
	[ '$interval', '$location', 'ZeroConfService', function($interval,$location,ZeroConfService) {

		var main = this;

		console.log($location)

		main.update = function() {

			main.local = {};

			ZeroConfService.getMopidies(function(servers) {
				main.servers = servers;
			});
			ZeroConfService.getSnapclients(function(clients) {
				_.each(clients, function(client) {
					if ($location["$$host"] == client.ip) {
						client.active = true;
						main.local = client;
					}
					ZeroConfService.connect(function(connectedTo) {
						client.connectedTo = connectedTo;
					},client.ip,undefined);
				})
				main.clients = clients;
			});
		}

		main.openIris = function(server) {
			main.iris = window.open("http://"+server.ip+":6680/iris/","iris");
		}

		main.connect = function(client,server) {
			ZeroConfService.connect(
				function(res) {
					main.update();
				},
				client,
				server
			)
		}


		$interval(main.update,10000);

		main.update();

	}]

);

angular.module("snapcontrol").service(
  "ZeroConfService",
	['$interval',"Restangular",function($interval,Restangular) {

    s = {};

    s.getSnapclients = function(success) {
      Restangular.all("snapservers").getList().then(success);
    }

    s.getMopidies = function(success) {
      Restangular.all("mopidies").getList().then(success);
    }

    s.connect = function(success,client,server) {
      Restangular.one("client/connect").get({client:client, server:server}).then(success);
    }


    return s;
	}]
);
