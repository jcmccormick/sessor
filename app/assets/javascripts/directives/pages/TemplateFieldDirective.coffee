do ->
    'use strict'

    templateFieldDirective = ($compile, $filter, TemplatesService) ->
        
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
            requiredtip = '
                <md-icon class="md-warn" ng-if="field.o.required && !field.value.input && !field.o.default_value">
                    <md-tooltip md-direction="top">
                        Required
                    </md-tooltip>
                    grade
                </md-icon>
                <md-icon ng-if="field.o.tooltip">
                    <md-tooltip md-direction="top">
                        {{field.o.tooltip}}
                    </md-tooltip>
                    live_help
                </md-icon>'

            overlay = '<div class="field-overlay" md-ink-ripple ng-click="template.sO=field" ng-class="{\'force-hover\':template.sO.id == field.id}" ng-if="template.e" aria-label="click to edit {{field.o.name}}">
                <md-tooltip md-direction="bottom">
                    Click to edit {{field.o.name}}
                </md-tooltip>                
            </div>'

            mdfw = '<div layout="row" layout-fill>'+requiredtip+'
                <md-input-container flex>
                    <label>{{field.o.name}}</label>'

            mdfwend = overlay+'
                </md-input-container>
            </div>'

            # Break apart an <input> tag into common denominators
            inputstart = '<input'

            ngmodel = if scope.report then 'ng-model="field.value.input"' else 'ng-model="field.o.default_value"'
            checkboxmodel = if scope.report then 'ng-model="$parent.field.value.input"' else 'ng-model="$parent.field.o.default_value"'

            inputend = ' ng-required="field.o.required" ng-disabled="field.o.disabled">'
            
            standard = ngmodel+' '+inputend

            # Define the particulars of each supported field
            labelntext = '<div layout="row">
                <div layout="column" class="md-input-container-parent" layout-fill>
                    <span ng-if="field.o.name" class="md-title">{{field.o.name}}</span>
                    <p ng-if="field.value.input || field.o.default_value">
                        {{field.value.input || field.o.default_value}}
                    </p>
                    <p ng-if="!(field.value.input || field.o.default_value) && template.e">
                        Add text here. Use just the label, or text, or both
                    </p>
                    '+overlay+'
                </div>
            </div>'

            textfield = inputstart+' type="text" '+standard
            textarea = '<textarea type="text" '+standard+'</textarea>'
            email = inputstart+' type="email" '+standard

            integer = inputstart+' type="number" '+standard
            date = inputstart+' type="date" '+standard
            time = inputstart+' type="time" '+standard

            checkbox = '<div layout="row">'+requiredtip+'
                <div layout="column" class="md-input-container-parent" layout-fill>

                    <md-checkbox '+checkboxmodel+' aria-label="toggle {{field.o.name}}"'+inputend+'
                        {{field.o.name}}
                    </md-checkbox>
                    '+overlay+'
                </div>
            </div>'

            radio = '
            <div layout="row" layout-align="start start">
                '+requiredtip+'
                <div layout="column" class="md-input-container-parent" layout-fill>
                    <span class="md-title">{{field.o.name}}</span>

                    <md-radio-group ng-model="data.group1" class="md-primary" ng-if="field.o.options">
                        <md-radio-button ng-repeat="option in field.o.options" ng-value="option">{{option}}</md-radio-button>
                    </md-radio-group>
                    '+overlay+'
                </div>
            </div>'

            dropdown = '<div layout="row">'+requiredtip+'
                <div layout="column" class="md-input-container-parent" layout-fill>
                    <md-select placeholder="{{field.o.name}}" ng-model="ctrl.userState">
                        <md-optgroup label="{{field.o.name}}">
                            <md-option ng-repeat="option in field.o.options" ng-value="option">{{option}}</md-option>
                        </md-optgroup>
                    </md-select>
                    '+overlay+'
                </div>
            </div>'

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
                    when "labelntext" then element.html labelntext

                    when "textfield" then element.html mdfw+textfield+mdfwend
                    when "textarea" then element.html mdfw+textarea+mdfwend
                    when "email" then element.html mdfw+email+mdfwend

                    when "integer" then element.html mdfw+integer+mdfwend
                    when "date" then element.html mdfw+date+mdfwend
                    when "time" then element.html mdfw+time+mdfwend

                    when "checkbox" then element.html checkbox
                    when "radio" then element.html radio
                    when "dropdown" then element.html dropdown
            else
                # Else we're viewing a report, so only show 
                # input text and not an actual <input> field

                if scope.field.value?

                    scope.valueCopy = angular.copy scope.field.value.input

                    scope.valueCopy? && ['integer','date','time','checkbox'].indexOf(cur_field) != -1 && scope.valueCopy = switch cur_field
                        when "integer"
                            parseInt(scope.valueCopy, 10)
                        when "date"
                            $filter('date')(scope.valueCopy, 'shortDate')
                        when "time"
                            $filter('date')(scope.valueCopy, 'shortTime')
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

    templateFieldDirective.$inject = ['$compile', '$filter', 'TemplatesService']
        
    angular.module('clerkr').directive('templateFieldDirective', templateFieldDirective)