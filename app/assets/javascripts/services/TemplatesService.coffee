do ->
    'use strict'

    TemplatesService = ($interval, $location, $mdDialog, $q, $rootScope, $window, ClassFactory, Flash, localStorageService)->

        templates = localStorageService.get('_cst')

        slt = (temps)->
            localStorageService.set('_cst', temps)
            
        geti = (id)->
            temps = localStorageService.get('_cst')
            $.map(temps, (x)-> x.id).indexOf(id)

        validateTemplate = (template)->
            template.errors = ''

            !template.name && template.errors += '<p>Pages must have a name.</p>'

            if template.fields && template.fields.length && template.fields_attributes = angular.copy template.fields
                # fields marked destroy are removed locally, as they will
                # be removed when saving template; the following makes sure
                # any deleted fields will be removed from the client's 
                # template model
                i = template.fields.length
                while i--
                    delete template.fields[i].value
                    template.fields[i]._destroy && template.fields.splice(i, 1)

                for field in template.fields_attributes
                    delete field.value

                uniqueNames = []
                $.each ($.map template.fields, (x)-> x.o.name), (i, name)->
                    if ($.inArray(name, uniqueNames) == -1) then uniqueNames.push name
                uniqueNames.length != template.fields_attributes.length && template.errors += '<p>Fields must have unique names.</p>'

                # validate field name or placeholder presence
                !template.deletingSection && $.grep(template.fields_attributes, (field)->
                    (field.fieldtype != 'labelntext' && !field.o.name) || (field.fieldtype == 'labelntext' && (!field.o.name && !field.o.default_value))
                ).length && template.errors += '<p>Fields must have a name.</p><p>Label and text elements must have a label <strong>or</strong> text.</p>'

            delete template.deletingSection
            delete template.settingDraft
            !template.$update && $.extend template, new ClassFactory()
            return template

        newFieldOrdering = (template, section_id, column_id)->
            !template.fields && template.fields = []
            return ($.grep template.fields, (tempField)-> section_id == parseInt(tempField.o.section_id, 10) && column_id == tempField.o.column_id).length+1

        {
            editing: ->
                return if $location.path().search('/edit') == -1 then false else true

            creating: ->
                return if $location.path().search('/new') == -1 then false else true

            viewGoogleSheet: (ev, template)->
                confirm = $mdDialog.confirm()
                    .title('Click OK to view the Google Spreadsheet for '+template.name)
                    .content('Important! Any changes you make on the Google Spreadsheet will not be reflected on Clerkr. Do not make attempts to modify the Google Spreadsheet. Instead, export it locally to your computer, or make a copy on Google Drive for your own uses. By clicking OK, you understand that modifying the original spreadsheet may cause it to stop working with Clerkr.')
                    .targetEvent(ev)
                    .ok('OK')
                    .cancel('Get me out of here!')
                $mdDialog.show(confirm).then(()->
                    $window.open(template.gs_url, template.name)
                    return true
                )

            getTemplates: ->
                return templates

            listTemplates: ->
                deferred = $q.defer()
                ClassFactory.query({class: 'templates'}, (res)->
                    slt(res)
                    deferred.resolve(res)
                )
                return deferred.promise

            queryTemplate: (id, refreshing)->
                templates = localStorageService.get('_cst')
                deferred = $q.defer()
                id = parseInt(id, 10)
                if templates[geti(id)] && (!templates[geti(id)].loadedFromDB || refreshing)
                    ClassFactory.get({class: 'templates', id: id}, (res)->
                        res.loadedFromDB = true
                        templates[geti(id)] = res
                        slt(templates)
                        deferred.resolve(templates[geti(id)])
                    )
                else if templates[geti(id)]
                    deferred.resolve(templates[geti(id)])
                else
                    $location.path('/')
                    Flash.create('danger', '<h3>Error! <small>Page</small></h3><p>Could not process request.</p>', 'customAlert')
                return deferred.promise

            extendTemplate: (id)->
                templates = localStorageService.get('_cst')
                template = $.extend templates[geti(id)], new ClassFactory()
                return template

            # save/update template
            saveTemplate: (template, temporary, form)->
                templates = localStorageService.get('_cst')
                ts = this

                # Validate and save
                validateTemplate(template)
                if !!template.errors
                    Flash.create('danger', '<h3>Error! <small>Page</small></h3>'+template.errors, 'customAlert')
                    template.errors = ''
                    return
                
                if !template.id
                    template.$save({class: 'templates'}, (res)->
                        templates.push res
                        slt(templates)
                        $location.path("/templates/#{res.id}/edit")
                        return
                    )
                else
                    # template.e && !template.timedSave && template.timedSave = $interval (->
                    #   !form.$pristine && ts.saveTemplate(template, true, form)
                    #   console.log template
                    # ), 30000
                    # template.e && !template.dereg && template.dereg = $rootScope.$on('$locationChangeSuccess', ->
                    #   $interval.cancel(template.timedSave)
                    #   template.timedSave = undefined
                    #   template.dereg()
                    # )
                    if !form.$pristine
                        template.updated_at = moment().local().format()
                        templates[geti(template.id)] = template
                        slt(templates)

                        reports = localStorageService.get('_csr')
                        newtemp = $.map(($.grep reports, (report)-> report.template_order.indexOf(template.id) != -1), (x)-> x.id)
                        for id in newtemp
                            report = $.map(reports, (x)-> x.id).indexOf(id)
                            templ = $.map(reports[report].templates, (x)-> x.id).indexOf(template.id)
                            reports[report].templates[templ] = templates[geti(template.id)]
                        localStorageService.set('_csr', reports)

                        template.$update({class: 'templates', id: template.id}, (res)->
                            delete template.update_keys
                            form.$setPristine()
                            !temporary && $location.path("/templates/#{template.id}")
                        )
                    else
                        !temporary && $location.path("/templates/#{template.id}")

                return

            # delete template
            deleteTemplate: (ev, template)->
                confirm = $mdDialog.confirm()
                    .title('Are you sure you want to delete this page?')
                    .content('Pressing DELETE will permanently remove '+template.name+', if it is not connected to any reports.')
                    .targetEvent(ev)
                    .ok('DELETE')
                    .cancel('Get me out of here!')
                $mdDialog.show(confirm).then ->
                    $.extend template, new ClassFactory()
                    template.$delete({class: 'templates', id: template.id}, ((res)->
                        templates.splice(geti(template.id), 1)
                        slt(templates)
                        $location.path("/")
                    ), (err)->
                        Flash.create('danger', '<h3>Error! <small>Page</small></h3><p>'+err.data.errors+'</p>', 'customAlert')
                    )

            # add section
            addSection: (template)->
                index = template.sections.push({
                    i: template.sections.length+1
                    n: ''
                    c: 1
                })
                template.sO = template.sections[index-1]
                template.newSectionName = undefined
                return

            # add section column
            addSectionColumn: (section)->
                if section.c < 3
                    section.c++
                return

            # delete section column
            deleteSectionColumn: (template, section)->
                if section.c > 1
                    for field in template.fields
                        parseInt(field.o.section_id, 10) == section.i && field.o.column_id == section.c && prevent = true
                    if prevent 
                        Flash.create('danger', '<h3>Error! <small>Column</small></h3><p>Please move any fields out of the last column.</p>', 'customAlert')
                    else
                        section.c--
                return

            # delete section
            deleteSection: (ev, template, section_id)->
                confirm = $mdDialog.confirm()
                    .title('Are you sure you want to remove this section from the page?')
                    .content('The section\'s columns and fields will also be removed and this is not reversible.')
                    .targetEvent(ev)
                    .ok('DELETE')
                    .cancel('Get me out of here!')
                $mdDialog.show(confirm).then ->
                    template.sO = undefined
                    mapped_section_ids = $.map template.sections, (x)-> x.i
                    sect_index = mapped_section_ids.indexOf(section_id)
                    for field in template.fields
                        field_sect_index = mapped_section_ids.indexOf(field.o.section_id)
                        (field_sect_index > sect_index && field.o.section_id--) || field.o.section_id == section_id && field._destroy = true
                    for section in template.sections
                        check_sect_index = mapped_section_ids.indexOf(section.i)
                        check_sect_index > sect_index && section.i--
                    template.sections.splice sect_index, 1

            # reorder section up or down
            moveSection: (template, index, new_index)->
                if template.sections[new_index]
                    target = template.sections[new_index]
                    template.sections[new_index] = template.sections[index]
                    template.sections[index] = target
                    template.sO = template.sections[new_index]
                return

            # add field
            addField: (template, section_id, column_id, type)->
                deferred = $q.defer()
                field_names = $.map template.fields, (x)-> x.o.name
                if (field_names.indexOf(template.newFieldName) != -1) || !template.newFieldName
                    Flash.create('danger', '<h3>Error! <small>Page</small></h3><p>Fields must have unique names.</p>', 'customAlert')
                    deferred.reject()
                    return deferred.promise
                field = new ClassFactory()
                field.template_id = template.id
                field.fieldtype = type.name
                field.o = {
                    name: template.newFieldName
                    section_id: section_id
                    column_id: column_id
                    column_order: newFieldOrdering(template, section_id, column_id)
                    glyphicon: type.glyphicon
                }
                field.$save {class: 'fields'}, (res)->
                    template.fields.push field
                    template.newFieldName = undefined
                    deferred.resolve()
                return deferred.promise

            # delete field
            deleteField: (ev, template, field)->
                deferred = $q.defer()
                confirm = $mdDialog.confirm()
                    .title('Are you sure you want to delete this field?')
                    .content('Pressing DELETE will permanently remove '+field.o.name+' from this page. However, any data collected for this field on this page\'s Google Sheet will not be affected.')
                    .targetEvent(ev)
                    .ok('DELETE')
                    .cancel('Get me out of here!')
                $mdDialog.show(confirm).then ->
                    $.extend field, new ClassFactory()
                    template.sO = undefined
                    field.$delete {class: 'fields', id: field.id}, ((res)->
                        index = $.map(template.fields, (x)-> x.id).indexOf(field.id)
                        for tempField in template.fields
                            tempField.o.section_id == template.fields[index].o.section_id && tempField.o.column_id == template.fields[index].o.column_id && tempField.o.column_order > template.fields[index].o.column_order && tempField.o.column_order--
                        template.fields.splice index, 1
                        slt(templates)
                        deferred.resolve()
                    ), (err)->
                        console.log err
                        deferred.reject()
                return deferred.promise

            # change a field's section_id
            changeFieldSection: (template, field, prev_section)->
                if field.o.section_id != prev_section
                    prev_column = field.o.column_id
                    prev_column_order = field.o.column_order
                    field.o.column_id = 1
                    field.o.column_order = 1
                    for tempField in template.fields
                        tempField.o.section_id == prev_section*1 && tempField.o.column_id == prev_column && tempField.o.column_order >= prev_column_order && tempField.o.column_order--
                        tempField.id != field.id && tempField.o.section_id == field.o.section_id && tempField.o.column_id == field.o.column_id && tempField.o.column_order++
                return

            # change a field's column_id
            changeFieldColumn: (template, field, column_id)->
                orig_col = field.o.column_id
                orig_col_ord = field.o.column_order
                field.o.column_id = column_id
                field.o.column_order = 1

                index = ($.map template.sections, (x)-> x.i).indexOf(parseInt(field.o.section_id, 10))

                sect_fields = $.grep template.fields, (tempField)->
                    tempField.o.section_id == field.o.section_id

                if column_id > 0 && column_id <= template.sections[index].c
                    orig_col != column_id && for tempField in sect_fields
                        tempField.o.column_id == orig_col && tempField.o.column_order > orig_col_ord && tempField.o.column_order--
                        tempField.o.column_id == column_id && tempField.id != field.id && tempField.o.column_order++
                else
                    field.o.column_id = orig_col
                    field.o.column_order = orig_col_ord
                return

            # reorder field up or down in a column
            moveField: (template, field, direction)->

                field_switch = ($.grep template.fields, (tempField)->
                    field.o.column_id == tempField.o.column_id && field.o.section_id == tempField.o.section_id && (field.o.column_order+parseInt(direction)) == tempField.o.column_order)[0]

                if !field_switch then return

                target = field_switch.o.column_order
                field_switch.o.column_order = field.o.column_order
                field.o.column_order = target
                return

            # add field option
            addOption: (field) ->
                !field.o.options && field.o.options = []
                field.o.options.push 'Option '+(field.o.options.length + 1)
                return

            # delete field option
            deleteOption: (ev, field, option)->
                confirm = $mdDialog.confirm()
                    .title('Are you sure you want to delete this field?')
                    .content('Pressing DELETE will permanently remove '+field.o.name+' from this page. However, any data collected for this field on this page\'s Google Sheet will not be affected.')
                    .targetEvent(ev)
                    .ok('DELETE')
                    .cancel('Get me out of here!')
                $mdDialog.show(confirm).then ->
                    field.o.options.splice option, 1
                return

            # Helper functions

            # Warn if template is a draft
            undraftFirst: ->
                Flash.create('danger', '<h3>Error! <small>Template</small></h3><p>Please undraft this template to use it in a report.</p>', 'customAlert')

            # set draft
            assimilate: (template, draft)->
                template.sO = undefined
                $.extend template, draft
                return

            supportedFields: [
                'labelntext'
                'textfield'
                'textarea'
                'email'
                'integer'
                'date'
                'time'
                'checkbox'
                'radio'
                'dropdown'
                # 'masked'
            ]

            addFieldTypes: [
                {name:'labelntext',value:'Label & Text',glyphicon:'text_fields'}
                {name:'textfield',value:'Text Line',glyphicon:'text_format'}
                {name:'textarea',value:'Text Area',glyphicon:'subject'}
                {name:'email',value:'E-mail',glyphicon:'email'}
                {name:'date',value:'Date',glyphicon:'date_range'}
                {name:'time',value:'Time',glyphicon:'access_time'}
                {name:'integer',value:'Integer',glyphicon:'dialpad'}
                {name:'checkbox',value:'Checkbox',glyphicon:'check_box'}
                {name:'radio',value:'Radio',glyphicon:'radio_button_checked'}
                {name:'dropdown',value:'Dropdown',glyphicon:'payment'}
            ]
        }

        # collect drafts
        # form && collectDrafts = $interval (->
        #   !template.drafts && template.drafts = []
        #   if !form.$pristine
        #       tempCopy = angular.copy template
        #       console.log 'creating draft'
        #       console.log tempCopy.time
        #       !tempCopy.time && template.drafts.push({
        #           time: moment()
        #           sections: tempCopy.sections
        #           fields: tempCopy.fields
        #       })
        #       template.drafts.length > 5 && template.drafts.pop()
        #   for draft in template.drafts
        #       draft.recent = moment(draft.time).fromNow()
        #   $location.path().search(template.id+'/edit') == -1 && clearInterval(collectDrafts)
        # ), 10000

    TemplatesService.$inject = ['$interval', '$location', '$mdDialog', '$q', '$rootScope', '$window', 'ClassFactory', 'Flash', 'localStorageService']

    angular.module('clerkr').service('TemplatesService', TemplatesService)