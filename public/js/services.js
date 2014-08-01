'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
//angular.module('Tasty.services', []).
//  value('version', '0.1');

angular.module('Tasty.services', []).
    value('version', '0.1').
    factory('Conf', function($location) {
        function getRootUrl() {
            var rootUrl = $location.protocol() + '://' + $location.host();
            if ($location.port())
                rootUrl += ':' + $location.port();
            return rootUrl;
        };
        return {
            'clientId': '971111660674-o9mgol0es3ke0552jun3rr47h36npepa.apps.googleusercontent.com',
            'apiBase': '1/',
            'rootUrl': getRootUrl(),
            'scopes': 'https://www.googleapis.com/auth/plus.login',
            'requestvisibleactions': 'http://schemas.google.com/AddActivity ' +
                'http://schemas.google.com/ReviewActivity',
            'cookiepolicy': 'single_host_origin'
            // If you have an android application and you want to enable
            // Over-The-Air install, remove the comment below and use the package
            // name associated to the project's Client Id for installed applications
            // in the Google API Console.
            //'apppackagename': 'YOUR_APP_PACKAGE'
        };
    }).
    factory('TAPI', ['$http', '$q', 'Conf', function($http, $q, Conf) {
        var deffered = $q.defer();
        var param = {}
        var data = [];
        var tapi = {};
        console.log("====== TAPI initial call");
        tapi.async = function() {
            console.log("------ TAPI initalize");
            $http.post('/1/login', param)
                .success(function (d) {
                    data = d;
                    console.log(d);
                    deffered.resolve();
                });
            return deffered.promise;
        };

        tapi.signIn = function(authResult, cb) {

            gapi.auth.setToken(authResult);
            function userInfoCallback(obj) {
                console.log(obj);
                var params = { social_id: obj.id, name: obj.name, social_type: "google", device_type: "web"};
                $http.post(Conf.apiBase + 'login', params).
                success(function(data, status, headers, config) {
                    console.log("[Tasty][API]login success");
                    console.log(data);
                    cb(true);
                }).
                error(function(data, status, headers, config) {
                    console.log("[Tasty][API]login fail");
                    console.log(data);
                    cb(false);
                });
            }
            gapi.client.load('oauth2', 'v2', function() {
                var request = gapi.client.oauth2.userinfo.get();
                request.execute(userInfoCallback);
            });

            return undefined;
        };

        tapi.getTasties = function() {
            return $http.get(Conf.apiBase + 'tasties');
        }
        return tapi;
    }]);