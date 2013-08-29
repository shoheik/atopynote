app.views.DateView = Backbone.View.extend({

    tagName: 'select', 
    id: 'date',
    attributes: {name: 'date'},

    initialize: function () {
        this.render();
    },

    render: function () {
        var dates = this.collection.map(function(model) {
            return model.get('date');
        });
        var options = "";
        for (var i in dates){
            options = options + "<option>" + dates[i] + "</option>";
        }
        this.$el.html(options);
    }
});

