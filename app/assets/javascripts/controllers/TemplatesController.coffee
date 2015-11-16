controllers = angular.module('controllers')
controllers.controller('TemplatesController', ['$routeParams', '$scope', 'ReportsService', 'TemplatesService',
($routeParams, $scope, ReportsService, TemplatesService)->

	vt = this

	vt.templates = TemplatesService.getTemplates()

	if TemplatesService.creating() || tempId = parseInt($routeParams.templateId, 10)
		vt.template = TemplatesService.extendTemplate(tempId)

		tempId && !vt.template.loadedFromDB && TemplatesService.queryTemplate(tempId, true).then((res)->
			$.extend vt.template, res
		)

		vt.save = (temporary)->
			TemplatesService.saveTemplate(vt.template, temporary, vt.tempForm)

		if vt.template.e = TemplatesService.editing()

			$(document).bind 'keydown', (e)->
				if e.ctrlKey && (e.which == 83)
					e.preventDefault()
					vt.save(true)
					return false

			$scope.$on('$locationChangeStart', (event)->
				(!vt.tempForm.$pristine && (!confirm('There are unsaved changes. Press cancel to return to the form.') && event.preventDefault() ) || vt.template.e = false ) || vt.template.e = false
			)

			vt.template.addSection = ->
				TemplatesService.addSection(vt.template)

			vt.template.addSectionColumn = (section)->
				TemplatesService.addSectionColumn(section)

			vt.template.deleteSectionColumn = (section)->
				TemplatesService.deleteSectionColumn(vt.template, section)

			vt.template.deleteSection = (section)->
				TemplatesService.deleteSection(vt.template, section.i)
				vt.save(true)

			vt.template.moveSection = (index, new_index)->
				TemplatesService.moveSection(vt.template, index, new_index)

			vt.template.addField = (section_id, column_id, type)->
				TemplatesService.addField(vt.template, section_id, column_id, type)

			vt.template.deleteField = (field)->
				TemplatesService.deleteField(vt.template, field)

			vt.template.changeFieldSection = (field, prev_section)->
				TemplatesService.changeFieldSection(vt.template, field, prev_section)

			vt.template.changeFieldColumn = (field, column_id)->
				TemplatesService.changeFieldColumn(vt.template, field, column_id)

			vt.template.moveField = (field, direction)->
				TemplatesService.moveField(vt.template, field, direction)

			vt.template.addOption = (field)->
				TemplatesService.addOption(field)

			vt.template.deleteOption = (field, option)->
				TemplatesService.deleteOption(field, option)

			vt.template.supportedFields = TemplatesService.supportedFields
			vt.template.addFieldTypes = TemplatesService.addFieldTypes

			unbindSectionsWatch = $scope.$watch (()-> vt.template.sections), ((newVal, oldVal)-> newVal != oldVal && vt.tempForm.$pristine = false), true
			unbindFieldsWatch = $scope.$watch (()-> vt.template.fields), ((newVal, oldVal)-> newVal != oldVal && vt.tempForm.$pristine = false), true
			unbindDraftWatch = $scope.$watch (()-> vt.template.draft), ((newVal, oldVal)-> newVal != oldVal && vt.tempForm.$pristine = false)

			$scope.$on('$destroy', ()->
				unbindSectionsWatch()
				unbindFieldsWatch()
				unbindDraftWatch()
			)
	else
		vt.sortType = 'updated_at'
		vt.sortReverse = true
		vt.currentPage = 0
		vt.pageSize = 10

		vt.numPages = ->
			Math.ceil(vt.filteredList.length/vt.pageSize)

		vt.newReport = (template, form)->
			report = ReportsService.extendReport()
			report.template_order.push template.id
			ReportsService.addTemplate(report, form)

		vt.setDraft = (id)->
			template = TemplatesService.extendTemplate(id)
			template.settingDraft = true
			TemplatesService.saveTemplate(template, true, vt.tempForm)

	vt.delete = (template)->
		TemplatesService.deleteTemplate(template)

	return vt

])