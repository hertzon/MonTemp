AmCharts.makeChart("chartdiv",
	{
		"type": "serial",
		"categoryField": "category",
		"autoMarginOffset": 40,
		"marginRight": 60,
		"marginTop": 60,
		"startDuration": 1,
		"fontSize": 13,
		"theme": "patterns",
		"categoryAxis": {
			"gridPosition": "start"
		},
		"trendLines": [],
		"graphs": [
			{
				"balloonText": "[[title]] of [[category]]:[[value]]",
				"bullet": "round",
				"bulletSize": 10,
				"id": "AmGraph-1",
				"lineAlpha": 1,
				"lineThickness": 3,
				"title": "graph 1",
				"type": "smoothedLine",
				"valueField": "column-1"
			}
		],