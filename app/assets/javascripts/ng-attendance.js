app = angular.module("PWFApp", ['ngRoute']);
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
     $scope.students= results[0];
     $scope.groups= results[1];
   // console.log("Groups: " + JSON.stringify($scope.groups));
   // console.log("Student: " + JSON.stringify($scope.students));
   });
  }


$scope.search = {};
// $scope.search.groupId = ;

$scope.tellMe  = function($event){
  console.log($scope.search.groupId)
  console.log($scope.search)
  console.log($event)
}
  $scope.toggleAttendance = function(student){

   console.log("Student: " + JSON.stringify(student));
   student.attended = !student.attended;

   $http({
    method: "PUT",
    url: "/attendances/" + student.attendanceId,
    data: student,
    withCredentials: false
  })
   .success(function(){
    console.log("!!!!SUCCESS");
  })
   .error(function(){
   });

}

  init();

}]);

