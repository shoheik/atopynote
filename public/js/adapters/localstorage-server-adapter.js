app.adapters.meal = (function () {

    // mealTpye is either breakfirst, lunch or dinner
    var findByMeal = function (mealType) {

        var deferred = $.Deferred();

        $.get('/form/meal').done(function(res){
            deferred.resolve(res[mealType]);    
        });
        return deferred.promise();
    };

    var getMeal = function (){
        var deferred = $.Deferred();
        $.get('/form/meal').done(function(res){
            deferred.resolve(res);    
        });
        return deferred.promise();
    };

    // The public API
    return {
        findByMeal: findByMeal,
        getMeal: getMeal
    };

}());
