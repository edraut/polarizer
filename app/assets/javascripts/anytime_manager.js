//Anytime loader, simulates load events for ajax requests
function getSubClass(sub_class_name,parent_class){
  if((typeof(sub_class_name) == 'string') && (sub_class_name != '') && (sub_class_name != 'true')){
    var this_class = sub_class_name;
  } else {
    var this_class = parent_class;
  }
  return this_class;
};

String.prototype.toCapCamel = function(){
  camel = this.replace(/[-_]([a-z])/g, function (g) { return g.replace(/[-_]/,'').charAt(0).toUpperCase(); });
  return camel.charAt(0).toUpperCase() + camel.slice(1);
};

var AnyTimeManager = Class.extend({
  init: function(){
    this.loader_array = []
  },
  register: function(data_attribute,load_method,base_class,namespace){
    if(!namespace){namespace = ''}else{namespace= namespace + '.'}
    this.loader_array.push({data_attribute: data_attribute, base_class: base_class, load_method: load_method, namespace: namespace});
  },
  registerList: function(list,namespace){
    var anytime_manager = this;
    $.each(list,function(){
      anytime_manager.register(this + '','instantiate',null,namespace)
    })
  },
  registerListWithClasses: function(list,namespace){
    var anytime_manager = this;
    $.each(list,function(attr,klass){
      anytime_manager.register(attr,'instantiate',klass,namespace)
    })
  },
  registerRunList: function(list){
    var anytime_manager = this;
    $.each(list,function(attr,method){
      anytime_manager.register(attr,method,null)
    })
  },
  instantiate: function(jq_obj, class_name){
    if(!jq_obj.data('anytime_loaded')){
      jq_obj.data('anytime_loaded',{})
    }
    if(!jq_obj.data('anytime_loaded')[class_name]){
      var new_load = {}
      new_load[class_name] = true
      $.extend(jq_obj.data('anytime_loaded'),new_load)
      var this_class = eval(class_name);
      var obj = new this_class(jq_obj);
      this.recordLoad(class_name, obj)
    }
  },
  run: function (jq_obj, resource, method_name){
    if(!jq_obj.data('anytime_run')){
      jq_obj.data('anytime_run',true);
      resource[method_name](jq_obj);
    }
  },
  load: function(){
    var atm = this;
    $.each(atm.loader_array,function(){
      var data_attribute = this['data_attribute'];
      var base_class = this['base_class'];
      if(!base_class){
        base_class = data_attribute.toCapCamel();
      }
      var this_method = this['load_method'];
      var namespace = this['namespace'];
      $('[data-' + data_attribute + ']').each(function(){
        if('instantiate' == this_method){
          var declared_class = $(this).data('sub-type');
          var this_class = getSubClass(declared_class,base_class);
          this_class = namespace + this_class;
          atm.instantiate($(this),this_class);
        }else{
          atm.run($(this),base_class,this_method);
        }

      });
    });
  },
  recordLoad: function(class_name, object){
    if(!this.recordedObjects){
      this.recordedObjects = {}
    }
    if(!this.recordedObjects.hasOwnProperty(class_name)){
      this.recordedObjects[class_name] = []
    }
    this.recordedObjects[class_name].push(object)
  }
});
window.any_time_manager = new AnyTimeManager();
$(document).ajaxComplete(function(){
  window.any_time_manager.load();
});
$(document).ready(function(){
  if(typeof window.any_time_load_functions != 'undefined'){
    $.each(window.any_time_load_functions, function(i,func){
      func();
    });
  }
  window.any_time_manager.load();
});

// End AnyTime library