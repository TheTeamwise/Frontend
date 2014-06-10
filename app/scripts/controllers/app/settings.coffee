angular.module('teamwise').controller('AppSettingsCtrl', ($scope, $http, Restangular) ->
  app = Restangular.one("apps", 1)

  getAppData = () ->
    app.get().then((app) ->
      $scope.app = app[1]
      return
    )

  init = () ->
    getAppData()

  init()
)
