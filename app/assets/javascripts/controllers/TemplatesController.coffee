controllers = angular.module('controllers')
controllers.controller('TemplatesController', ['$routeParams', '$scope', 'ReportsService', 'TemplatesService',
($routeParams, $scope, ReportsService, TemplatesService)->

	setupTemp = ->
		if vt.template.e = TemplatesService.editing()
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
	vt.sortType = 'updated_at'
	vt.sortReverse = true
	vt.currentPage = 0
	vt.pageSize = 10
	vt.numPages = ->
		return Math.ceil(vt.templates.length/vt.pageSize)
	vt.newReport = (template)->
		ReportsService.addTemplate(template)

	if tempId = parseInt($routeParams.templateId, 10)
		exists = ($.grep vt.templates, (temp)-> temp.id == tempId)[0]

		(!exists || (exists && !exists.sections)) && TemplatesService.queryTemplate(tempId).then((res)->
			vt.template = TemplatesService.getTemplate(tempId)
			setupTemp()
		)

		exists && exists.sections && exists.sections.length && vt.template = TemplatesService.getTemplate(tempId)
		
		vt.template && setupTemp()
	else
		vt.template = TemplatesService.getTemplate()

	unbindFormWatch = $scope.$watch (()-> vt.tempForm), ((newVal, oldVal)->
		if vt.tempForm
			vt.save = (temporary)-> TemplatesService.saveTemplate(temporary, vt.tempForm)
			$scope.$on('$locationChangeStart', (event)->
				vt.template.id && !vt.tempForm.$pristine && !confirm('There are unsaved changes. Press cancel to return to the form.') && event.preventDefault()
			)
			unbindFormWatch()
	)



	return vt

])