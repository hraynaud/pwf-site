app = angular.module("AttendanceSheet", ['ngRoute']);
app.config(function($httpProvider, $routeProvider) {
    $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
});

app.factory('EnrollmentFactory', ['$http', '$location', function ($http, $location) {
        return {
          getEnrollees: function(callback){
            $http({
              method: 'GET'
              , data: ''
              , url:  $location.absUrl()
              , headers: {
                'Content-Type': 'application/json'
              }
            })
            .success( callback );
          }
        };
      }]);

    app.controller('AttendanceController',  [ '$scope' , 
                       '$http', 
                       'EnrollmentFactory',
                       '$location',
                       '$routeParams',
                       '$route',
    function($scope, $http, EnrollmentFactory, $location, $routeParams, $route) {

      function init () {
        EnrollmentFactory.getEnrollees(function(results){
         $scope.students= results;
        })
       $scope.gro = [
    {name:'beginner foil', shade:'dark'},
    {name:'advanced foil', shade:'light'},
    {name:'red', shade:'dark'},
    {name:'blue', shade:'dark'},
    {name:'yellow', shade:'light'}
  ]; 


      }

     init();

    }]);