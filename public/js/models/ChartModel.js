app.models.BaseChart = Backbone.Model.extend({

    initialize:function () {
        //
    },

    sync: function(method, model, options) {
        if (method === "read") {
            app.adapters.chart.getBaseChart(1).done(function(data){
                options.success(data);
            });
        }
    }
});

