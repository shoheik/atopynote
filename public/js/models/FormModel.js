app.models.FormModel = Backbone.Model.extend({

    url: "http://127.0.0.1:3000/form/submit",

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
            app.adapters.meal.getMeal().done(function (data) {
                //console.log(data);
                var compiled_data = {};
                var type_mapping = new Array();
                for (var i in data.mealType){
                    var type;
                    for (var meal_obj in data.mealType[i]){
                        type = meal_obj;
                    }
                    //console.log(type);
                    //console.log(data[type]);
                    compiled_data[type] = new Object();
                    for( var j in data[type]){
                        //console.log(data[type][j]);
                        //console.log(data.mapping[data[type][j]]);
                        var abr = data[type][j];
                        var word = data.mapping[data[type][j]];
                        compiled_data[type][abr] = word;
                    }
                }
                options.success({meal : compiled_data, type_mapping: data.mealType});
            });
        }
    }

});


