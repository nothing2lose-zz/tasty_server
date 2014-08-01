'use strict';


// Declare app level module which depends on filters, and services
angular.module('Tasty', [
  'ngRoute',
//  'ngResource',
  'Tasty.filters',
  'Tasty.services',
  'Tasty.directives',
  'Tasty.controllers',
  'ui.map',
//  'TastyService'
//  'prettifyDirective',
//  'ui.bootstrap'
//  'plunker'

]).
//config(['$routeProvider', '$resourceProvider', function($routeProvider, $resourceProvider) {

config(['$routeProvider', function($routeProvider) {
//    $resourceProvider.defaults.stripTrailingSlashes = false;
  $routeProvider.when('/view1', {templateUrl: 'partials/partial1.html', controller: 'MapCtrl' });
  $routeProvider.when('/view2', {templateUrl: 'partials/partial2.html', controller: 'MyCtrl' });
  $routeProvider.otherwise({redirectTo: '/view1'});
}]);
