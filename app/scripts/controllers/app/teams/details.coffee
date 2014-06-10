angular.module('teamwise').controller('AppTeamsDetailsCtrl', ($scope, $stateParams, Restangular, data) ->
  getAppData = () ->
    if $stateParams.id
      $scope.team = data
    else
      $scope.team = null
      return

  init = () ->
    getAppData()

  init()
)
