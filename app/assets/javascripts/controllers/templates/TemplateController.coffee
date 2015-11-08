controllers = angular.module('controllers')
controllers.controller('TemplateController', ['$routeParams', '$scope',  'TemplatesService',
($routeParams, $scope, TemplatesService)->

	setupTemp = ->
		vt.template.e = TemplatesService.editing()

		if vt.template.e
			unbindSectionsWatch = $scope.$watch (()-> vt.template.sections), ((newVal, oldVal)-> newVal != oldVal && vt.tempForm.$pristine = false), true
			unbindFieldsWatch = $scope.$watch (()-> vt.template.fields), ((newVal, oldVal)-> newVal != oldVal && vt.tempForm.$pristine = false), true
			unbindDraftWatch = $scope.$watch (()-> vt.template.draft), ((newVal, oldVal)-> newVal != oldVal && vt.tempForm.$pristine = false)

			$scope.$on('$destroy', ()->
				unbindSectionsWatch()
				unbindFieldsWatch()
				unbindDraftWatch()
			)

	vt = this

	vt.templates = TemplatesService.listTemplates()

	if tempId = parseInt($routeParams.templateId, 10)
		exists = ($.grep vt.templates, (temp)-> temp.id == tempId)[0]

		!exists && TemplatesService.queryTemplate(tempId).then(->
			vt.template = TemplatesService.getTemplate(tempId)
			setupTemp()
		)

		exists && vt.template = TemplatesService.getTemplate(tempId)
		
		vt.template && setupTemp()
	else
		vt.template = TemplatesService.getTemplate()

	unbindFormWatch = $scope.$watch (()-> vt.tempForm), ((newVal, oldVal)->
		if vt.tempForm
			vt.save = (temporary)-> TemplatesService.saveTemplate(temporary, vt.tempForm)
			unbindFormWatch()
	)


	return vt

])