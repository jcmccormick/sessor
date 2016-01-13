do ->
    'use strict'

    TemplatesController = ($routeParams, $scope, $window, localStorageService, ReportsService, TemplatesService)->

        vt = this

        vt.templates = localStorageService.get('_cst')

        if TemplatesService.creating() || tempId = parseInt($routeParams.templateId, 10)
            vt.template = if tempId
                TemplatesService.extendTemplate(tempId)
            else
                {name: '', sections: [], fields: []}

            tempId && !vt.template.loadedFromDB && TemplatesService.queryTemplate(tempId, true).then((res)->
                $.extend vt.template, res
            )

            vt.template.viewing = true

            vt.save = (temporary)->
                TemplatesService.saveTemplate(vt.template, temporary, vt.tempForm)

            if vt.template.e = TemplatesService.editing()

                vt.template.sO = undefined

                $(document).bind 'keydown', (e)->
                    if vt.template && e.ctrlKey && (e.which == 83)
                        e.preventDefault()
                        vt.save(true)
                        return false

                $scope.$on('$locationChangeStart', (e)->
                    if !vt.tempForm.$pristine && !confirm('There are unsaved changes. Press cancel to return to the form.')
                        e.preventDefault()
                    else
                        vt.template = undefined
                )

                vt.template.addSection = ->
                    TemplatesService.addSection(vt.template)

                vt.template.addSectionColumn = (section)->
                    TemplatesService.addSectionColumn(section)

                vt.template.deleteSectionColumn = (section)->
                    TemplatesService.deleteSectionColumn(vt.template, section)

                vt.template.deleteSection = (ev, section)->
                    TemplatesService.deleteSection(ev, vt.template, section.i).then ->
                        vt.tempForm.$pristine = false
                        vt.template.deletingSection = true
                        vt.save(true)

                vt.template.moveSection = (index, new_index)->
                    TemplatesService.moveSection(vt.template, index, new_index)

                vt.template.addField = (section_id, column_id, type)->
                    TemplatesService.addField(vt.template, section_id, column_id, type).then ->
                        vt.template.update_keys = true
                        vt.save(true)

                vt.template.deleteField = (ev, field)->
                    TemplatesService.deleteField(ev, vt.template, field)

                vt.template.changeFieldSection = (field, prev_section)->
                    TemplatesService.changeFieldSection(vt.template, field, prev_section)

                vt.template.changeFieldColumn = (field, column_id)->
                    TemplatesService.changeFieldColumn(vt.template, field, column_id)

                vt.template.moveField = (field, direction)->
                    TemplatesService.moveField(vt.template, field, direction)

                vt.template.addOption = (field)->
                    TemplatesService.addOption(field)

                vt.template.deleteOption = (ev, field, option)->
                    TemplatesService.deleteOption(ev, field, option)

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
            # Options for sorting in the sortable views
            vt.viewStyle = 'sortable'
            vt.sortType = 'updated_at'
            vt.sortReverse = true
            vt.currentPage = 0
            vt.pageSize = 5
            vt.numPages = ->
                Math.ceil(vt.filteredList.length/vt.pageSize)

            vt.newReport = (template, form)->
                if template.draft
                    TemplatesService.undraftFirst()
                else
                    report = ReportsService.extendReport()
                    report.template_order.push template.id
                    ReportsService.saveReport(report, true, form)

            vt.setDraft = (template)->
                vt.tempForm.$pristine = false
                TemplatesService.saveTemplate(template, true, vt.tempForm)

        vt.delete = (ev, template)->
            TemplatesService.deleteTemplate(ev, template).then ->
                vt.templates = localStorageService.get('_cst')

        vt.view_sheet = (ev, template)->
            TemplatesService.viewGoogleSheet(ev, template)

        return vt

    TemplatesController.$inject = ['$routeParams', '$scope', '$window', 'localStorageService', 'ReportsService', 'TemplatesService']

    angular.module('clerkr').controller('TemplatesController', TemplatesController)