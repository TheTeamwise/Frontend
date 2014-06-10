'use strict'

app = angular.module('teamwise', [
  'angular-loading-bar',
  'ngAnimate',
  'ngTable',
  'ui.router',
  'ui.bootstrap.transition',
  'ui.bootstrap.dropdown',
  'ui.bootstrap.collapse',
  'restangular'
])

app.config ($stateProvider, $urlRouterProvider, $locationProvider, RestangularProvider, cfpLoadingBarProvider) ->
  # $locationProvider.html5Mode true
  RestangularProvider.setBaseUrl "http://teamwise.apiary-mock.com/v1/"

  cfpLoadingBarProvider.latencyThreshold = 50
  cfpLoadingBarProvider.includeSpinner = false

  $urlRouterProvider.otherwise "/"

  $stateProvider.state("landing",
    url: "/"
    views:
      viewMain:
        templateUrl: "views/landing.html"

  ).state("features",
    url: "features"
    templateUrl: "views/landing/features.html"

  ).state("app",
    url: "/app"
    resolve:
      data: ($q, $stateParams, Restangular) ->
        api = Restangular.one('teams')
        deferred = $q.defer()

        api.get().then((data) ->
          deferred.resolve data
          return
        )

        deferred.promise
    views:
      viewMain:
        templateUrl: "views/app.html"
        controller: "AppDashboardCtrl"
      "viewNav@app":
        templateUrl: "views/app/nav.html"

  ).state("app.team",
    url: "/team/:id"
    resolve:
      data: ($q, $stateParams, Restangular) ->
        api = Restangular.one('teams', $stateParams.id)
        deferred = $q.defer()

        api.get().then((team) ->
          deferred.resolve team
          return
        )

        deferred.promise
    views:
      "viewDash@app":
        templateUrl: "views/app/teams/details.html"
        controller: "AppTeamsDetailsCtrl"
      "viewNav@app":
        templateUrl: "views/app/teams/team_nav.html"

  ).state("app.project",
    url: "/projects"
    views:
      "viewDash@app":
        templateUrl: "views/app/project/list.html"
        controller: "AppProjectDetailsCtrl"
      "viewNav@app":
        templateUrl: "views/app/project/list_nav.html"

  ).state("app.project.details",
    url: "/view"
    views:
      "viewDash@app":
        templateUrl: "views/app/project/details.html"
        controller: "AppProjectDetailsCtrl"
      "viewNav@app":
        templateUrl: "views/app/project/details_nav.html"

  ).state("app.project.tasks",
    url: "/tasks"
    views:
      "viewDash@app":
        templateUrl: "views/app/project/task_list.html"
        controller: "AppProjectTasksListCtrl"
      "viewNav@app":
        templateUrl: "views/app/project/task_list_nav.html"

  ).state("app.settings",
    url: "/settings"
    templateUrl: "views/app/settings.html"
    controller: "AppSettingsCtrl"
  )
