app = angular.module("PWFApp", ['ngRoute']);
app.config(['$httpProvider', '$routeProvider', function($httpProvider, $routeProvider) {
  $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
} ]);

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
    },

    updateStudentResource: function(resourceRoute, resourceId, student){

     $http({
      method: "PUT",
      url: "/"+ resourceRoute + "/" + resourceId,
      data: student
    })
     .success(function(){
      console.log("!!!!SUCCESS");
    })
     .error(function(){
     });
   }

 };
}]);

app.controller('FencingAttendanceController',  [ '$scope' , 
 '$http', 
 'EnrollmentFactory',
 function($scope, $http, EnrollmentFactory) {

  function init () {
    EnrollmentFactory.getEnrollees(function(results){
     $scope.students= results[0];
     $scope.groups= results[1];
     $scope.search = {};
     $scope.search.showGroups=false
     console.log($scope.search.groupId)
   });
  }

  init();

  $scope.shortName = function(name){
    var code = "";
    name.split(" ").forEach(function(i){
      code +=i.substr(0,1);
    })
    return code ;
  }

  $scope.checkGroupFilter = function(){
   if($scope.search.groupId === null){
    $scope.search = {};
  }
}

$scope.isUnassigned = function(student){
  return student.groupId ==-1 || $scope.search.showGroups;
}

$scope.assignGroup = function(student){
  EnrollmentFactory.updateStudentResource("student_registrations", student.studentId, student)
}

$scope.toggleAttendance = function(student){
 student.attended = !student.attended;
 EnrollmentFactory.updateStudentResource("attendances", student.attendanceId, student)
}

}]);



app.controller('AepAttendanceController',  [ '$scope' , 
 '$http', 
 'EnrollmentFactory',
 function($scope, $http, EnrollmentFactory) {

  function init () {
    EnrollmentFactory.getEnrollees(function(results){
     $scope.students= results[0];
     $scope.search = {};
   });
  }

  init(); 
}]);
