controllers = angular.module('controllers')
controllers.controller('TemplatesController', ['$routeParams', '$scope', 'ReportsService', 'TemplatesService',
($routeParams, $scope, ReportsService, TemplatesService)->

	vt = this

	vt.templates = TemplatesService.listTemplates()
	vt.sortType = 'updated_at'
	vt.sortReverse = true
	vt.currentPage = 0
	vt.pageSize = 10
	vt.newReport = (template, form)->
		ReportsService.addTemplate(template, form)
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
			$scope.$on('$locationChangeStart', (event)->
				vt.template.id && !vt.tempForm.$pristine && !confirm('There are unsaved changes. Press cancel to return to the form.') && event.preventDefault()
			)
			vt.save = (temporary)-> TemplatesService.saveTemplate(temporary, vt.tempForm)
			vt.delete = (id)->
				TemplatesService.getTemplate(id)
				TemplatesService.deleteTemplate(vt.tempForm)
			vt.setDraft = (id)->
				TemplatesService.getTemplate(id).settingDraft = true
				TemplatesService.saveTemplate(true, vt.tempForm)
			unbindFormWatch()
	)

	unbindListWatch = $scope.$watch (()-> vt.filteredList), ((newVal, oldVal)->
		if vt.filteredList
			vt.numPages = ->
				Math.ceil(vt.filteredList.length/vt.pageSize)

			unbindListWatch()
	)


	return vt

])