controllers = angular.module('controllers')
controllers.controller('EditTemplateController', ['$routeParams', '$scope',  'TemplatesService',
($routeParams, $scope, TemplatesService)->

	vt = this

	unbindFormWatch = $scope.$watch((()-> vt.tempForm), ()->
		if vt.tempForm
			
			TemplatesService.getTemplate($routeParams.templateId, vt.tempForm).then((res)->
				vt.template = res

				$scope.$watch('vt.template', ((newVal, oldVal)->
					if newVal.sections != oldVal.sections || newVal.fields != oldVal.fields
						console.log 'section or field changed'
						vt.tempForm.$pristine = false
					else
						return
				), true)
			)

			unbindFormWatch()
	)


	return vt

])