var rt_tabulate = function (summary_data,columns) {
  var table = d3.select('#summary_data').append('table')
		.attr("id", "summary_table")
		.attr("class", "display")
		.attr("data-toggle", "table")
		.attr("data-sort-class", "table-active")
		.attr("data-sortable", "true")
		.attr("data-height", "460")
	var thead = table.append('thead')
	var tbody = table.append('tbody')

	thead.append('tr')
	  .selectAll('th')
	    .data(columns)
	    .enter()
	  .append('th')
			.attr("data-sortable", "true")
			.attr("page-length", "30")
			.attr("data-field", function(d) {return d.replace(/\W/g,'')})
	    .text(function (d) { return d })

	var rows = tbody.selectAll('tr')
	    .data(summary_data)
	    .enter()
	  .append('tr')

	var cells = rows.selectAll('td')
	    .data(function(row) {
	    	return columns.map(function (column) {
	    		return { column: column, value: row[column] }
	      })
      })
      .enter()
    .append('td')
      .text(function (d) { return d.value })

  return table;

}

d3.csv('epinow/summary_table.csv').then(function (summary_data) {
	var columns = ['Region','New confirmed cases by infection date','Expected change in daily cases','Effective reproduction no.','Rate of growth','Doubling/halving time (days)']
  rt_tabulate(summary_data,columns)
	$('#summary_table').DataTable();
})
