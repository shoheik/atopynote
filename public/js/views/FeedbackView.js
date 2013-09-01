app.views.FeedbackView = Backbone.View.extend({

    initialize: function () {
    },

    render: function () {
        console.log('here');
        this.$el.html(this.template());
        return this;
    },

});
