angular.module('teamwise').controller('AppDashboardCtrl', ($scope, Restangular, data) ->
  getAppData = () ->
    if data
      $scope.dashboard = data
    else
      $scope.dashboard = null

  init = () ->
    getAppData()

  init()
)
