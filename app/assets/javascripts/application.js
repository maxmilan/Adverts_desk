// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

$(document).ready(function(){
    var $textarea= $('textarea');
    $textarea.height($textarea.get(0).scrollHeight);
    $textarea.on('keyup input', function(){
        var $this = $(this);
        $this.height(1);
        $this.height(this.scrollHeight);
    });
});

$(document).on('click', 'input.btn-default', function(){
    var $last_id = $('#0').parent().children().last().prev().attr('id');
    var $id = parseInt($last_id,10) + 1;
    $('#' + $last_id).after('<input id="' + $id + '" type="file" name="advert[images_attributes][' + $id +'][asset]">');
});