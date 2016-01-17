do ->
    'use strict'

    ReportsController = ($routeParams, $scope, localStorageService, ReportsService, TemplatesService)->

        vr = this

        vr.reports = localStorageService.get('_csr')

        if ReportsService.creating() || repId = parseInt($routeParams.reportId, 10)
            vr.templates = localStorageService.get('_cst')
            vr.report = ReportsService.extendReport(repId)

            for template in vr.report.templates
                if vr.report.loadedFromDB
                    fields_values = $.map(template.fields, (x)-> x.value)
                    (!template.sections || (fields_values && template.fields.length != fields_values.length) ) && reload = true


            repId && (!vr.report.loadedFromDB || reload) && ReportsService.queryReport(repId, true).then((res)->
                $.extend vr.report, res
                vr.report.form = vr.report.templates[0]
            )

            vr.report.form = vr.report.templates[0]

            vr.addTemplate = (template)->
                vr.repForm.$pristine = false

                # Save the report with a new template
                vr.report.template_order.push template.id
                ReportsService.saveReport(vr.report, true, vr.repForm).then ((res)->

                    # If new report, query to collect the full contents of the newly added template
                    !vr.report.id && ReportsService.queryReport(repId, true).then((res)->
                        $.extend vr.report, res
                        vr.report.form = vr.report.templates[vr.report.templates.length-1]
                        vr.template = vr.filteredTemplates()[0]
                    )
                ), (err)->
                    vr.report.template_order.pop()

            vr.filteredTemplates = ->
                vr.templates.filter((template)->
                    !template.draft && vr.report.template_order.indexOf(template.id) == -1
                )

            vr.template = vr.filteredTemplates()[0]
                    
            vr.switchForm = (dir)->
                index = $.map(vr.report.templates, (x)-> x.id).indexOf(vr.report.form.id)
                vr.report.form = vr.report.templates[index+dir]

            if vr.report.e = ReportsService.editing()

                vr && $(document).bind 'keydown', (e)->
                    if e.ctrlKey && (e.which == 83)
                        e.preventDefault()
                        vr.save(true)
                        return false

                $scope.$on('$locationChangeStart', (event)->
                    if !vr.repForm.$pristine && !confirm('There are unsaved changes. Press cancel to return to the form.')
                        event.preventDefault()
                    else
                        vr.report = undefined

                )

                vr.save = (temporary)->
                    ReportsService.saveReport(vr.report, temporary, vr.repForm)

                vr.deleteTemplate = (ev)->
                    ReportsService.deleteTemplate(ev, vr.report).then ->
                        vr.repForm.$pristine = false
                        vr.save(true).then (res)->
                            vr.report.did = undefined
                            vr.template = vr.filteredTemplates()[0]
                            vr.report.form = vr.report.templates[0]
        else
            vr.viewStyle = 'sortable'
            vr.sortType = 'updated_at'
            vr.sortReverse = true
            vr.currentPage = 0
            vr.pageSize = 5
            vr.numPages = ->
                Math.ceil(vr.filteredList.length/vr.pageSize)

        vr.delete = (ev, report)->
            ReportsService.deleteReport(ev, report).then ->
                vr.reports = localStorageService.get('_csr')

        return vr

    ReportsController.$inject = ['$routeParams', '$scope', 'localStorageService', 'ReportsService', 'TemplatesService']

    angular.module('clerkr').controller("ReportsController", ReportsController)