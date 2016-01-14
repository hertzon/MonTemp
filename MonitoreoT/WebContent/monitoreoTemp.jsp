<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="refresh" content="15" >
<title>Monitoreo Temperatura Bogota en Tiempo Real</title>
<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="components.min.css">

<link rel="stylesheet" type="text/css" href="colores.css">


<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.DataOutputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.net.ServerSocket" %>
<%@ page import="java.net.Socket" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.ResultSet" %>
</head>

<body>
	<script type="text/javascript">
		<%
			ServerSocket serverSocket = null; 
		 	Connection conDB = null;
		 	String inputLine; 
		 	int prescalerDb=0;
		 	int prescalerMin=0;
			Date date = new Date();
			Timestamp time=new Timestamp(date.getTime());
			out.println("//tiempo: "+time);
			String timeStr=time.toString();
			String[] parts=timeStr.split("-");
			//System.out.println("parte 2: "+parts[2]);
			String strHoraActual=parts[2].substring(3, 5);
			int horaActual=Integer.parseInt(strHoraActual);
			System.out.println("Hora actual: "+horaActual);
			String dia=parts[2].substring(0, 2);
			
		    try {
				Class.forName("org.postgresql.Driver");
				String url="jdbc:postgresql://localhost:5432/postgres";
				try {				
					conDB = DriverManager.getConnection(url,"postgres","irf840");
					int hora=21;
		
					int ndia=Integer.parseInt(dia);
					out.println("var diaHoy="+ndia+";");
					float[] temperaturas_promedio=new float[24];
					for (int i=0;i<temperaturas_promedio.length;i++){
						temperaturas_promedio[i]=0;
					}
					temperaturas_promedio[ndia]=0;
					float maximo=0;
					float minimo=40;
					StringBuilder json = new StringBuilder();
					String hour=null;
					out.println("var chartData1 = [{");
					for (hora=0;hora<=horaActual;hora++){
						String query="select * from temps where extract(day from time)="+ndia+" and extract(hour from time)="+hora+";";
						Statement st=conDB.createStatement();
						ResultSet rs=st.executeQuery(query);
						int n=0;
						while (rs.next()){
							n++;
							temperaturas_promedio[hora]=temperaturas_promedio[hora]+rs.getFloat("temp");
							//System.out.println("Temperatura: "+rs.getFloat("temp")+" "+"de date: "+rs.getString("time")+" muestra: "+n);
							hour=rs.getString("time");
							//out.println("//hour:"+hour);
						}
						//System.out.println("Acumulado: "+temperaturas_promedio[hora]+" nmuestras: "+n);
						temperaturas_promedio[hora]=(float)temperaturas_promedio[hora]/n;
						json.append("\"date\": "+"\""+hora+"\""+","+"\r");
						json.append("\"temperatura\": "+"\""+temperaturas_promedio[hora]+"\""+"\r");	
						json.append("}"+","+"{"+"\r");					
						if (temperaturas_promedio[hora]>maximo){
							maximo=temperaturas_promedio[hora];
						}
						if (temperaturas_promedio[hora]<minimo){
							minimo=temperaturas_promedio[hora];
						}
						//System.out.println("Temperatura promedio del dia: "+dia+" a la hora: "+hora+" es: "+temperaturas_promedio[hora]);
					}
					String jsonstr=json.toString();
					jsonstr=jsonstr.substring(0, jsonstr.length()-3)+"];";
					out.println(jsonstr);
					out.println("var temperatura_actual="+temperaturas_promedio[hora-1]+";");
					out.println("var maximo="+maximo+";");
					out.println("var minimo="+minimo+";");
					
					hour=hour.substring(0, hour.length()-4);
					out.println("var date="+"\""+hour+"\""+";");
					conDB.close();				
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					//e.printStackTrace();
					out.println(e);
				}
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
				out.println(e);
			}
        
		
		%>
	</script>
	
	<div class='container color6'>	
		<div class="row">
			<div class="col-md-12 col-sm-12 text-center">
				<h2 class="font-green-sharp">Monitoreo de la Temperatura Ambiente de Bogota en Tiempo Real</h2>
				<a href="http://www.latiendaelectronica.co"  target="_blank"><h3 class="font-green-sharp ">Modulos de Hardware y codigo disponibles en www.latiendaelectronica.co</h3></a>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
				<div class="dashboard-stat2 ">
					<div class="display">
						<div class="number"> 	
							<small>Temperatura Centigrados</small>	
							<h3 class="font-green-sharp">
								<span data-value="7800" data-counter="counterup">
									<script type="text/javascript">
										temperatura_actual=temperatura_actual.toFixed(1);
										document.write(temperatura_actual);								
									</script> 								
								</span>
								<small class="font-green-sharp"></small>
							</h3>
							<small>
							<script type="text/javascript">
								document.write(date);								
							</script>
							</small>
						</div>
					</div>
				</div>	
			</div>
			<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
				<div class="dashboard-stat2 ">
					<div class="display">
						<div class="number">
							<small>Temperatura Maxima</small>
							<h3 class="font-red-haze">
								<span data-value="7800" data-counter="counterup">
									<script type="text/javascript">
										var omaximo=maximo.toFixed(2);
										document.write(omaximo);	
										
									</script>
								</span>
								<small class="font-red-haze">oC</small>
							</h3>
						</div>
					</div>
				</div>	
			</div>
			<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
				<div class="dashboard-stat2 ">
					<div class="display">
						<div class="number">
							<small>Temperatura minima</small>
							<h3 class="font-blue-sharp">
								<span data-value="7800" data-counter="counterup">
								
								<script type="text/javascript">
									var ominimo=minimo.toFixed(2);
									document.write(ominimo);								
								</script>
								
								</span>
								<small class="font-blue-sharp">oC</small>
							</h3>
						</div>
					</div>
				</div>	
			</div>
			<div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
				<div class="dashboard-stat2 ">
					<div class="display">
						<div class="number">
							<small>Temperatura en fahrenheit</small>
							<h3 class="font-purple-soft">
								<span data-value="7800" data-counter="counterup">
								<script type="text/javascript">
									var far=temperatura_actual*1.8+32;
									var ofar=far.toFixed(2);
									document.write(ofar);	
								</script>
								</span>
								<small class="font-purple-soft"> F</small>
							</h3>
						</div>
					</div>
				</div>	
			</div>
		</div>	
		<div class="row">
			<div class="col-md-12 col-sm-12 text-center">
				<div class="bloques">
					<h4 class="font-green-sharp">Temperatura leida Base de Datos</h4>
					<!--  <div id="chartdiv" style="width: 640px; height: 400px;"></div>-->
					<div id="chartdiv" style="width:100%; height:400px;"></div>
				</div>
			</div>

		</div>
	</div>
	

	
	
	<script type="text/javascript" src="http://www.amcharts.com/lib/3/amcharts.js"></script>
	<script type="text/javascript" src="http://cdn.amcharts.com/lib/3/serial.js"></script>
	<script type="text/javascript" src="http://www.amcharts.com/lib/3/themes/patterns.js"></script>
    
    <script type="text/javascript">
		AmCharts.ready(function() {
		// chart code will go here
		var chart = new AmCharts.AmSerialChart();
		chart.dataProvider = chartData1;
		chart.fontSize=18
		chart.title="horas del dia";
		chart.categoryField = "date";	


		var graph = new AmCharts.AmGraph();
		graph.valueField = "temperatura";
		graph.type = "smoothedLine";
		graph.min=10;
		graph.theme="patterns";
		graph.bullet = "round";
		graph.bulletSize=8,
		graph.lineAlpha=3;
		graph.lineThickness=3;
		graph.balloonText = "Temperatura: [[value]]<br><b><span style='font-size:14px;'> a las: [[category]] horas</span></b>";
		chart.addGraph(graph);

		// CURSOR
        var chartCursor = new AmCharts.ChartCursor();
        chartCursor.cursorAlpha = 0;
        chartCursor.cursorPosition = "mouse";
        chartCursor.categoryBalloonDateFormat = "YYYY";
       	chart.addChartCursor(chartCursor);
		

		var categoryAxis = chart.categoryAxis;
		categoryAxis.autoGridCount  = false;
		categoryAxis.gridCount = chartData1.length;
		categoryAxis.gridPosition = "start";
		categoryAxis.minorGridEnabled = true;
        categoryAxis.minorGridAlpha = 0.15;
		categoryAxis.labelRotation = 0;

		var valueAxis = new AmCharts.ValueAxis();
		valueAxis.title = "Temperatura Grados Centigrados";
		valueAxis.dashLength = 1;
		valueAxis.color="#6c7b88";
		valueAxis.titleColor="#6c7b88";
		valueAxis.minimum=10;
		valueAxis.maximum=30;
        chart.addValueAxis(valueAxis);

		chart.write('chartdiv');
	});
</script>



</body>
</html>
