directives = angular.module('directives')
directives.directive('loading', [()->
	{
		template: '<div ng-if="lv.loading"><span>Processing... <i class="glyphicon glyphicon-refresh"></i></span></div>'
		scope: false
		controllerAs: 'lv'
		controller: ['$rootScope', ($rootScope)->

			lv = this

			$rootScope.$on('loading:finish', ->
				lv.loading = false
			)

			$rootScope.$on('loading:progress', ->
				lv.loading = true
			)

			return lv
			
		]
	}
])