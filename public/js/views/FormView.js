app.views.FormView = Backbone.View.extend({

    id: 'main_view',

    initialize: function () {
        //this.searchResults = new app.models.EmployeeCollection();
        //this.searchresultsView = new app.views.EmployeeListView({model: this.searchResults});
        this.dates = new app.models.DateCollection();
        this.dateView = new app.views.DateView({ collection: this.dates }); 
        this.meal_model = new app.models.meal();
    },

    render: function () {
        var self = this;
        this.meal_model.fetch({
                success: function(data){
                    var meal = data.get('meal');
                    var meal_html = "";
                    for (var type in meal){
                        //console.log(type);
                        var tpl = _.template("<label for='<%= item %>' class='meal-checkbox'><input type='checkbox' name='<%= type %>' id='<%= type %>_<%= item %>' value='<%= item %>'/><%= label %></label>");
                        var html = "";
                        for (var item in meal[type]) {
                            html += tpl({ item: item, label:meal[type][item], type: type }); 
                            //console.log(item);
                            //console.log(meal[type][item]);
                        }        
                        var type_mappings = data.get('type_mapping');
                        var type_mapping;
                        for (var i in type_mappings){
                            for (var j in type_mappings[i]){
                                if ( j === type ){
                                    type_mapping = type_mappings[i][j];
                                }
                            }
                        }
                        var tmpl = _.template("<fieldset><legend><div class='item'><%= type_mapping %></div></legend><div id='checkbox_view'><%= content %></div></fieldset>");
                        meal_html += tmpl({type: type, content: html, type_mapping: type_mapping});
                    }            
                    //console.log(meal_html);
                    //self.model.set({meal: meal_html});
                    self.$el.html(self.template({meal: meal_html}));
                    self.$el.find('#date').replaceWith(self.dateView.el); // template migth be better but it's ok
                    return self;

                }                
        });            

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

        var form = $('form').serializeArray();
        this.model.set({meal: form}); 
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
