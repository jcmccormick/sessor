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

            overlay = '
                <div flex class="field-overlay" layout="column" layout-fill layout-align="start end" ng-if="template.e">
                    <md-button ng-click="template.sO=field" class="md-icon-button" ng-class="{\'force-hover\':template.sO.id == field.id}" aria-label="click to edit {{field.o.name}}">
                        <md-tooltip md-direction="top">
                            Click to edit {{field.o.name}}
                        </md-tooltip>
                        <md-icon>{{field.o.glyphicon}}</md-icon>      
                    </md-button>        
                </div>'

            hint = '<div class="tooltip" ng-show="field.o.tooltip && (!fform[field.o.name].$touched || fform[field.o.name].$valid)">{{field.o.tooltip}}</div>'

            required = '
                <div ng-messages="fform[field.o.name].$error" ng-show="fform[field.o.name].$touched && !fform[field.o.name].$valid">
                    <div ng-message="required" ng-if="field.o.required">This field is required.</div>
                </div>'

            mdfw = '
                <md-input-container class="md-block md-no-errors">
                    <label>{{field.o.name}}</label>'

            mdfwend = hint+required+overlay+'</md-input-container>'

            cust_start = '<div layout="column" layout-align="center start" layout-fill class="cust-start">'

            cust_end = overlay+'</div>'

            cust_tooltip = '<span ng-show="field.o.tooltip || field.o.required" class="cust-tooltip">'+hint+'<div class="required">'+required+'</div></span>'

            # Break apart an <input> tag into common denominators
            inputstart = '<input'

            ngmodel = if scope.report then 'ng-model="field.value.input"' else 'ng-model="field.o.default_value"'
            checkboxmodel = if scope.report then 'ng-model="$parent.field.value.input"' else 'ng-model="$parent.field.o.default_value"'

            inputend = ' name="{{field.o.name}}" ng-required="field.o.required" ng-disabled="field.o.disabled">'
            
            standard = ngmodel+' '+inputend

            # Define the particulars of each supported field
            labelntext = '<div layout="column">
                <span ng-if="field.o.name" class="md-title">{{field.o.name}}</span>
                <p class="md-body-1" ng-if="field.value.input || field.o.default_value">
                    {{field.value.input || field.o.default_value}}
                </p>'+overlay+'
            </div>'

            textfield = mdfw+inputstart+' type="text" '+standard+mdfwend
            textarea = mdfw+'<textarea type="text" '+standard+'</textarea>'+mdfwend
            email = mdfw+inputstart+' type="email" '+standard+mdfwend

            integer = mdfw+inputstart+' type="number" '+standard+mdfwend
            time = mdfw+inputstart+' type="time" '+standard+mdfwend
            date = cust_start+'<md-datepicker ng-click="fform[field.o.name].$setTouched()" md-placeholder="{{field.o.name}}" '+standard+'</md-datepicker>'+cust_tooltip+cust_end

            checkbox = cust_start+'<md-checkbox '+checkboxmodel+' ng-true-value="\'t\'" ng-false-value="\'f\'" class="green" aria-label="toggle {{field.o.name}}" '+inputend+'
                        {{field.o.name}}
                    </md-checkbox>'+cust_tooltip+cust_end

            radio = cust_start+'<span class="md-body-1">{{field.o.name}}</span>'+cust_tooltip+'
                    <md-radio-group '+ngmodel+' class="md-primary" ng-if="field.o.options">
                        <md-radio-button ng-repeat="option in field.o.options" ng-value="option"'+inputend+'{{option}}
                        </md-radio-button>
                    </md-radio-group>'+cust_end

            dropdown = mdfw+'<md-select '+standard+'
                    <md-optgroup label="{{field.o.name}}">
                        <md-option ng-repeat="option in field.o.options" ng-value="option">{{option}}</md-option>
                    </md-optgroup>
                </md-select>'+mdfwend

            # Verify field type
            cur_field = getTemplate(scope.field)

            # Compile the field display after doublechecking that values are appropriate for their fieldtype
            # If editing/viewing a template or editing a report, show <input> fields
            if (scope.template && !scope.report) || scope.report.e
                if scope.field.value || scope.field.default_value

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

                output = switch cur_field
                    when "labelntext" then labelntext

                    when "textfield" then textfield
                    when "textarea" then textarea
                    when "email" then email

                    when "integer" then integer
                    when "date" then date
                    when "time" then time

                    when "checkbox" then checkbox
                    when "radio" then radio
                    when "dropdown" then dropdown

                element.html output
            else
                # Else we're viewing a completed report, so only
                # show responses and not actual <input> fields

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
                    
                element.html '<div ng-if="field.fieldtype != \'labelntext\'">
                        <p class="md-subhead">{{field.o.name}}</p>
                        <blockquote class="md-title">{{valueCopy || "No data"}}</blockquote>
                    </div>'

            $compile(element.contents()) scope

            return

        {
            template: '<div>{{field}}</div>'
            restrict: 'E'
            scope:
                fform: '='
                field: '='
                template: '='
                report: '='
            link: linker
        }

    templateFieldDirective.$inject = ['$compile', '$filter', 'TemplatesService']
        
    angular.module('clerkr').directive('templateFieldDirective', templateFieldDirective)