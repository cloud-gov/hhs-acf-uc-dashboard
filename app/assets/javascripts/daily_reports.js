UC.DailyReportDateSelection = function(selector) {
  this.$dom = $(selector);
}

UC.DailyReportDateSelection.prototype.listen = function() {
  this.$dom.on('change', this.reloadWithNewQuery.bind(this));
};

UC.DailyReportDateSelection.prototype.reloadWithNewQuery = function(e) {
  var selectedDate = this.$dom.val();
  var path = '/daily_reports/' + selectedDate + window.location.search;
  window.location.href = path;
};

UC.DailyReportTypeSelection = function(selector) {
  this.$dom = $(selector);
}

UC.DailyReportTypeSelection.prototype.listen = function() {
  this.$dom.on('change', this.reloadWithNewQuery.bind(this));
};

UC.DailyReportTypeSelection.prototype.reloadWithNewQuery = function(e) {
  var reportType = this.$dom.val();
  var path = window.location.pathname + '?type=' + reportType;
  window.location.href = path;
};

$(document).ready(function() {
  $('#select-report-date').each(function(i, selector) {
    new UC.DailyReportDateSelection(selector).listen();
  });

  $('#select-report-type').each(function(i, selector) {
    new UC.DailyReportTypeSelection(selector).listen();
  });
});
