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
