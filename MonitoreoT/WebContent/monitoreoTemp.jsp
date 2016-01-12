<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta http-equiv="refresh" content="15" >
<title>Monitoreo Temperatura Tiempo Real</title>
<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="colores.css">
<link rel="stylesheet" type="text/css" href="components.min.css">
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
		         try {
					Class.forName("org.postgresql.Driver");
					String url="jdbc:postgresql://localhost:5432/postgres";
					try {
						conDB=DriverManager.getConnection(url,"postgres","irf840");
						String query="SELECT * FROM temps;";
						//String query="INSERT INTO temps(temp,time) VALUES("+"'"+inputLine+"'"+","+"'"+time+"'"+");";
						//System.out.println("query: "+query+"\r\n"+"\r\n");
						Statement st=conDB.createStatement();
						ResultSet rs=st.executeQuery(query);
						float temperatura=0;
						String date=null;
						StringBuilder json = new StringBuilder();
						out.println("var chartData1 = [{");
						prescalerDb=3;
						prescalerMin=29;
						float maximo=0;
						float minimo=40;
						while (rs.next()){
							temperatura=rs.getFloat("temp");
							date=rs.getString("time");
							prescalerDb++;
							if (prescalerDb==4){//cada minuto
								prescalerDb=0;
								prescalerMin++;
								if (prescalerMin==30){//cada 30 minutos
									prescalerMin=0;
									json.append("\"date\": "+"\""+date+"\""+","+"\r");
									json.append("\"temperatura\": "+"\""+temperatura+"\""+"\r");						
									json.append("}"+","+"{"+"\r");
								}
							}
							if (temperatura>maximo){
								maximo=temperatura;
							}
							if (temperatura<minimo){
								minimo=temperatura;
							}
						}
						String jsonstr=json.toString();
						jsonstr=jsonstr.substring(0, jsonstr.length()-3)+"];";
						out.println(jsonstr);
						out.println("var temperatura_actual="+temperatura+";");
						out.println("var maximo="+maximo+";");
						out.println("var minimo="+minimo+";");
						date=date.substring(0, date.length()-4);
						out.println("var date="+"\""+date+"\""+";");
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
				<h2 class="font-green-sharp">Monitoreo de la Temperatura Ambiente de Bogota por Internet</h2>
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
					<div id="chartdiv" style="width: 1100px; height: 540px;"></div>
				</div>
			</div>

		</div>
	</div>

	
	<script src="amcharts/amcharts.js" type="text/javascript"></script>
	<script src="amcharts/serial.js" type="text/javascript"></script>	
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css">
    <script src="amcharts/pie.js" type="text/javascript"></script>
    
    <script type="text/javascript">
		AmCharts.ready(function() {
		// chart code will go here
		var chart = new AmCharts.AmSerialChart();
		chart.dataProvider = chartData1;
		chart.categoryField = "date";	


		var graph = new AmCharts.AmGraph();
		graph.valueField = "temperatura";
		graph.type = "smoothedLine";
		graph.min=10;
		chart.addGraph(graph);

		var categoryAxis = chart.categoryAxis;
		categoryAxis.autoGridCount  = false;
		categoryAxis.gridCount = chartData1.length;
		categoryAxis.gridPosition = "start";
		categoryAxis.labelRotation = 90;

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