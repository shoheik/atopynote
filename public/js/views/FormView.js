app.views.FormView = Backbone.View.extend({

    initialize: function () {
        this.searchResults = new app.models.EmployeeCollection();
        this.searchresultsView = new app.views.EmployeeListView({model: this.searchResults});
        //_.bindAll(this, 'changeRange');
    },

    render: function () {
        this.$el.html(this.template(this.model.attributes));
        return this;
    },

    events: {
        "click #submit": "submitForm",
        "change input.form_range": "changeRange"
    },

    changeRange: function(event){
        var value = $(event.target).val();
        var id = $(event.target).attr("id");
        $("span#range_" + id).html(value);
    },

    submitForm: function (event) {
        this.model.set("itch", $('input#itch').val());
        this.model.set("feeling", $('input#feeling').val());
        this.model.set("stress", $('input#stress').val());
        this.model.set("sleep", $('input#sleep').val());
        this.model.set("bowels", $('input#bowels').val());
        this.model.set("excercise", $('select#excercise').val());
        var food = [];
        $('[name="food"]:checked').each(function(){
            food.push($(this).attr('id'));
        });
        this.model.set("food", food);
        console.log(this.model.toJSON());
        this.model.save();
        //this.model.save(null, { success : function(model, res){ 
        //        alert('hello?');
        //        console.log(res); 
        //        //app.routers.navigate("www/index.html", {trigger: true});
        //        //return false;
        //    }
        //});
        app.router.navigate("#", {trigger: true});

    }
});
