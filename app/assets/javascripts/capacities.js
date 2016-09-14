Function.prototype.bind = Function.prototype.bind || function () {
  var fn = this;
  var args = Array.prototype.slice.call(arguments);
  var object = args.shift();

  return function () {
    return fn.apply(object, args.concat(Array.prototype.slice.call(arguments)));
  };
};

UC.BedScheduleForm = function(form) {
  this.$dom = $(form);
  this.$button = this.$dom.find('input[type=submit]');
}

UC.BedScheduleForm.prototype.listen = function() {
  this.$dom.find('input[type=text]').one('focus', this.enable.bind(this));
  this.$dom.find('input[type=number]').one('focus', this.enable.bind(this));
  this.$dom.find('label').one('click', this.enable.bind(this));
};

UC.BedScheduleForm.prototype.enable = function() {
  this.$button.prop('disabled', false);
};

$(document).ready(function() {
  $('.bed-schedule-form').each(function(i, form) {
    new UC.BedScheduleForm(form).listen();
  });
})
