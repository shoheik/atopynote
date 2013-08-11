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

