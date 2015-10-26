controllers = angular.module('controllers')
controllers.controller('EditTemplateController', ['$routeParams', '$scope',  'TemplatesService',
($routeParams, $scope, TemplatesService)->

	vt = this

	unbindFormWatch = $scope.$watch((()-> vt.tempForm), ()->
		if vt.tempForm
			if $routeParams.templateId
				TemplatesService.getTemplate($routeParams.templateId, vt.tempForm).then((res)->
					vt.template = res
				)
			else
				vt.template = TemplatesService.newTemplate()

			unbindFormWatch()
	)
	
	return vt

])