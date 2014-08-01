'use strict';

/* Controllers */

angular.module('Tasty.controllers',[])
    .controller('MapCtrl', ['$scope', 'Conf', 'TAPI', function($scope, Conf, TAPI) {
        $scope.lat = "0";
        $scope.lng = "0";
        $scope.accuracy = "0";
        $scope.error = "";
        $scope.model = { myMap: undefined };
        $scope.myMarkers = [];
        $scope.dataInitialized = false;
        $scope.immediateFailed = true;

        $scope.tasties = [];


        $scope.isSignedIn = false;

        $scope.signIn = function(authResult) {
            $scope.$apply(function() {
                $scope.processAuth(authResult);
            });
        };

        $scope.signedIn = function(profile) {
            $scope.isSignedIn = true;
            // data initialize

            TAPI.getTasties().then(function(response) {
                console.log("====== get tasties!");
                console.log(response.data);
                var tasties = response.data;
                for (var key in tasties) {
                    var item = t[key];
                    var latlng = new google.maps.LatLng(item.pos[0], item.pos[1]);
                    $scope.myMarkers.push(new google.maps.Marker({ map: $scope.model.myMap, position: latlng }));
                }
            });
        };

        $scope.renderSignIn = function() {
            gapi.signin.render('myGsignin', {
                'callback': $scope.signIn,
                'clientid': Conf.clientId,
                'requestvisibleactions': Conf.requestvisibleactions,
                'scope': Conf.scopes,
                // Remove the comment below if you have configured
                // appackagename in services.js
                //'apppackagename': Conf.apppackagename,
                'theme': 'dark',
                'cookiepolicy': Conf.cookiepolicy,
                'accesstype': 'offline'
            });
        };

        $scope.processAuth = function(authResult) {
            $scope.immediateFailed = true;
            if ($scope.isSignedIn) {
                return 0;
            }
            if (authResult['access_token']) {
                $scope.immediateFailed = false;
                // Successfully authorized, create session
//                TAPI.signIn(authResult).then(function(response) {
//                    $scope.signedIn(response.data);
//                });
                TAPI.signIn(authResult, function(isSuccess){
                    if (isSuccess) {
                        $scope.signedIn();
                    } else {
                        alert("login fail!");
                    }

                });
            } else if (authResult['error']) {
                if (authResult['error'] == 'immediate_failed') {
                    $scope.immediateFailed = true;
                } else {
                    console.log('Error:' + authResult['error']);
                }
            }
        };


        $scope.showResult = function () {
            return $scope.error == "";
        };

        $scope.mapOptions = {
            center: new google.maps.LatLng($scope.lat, $scope.lng),
            zoom: 15,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };

        $scope.showPosition = function (position) {
            console.log("show position");
            console.log($scope.model.myMap);
            $scope.lat = position.coords.latitude;
            $scope.lng = position.coords.longitude;
            $scope.accuracy = position.coords.accuracy;
            $scope.$apply();

            var latlng = new google.maps.LatLng($scope.lat, $scope.lng);
            $scope.model.myMap.setCenter(latlng);
            $scope.myMarkers.push(new google.maps.Marker({ map: $scope.model.myMap, position: latlng }));
        }

        $scope.showError = function (error) {
            switch (error.code) {
                case error.PERMISSION_DENIED:
                    $scope.error = "User denied the request for Geolocation."
                    break;
                case error.POSITION_UNAVAILABLE:
                    $scope.error = "Location information is unavailable."
                    break;
                case error.TIMEOUT:
                    $scope.error = "The request to get user location timed out."
                    break;
                case error.UNKNOWN_ERROR:
                    $scope.error = "An unknown error occurred."
                    break;
            }
            $scope.$apply();
        }

        $scope.getLocation = function () {

            if (navigator.geolocation) {
                console.log("get location");
                navigator.geolocation.getCurrentPosition($scope.showPosition, $scope.showError);

                console.log($scope.dataInitialized);
                if ($scope.dataInitialized == false) {
                    $scope.dataInitialized = true;
                    console.log("api call");

//                    tservice.auth( function (results) {
//                        console.log("------");
//                        console.log(results);
//                    });
                }
            }
            else {
                $scope.error = "Geolocation is not supported by this browser.";
            }
        }

        $scope.getLocation();
        console.log("controller initalize called");
    }])
    .controller('MyCtrl', ['$scope', function ($scope){

    }]);