app.models.Date = Backbone.Model.extend({
});

app.models.DateCollection = Backbone.Collection.extend({
    model: app.models.Date,

    initialize: function () {
        this.date = new Date();
        for (var i=0; i>-7; i--) {
            var d = this.computeDate(i);
            this.add(new this.model({date: d}));
        }
    },

    computeDate: function(addDays) {
        var dt = new Date(this.date.getFullYear(), this.date.getMonth(), this.date.getDate() );
        var baseSec = dt.getTime();
        var addSec = addDays * 86400000; //日数 * 1日のミリ秒数
        var targetSec = baseSec + addSec;
        dt.setTime(targetSec);
        return dt.getFullYear() + '-' + (dt.getMonth() + 1) + '-' + dt.getDate();
    }


});

