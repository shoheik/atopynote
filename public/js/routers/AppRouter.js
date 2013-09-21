app.routers.AppRouter = Backbone.Router.extend({

    routes: {
        "home":                     "home",
        "":                         "home",
        "form":                     "form",
        "stats":                    "stats",
        "feedback":                 "feedback",
        "xchange":                  "xchange"
    },

    initialize: function () {
        //app.slider = new PageSlider($('body'));
    },

    home: function () {
        // Since the home view never changes, we instantiate it and render it only once
        if (!app.homeView) {
            app.homeView = new app.views.HomeView();
            app.homeView.render();
        } else {
            console.log('reusing home view');
            app.homeView.delegateEvents(); // delegate events when the view is recycled
        }
        $('#body').html(app.homeView.$el);
    },

    form: function () {
        $('html, body').animate({scrollTop: $('#body').offset().top}, "slow");
        var fm = new app.models.FormModel();
        app.formView = new app.views.FormView({model: fm});
        app.formView.render();
        $('#body').html(app.formView.$el);
        // Move to #body
    },

    stats: function () {
        if (!app.statsView) {
            app.statsView = new app.views.StatsView();
            app.statsView.render();
        } else {
            console.log('reusing home view');
            app.statsView.delegateEvents(); // delegate events when the view is recycled
        }
        $('#body').html(app.statsView.$el);
        $('html, body').animate({scrollTop: $('#body').offset().top}, "slow");
    },

    xchange: function () {
        if (!app.xchangeView) {
            app.xchangeView = new app.views.XchangeView();
            app.xchangeView.render();
        } else {
            console.log('reusing home view');
            app.xchangeView.delegateEvents(); // delegate events when the view is recycled
        }
        //app.slider.slidePage(app.homeView.$el);
        $('#body').html(app.xchangeView.$el);
        $('html, body').animate({scrollTop: $('#body').offset().top}, "slow");
    },

    feedback: function () {
        if (!app.feedbackView) {
            app.feedbackView = new app.views.FeedbackView();
            app.feedbackView.render();
        } else {
            console.log('reusing home view');
            app.feedbackView.delegateEvents(); // delegate events when the view is recycled
        }
        //app.slider.slidePage(app.homeView.$el);
        $('#body').html(app.feedbackView.$el);
        $('html, body').animate({scrollTop: $('#body').offset().top}, "slow");
    },


});
