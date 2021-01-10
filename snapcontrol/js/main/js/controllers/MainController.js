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
