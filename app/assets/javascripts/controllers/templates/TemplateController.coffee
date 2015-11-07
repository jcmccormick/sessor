controllers = angular.module('controllers')
controllers.controller('TemplateController', ['$routeParams', '$scope',  'TemplatesService',
($routeParams, $scope, TemplatesService)->

	vt = this

	vt.templates = TemplatesService.returnTemplates()

	$routeParams.templateId && TemplatesService.returnTemplate($routeParams.templateId).then((res)->
		vt.template = res
		vt.template.e = TemplatesService.editing()

		if vt.tempForm
			unbindSectionsWatch = $scope.$watch (()-> vt.template.sections), ((newVal, oldVal)-> newVal != oldVal && vt.tempForm.$pristine = false), true
			unbindFieldsWatch = $scope.$watch (()-> vt.template.fields), ((newVal, oldVal)-> newVal != oldVal && vt.tempForm.$pristine = false), true

			$scope.$on('$destroy', ()->
				unbindSectionsWatch()
				unbindFieldsWatch()
			)

	)

	unbindTempWatch = $scope.$watch (()-> vt.tempForm), ((newVal, oldVal)->
		if vt.tempForm
			vt.save = (temporary)-> TemplatesService.saveTemplate(temporary, vt.tempForm, vt.template)
			unbindTempWatch()
	)


	return vt

])