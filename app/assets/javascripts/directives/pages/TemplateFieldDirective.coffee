do ->
    'use strict'

    templateFieldDirective = ($compile, TemplatesService) ->
        
        getTemplate = (field) ->
            type = field.fieldtype
            supportedFields = TemplatesService.supportedFields

            __indexOf = [].indexOf || (item)->
                i = 0
                for i in [0...this.length]
                    if i in this && this[i] == item
                        i++
                        return i
                return -1

            if __indexOf.call(supportedFields, type) >= 0
                return type
            return

        linker = (scope, element, attrs)->

            # Create a container (form-group) for field input box layout
            fwstart = '<div class="form-group" ng-class="{\'clear-align\':field.fieldtype==\'checkbox\' || field.fieldtype==\'radio\' || field.fieldtype==\'labelntext\',\'space\':field.fieldtype==\'checkbox\' && field.o.column_order == 1}" scroll-to=".force-hover" template="template">
                    <div class="glyphs">
                        <span ng-if="field.o.tooltip" bs-popover>
                            <i class="glyphicon glyphicon-question-sign" rel="popover" data-container="body" data-placement="bottom" data-html="false" data-content="{{field.o.tooltip}}"></i>
                        </span>
                        <i class="glyphicon glyphicon-asterisk field-required" ng-if="field.o.required && !field.value.input && !field.o.default_value"></i>
                    </div>'
            
            fwmid = '<h3>{{field.o.name}}</h3>'

            fwend = '<div class="field-overlay" ng-class="{\'force-hover\':template.sO.id == field.id}" ng-if="template.e"><i class="glyphicon {{field.o.glyphicon}}" ng-class="{\'bump-down\':field.fieldtype != \'checkbox\' && !field.o.name}"></i></div>
                         </div>'

            fw = fwstart+fwmid

            # Break apart an <input> tag into common denominators
            inputstart = '<input'
            clas = 'class="form-control imod" ng-class="{\'notfull\': !field.o.default_value && !field.value.input}" '

            ngmodel = if scope.report then 'ng-model="field.value.input"' else 'ng-model="field.o.default_value"'
            checkboxmodel = if scope.report then 'ng-model="$parent.field.value.input"' else 'ng-model="$parent.field.o.default_value"'

            fid = ' id="{{field.o.section_id}}{{field.o.column_id}}{{field.id}}"'
            pho = ' placeholder="{{field.o.placeholder}}"'

            inputend = ' ng-focus="template.sO=field" name="{{field.o.section_id}}{{field.o.column_id}}{{field.id}}" ng-required="field.o.required" ng-disabled="field.o.disabled">'
            
            standard = clas+' '+fid+' '+pho+' '+ngmodel+' '+inputend

            # Define the particulars of each supported field
            labelntext = '<p ng-if="!field.value.input && !field.o.default_value && template.e">
                            Add text here. Use just the label, or text, or both...
                        </p>
                        <blockquote ng-if="field.value.input || field.o.default_value">{{field.value.input || field.o.default_value}}</blockquote>'

            textfield = inputstart+' type="text" '+standard
            textarea = '<textarea type="text" '+standard+'</textarea>'
            email = inputstart+' type="email" '+standard

            integer = inputstart+' type="number" '+standard
            date = inputstart+' type="date" '+standard
            time = inputstart+' type="time" '+standard

            checkbox = '<label for="{{field.o.section_id}}{{field.o.column_id}}{{field.id}}" class="clearfix">
                            '+inputstart+' type="checkbox" class="form-control imod" ng-true-value="\'t\'" ng-false-value="\'f\'"'+fid+checkboxmodel+inputend+'
                            <h5>{{field.o.name}}</h5>
                        </label>'
            radio = '   <span ng-if="field.o.options && !field.o.options.length">
                            Click to add options...
                        </span>
                        <label for="{{field.o.section_id}}{{field.o.column_id}}{{field.id}}{{$index}}" class="clearfix" ng-repeat="option in field.o.options track by $index">
                            '+inputstart+' type="radio" class="form-control imod" id="{{field.o.section_id}}{{field.o.column_id}}{{field.id}}{{$index}}" ng-value="field.o.options[$index]" '+ngmodel+inputend+'
                            <h5>{{option}}</h5>
                        </label>'
            dropdown = '<select ng-options="option for option in field.o.options" '+standard+'
                            <option value="">{{field.o.placeholder || "Select an item..."}}</option>
                        </select>'

            # masked = inputstart+' type="password" '+standard

            # Verify field type
            cur_field = getTemplate(scope.field)

            # Compile the field display after doublechecking that values are appropriate for their fieldtype
            # If editing/viewing a template or editing a report, show <input> fields
            if (scope.template && !scope.report) || scope.report.e
                if (scope.report && scope.field.value) || (!scope.report && scope.field.default_value)

                    # Pre-parse the value
                    cur_value = if scope.report
                        scope.field.value.input
                    else
                        scope.field.o.default_value

                    if cur_value?
                        if cur_field == 'integer'
                            cur_value = parseInt(cur_value, 10)
                        if cur_field == 'date' || cur_field == 'time'
                            cur_value = if cur_value != '1970-01-01T00:00:00.000Z'
                                new Date(cur_value)
                            else
                                ''

                    # Reattach parsed value
                    !scope.report && scope.field.o.default_value = cur_value
                    scope.report && scope.field.value.input = cur_value

                switch cur_field
                    when "labelntext" then element.html fw+labelntext+fwend

                    when "textfield" then element.html fw+textfield+fwend
                    when "textarea" then element.html fw+textarea+fwend
                    when "email" then element.html fw+email+fwend

                    when "integer" then element.html fw+integer+fwend
                    when "date" then element.html fw+date+fwend
                    when "time" then element.html fw+time+fwend

                    when "checkbox" then element.html fwstart+checkbox+fwend
                    when "radio" then element.html fw+radio+fwend
                    when "dropdown" then element.html fw+dropdown+fwend

                    # when "masked" then element.html fw+masked+fwend
            else
                # Else we're viewing a report, so only show 
                # input text and not an actual <input> field

                if scope.field.value?

                    scope.valueCopy = angular.copy scope.field.value.input

                    scope.valueCopy? && ['integer','date','time','checkbox'].indexOf(cur_field) != -1 && scope.valueCopy = switch cur_field
                        when "integer"
                            parseInt(scope.valueCopy, 10)
                        when "date"
                            new Date(scope.valueCopy).format("DDDD, MMMM DS, YYYY")
                        when "time"
                            new Date(scope.valueCopy).format("hh:mm TT")
                        when "checkbox"
                            if scope.valueCopy == "f" then 'False' else 'True'

                    display = if cur_field == 'labelntext'
                        '<blockquote>{{valueCopy}}</blockquote>'
                    else
                        '<h4><strong>{{valueCopy || "No data"}}</strong></h4>'
                    
                element.html '<h3>'+scope.field.o.name+'</h3>' + display

            $compile(element.contents()) scope
            return

        {
            template: '<div>{{field}}</div>'
            restrict: 'E'
            scope:
                myForm: '='
                field: '='
                template: '='
                report: '='
            link: linker
        }

    templateFieldDirective.$inject = ['$compile', 'TemplatesService']
        
    angular.module('clerkr').directive('templateFieldDirective', templateFieldDirective)