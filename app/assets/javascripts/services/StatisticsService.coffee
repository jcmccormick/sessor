do ->
    'use strict'

    StatisticsService = ($q, ClassFactory, Flash, googleChartApiPromise)->
        {
            googleChart: ->
                googleChartApiPromise

            showDataCounts: (sv)->
                ids = $.map sv.template.fields, (x)-> x.id
                deferred = $q.defer()
                ClassFactory.get({class: 'values_statistics', id: 'counts', field_id: sv.field.id, days: sv.days, field_ids: ids}, (res)->
                    !res.rows.length && Flash.create('danger', '<h3>Error! <small>No data</small></h3><p>There is no data for the selected field.</p>', 'customAlert')
                    sv.chart.data.cols = res.cols
                    sv.chart.data.rows = res.rows
                    #sv.chart.options.title = sv.template.name+': '+(sv.field.o.name || sv.field.o.placeholder)
                    if !sv.chart.displayed && res.rows.length
                        googleChartApiPromise.then ->
                            chartEditor = undefined

                            sv.chart.displayed = true
                            sv.loadEditor()
                            deferred.resolve()
                    else
                        sv.loadEditor()
                        deferred.resolve()
                )
                return deferred.promise

            graphs: [
                {name:'Pie',type:'PieChart'}
                {name:'Column',type:'ColumnChart'}
                {name:'Bar',type:'BarChart'}
                {name:'Area',type:'AreaChart'}
                {name:'Line',type:'LineChart'}
                {name:'Table',type:'Table'}
            ]

        }

    StatisticsService.$inject = ['$q', 'ClassFactory', 'Flash', 'googleChartApiPromise']

    angular.module('clerkr').service('StatisticsService', StatisticsService)