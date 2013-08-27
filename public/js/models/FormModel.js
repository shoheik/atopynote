app.models.FormModel = Backbone.Model.extend({

    url: "http://127.0.0.1:3000/submit",

    initialize:function () {
        var dd = new Date();
        var month = dd.getMonth() + 1;
        var date = dd.getDate() + 1;
        var year = dd.getYear() + 1900;
        //var ymd = year + "年" + month + "月" + date + "日";
        var date = new Date();
        date = date.getUTCFullYear() + '-' +
        ('00' + (date.getUTCMonth()+1)).slice(-2) + '-' +
        ('00' + date.getUTCDate()).slice(-2);
        this.set({date: date});
    },

    //sync: function(method, model, options) {
    //    if (method === "read") {
    //        app.adapters.employee.findById(parseInt(this.id)).done(function (data) {
    //            options.success(data);
    //        });
    //    }
    //}

});

app.models.meal = Backbone.Model.extend({
    initialize:function () {
    },

    sync: function(method, model, options) {
        if (method === "read") {
            //app.adapters.meal.findByMeal(this.get('mealType')).done(function (data) {
            //    options.success({breakfirst : data});
            //});
            app.adapters.meal.getMeal().done(function (data) {
                //console.log(data);
                var compiled_data = {};
                for (i in data.mealType){
                    //console.log(data.mealType[i]);
                    compiled_data[data.mealType[i]] = new Object();
                    for( j in data[data.mealType[i]]){
                        //console.log(data[data.mealType[i]][j]);
                        //console.log(data.mapping[data[data.mealType[i]][j]]);
                        var abr = data[data.mealType[i]][j];
                        var word = data.mapping[data[data.mealType[i]][j]];
                        compiled_data[data.mealType[i]][abr] = word;
                    }
                }
                options.success({meal : compiled_data});
                //console.log(compiled_data);
                //for (i in data['breakfirst']){
                //    console.log(data.breakfirst[i]);
                //}

                //options.success({breakfirst : data});
            });
        }
    }

});


