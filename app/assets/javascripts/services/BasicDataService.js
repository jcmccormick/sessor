(function(){
    'use strict';

    angular
        .module('clerkr')
        .service('BasicDataService', BasicDataService);

    BasicDataService.$inject = ['ClassFactory', 'localStorageService', '$log', '$q'];

    function BasicDataService(ClassFactory, localStorageService, $log, $q){
        var deferred = $q.defer();

        return {
            getData: getData,
            getAllData: getAllData
        };

        function getData(klass){

            ClassFactory.query({class: klass}, function(response){
                localStorageService.set('_cs'+klass, response);
                deferred.resolve(localStorageService.get('_cs'+klass));
            }, function(error){
                $log.error(error);
                deferred.reject(error);
            });

            return deferred.promise;
        }

        function getAllData(){
            if(!localStorageService.get('_csreports') || !localStorageService.get('_cstemplates')){

                getData('reports').then(function(response){
                    getData('templates').then(function(response){

                        deferred.resolve();

                    }).catch(reterievalError);

                }).catch(reterievalError);

            } else {
                deferred.resolve();
            }

            function reterievalError(error){
                $log.error(error);
                deferred.reject(error);
            }

            return deferred.promise;
        }

    }

})();