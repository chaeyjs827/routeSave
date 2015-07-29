<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"


import="java.text.DecimalFormat" 
import="rsearch.connector.RoadInfo" 
import="rsearch.connector.RouteParameters"
import="rsearch.connector.RouteResult"
import="rsearch.connector.RouteClient"
import="rsearch.lib.RPoint"
import= "java.util.List"
import= "java.util.ArrayList"

%>

<%
String startText = request.getParameter("startText");
//String viaText = request.getParameter("viaText");
String arriveText = request.getParameter("arriveText");
int searchType = Integer.parseInt(request.getParameter("searchType"));
String checkType = "";
if(searchType != 2 && searchType != 1 && searchType != 5){
	checkType = "fail";
	searchType = 2;
}
long start = System.currentTimeMillis();
long end ;
long resultTime = 1010101010101l;
ArrayList<String> columnList=new ArrayList<String>();
//List<Double> one = new ArrayList<Double>();

String[] startCoordArr = startText.split(",");
double startCoordArrX = Double.parseDouble(startCoordArr[0]);
double startCoordArrY = Double.parseDouble(startCoordArr[1]);


//one.add(startCoordArrX);
//one.add(startCoordArrY);

//Double viaCoordArrX = 0.0;
//Double viaCoordArrY = 0.0;
//if(viaText!=""){
//String[] viaCoordArr = viaText.split(",");
//viaCoordArrX = Double.parseDouble(viaCoordArr[0]);
//viaCoordArrY = Double.parseDouble(viaCoordArr[1]);
//one.add(viaCoordArrX);
//one.add(viaCoordArrY);
//}


String[] arriveCoordArr = arriveText.split(",");
double arriveCoordArrX = Double.parseDouble(arriveCoordArr[0]);
double arriveCoordArrY = Double.parseDouble(arriveCoordArr[1]);
//one.add(arriveCoordArrX);
//one.add(arriveCoordArrY);

RouteClient client = new RouteClient();
//client.setServer("localhost",4781);
//client.setServer("localhost",8082);
//client.setServer("10.3.0.50", 8854); // kit
//client.setServer("origin.gcen.co.kr", 4701);
//client.setServer("origin.gcen.co.kr", 4901);
client.setServer("kit.gcen.co.kr", 4911);
//client.setServer("211.240.36.72", 4781);
RouteParameters param = new RouteParameters();
//param.setRouteMode(RouteParameters.ROUTE_MIN_DISTANCE);	// �ִܰŸ�
//param.setRouteMode(RouteParameters.ROUTE_OPTIMUM_SPEED);// ��õ�Ÿ�
param.setRouteMode(searchType);//

double [][] posArr = {
		{startCoordArrX, startCoordArrY},
		{arriveCoordArrX, arriveCoordArrY}
};
// ����� ����
System.out.println("����� : " + posArr[0][0] + " / " + posArr[0][1]);
param.setStart(posArr[0][0] , posArr[0][1]);

// ������ ����
for (int i = 1; i < posArr.length-1; i++) {
	
	System.out.println("������" + i + " : " + posArr[i][0] + " / " + posArr[i][1]);
	param.addPass(posArr[i][0], posArr[i][1]);
}

// ������ ����
System.out.println("������ : " + posArr[posArr.length - 1][0] + " / " + posArr[posArr.length - 1][1]);
param.setGoal(posArr[posArr.length - 1][0] , posArr[posArr.length - 1][1]);

param.setMakeGuide(true);

System.out.println();

//param.addAvoid(126.981209, 37.561975);

RouteResult result = client.routeCalc(param);

end = System.currentTimeMillis();

resultTime = end-start;

System.out.println("��� Ž�� �ð� : " + resultTime);
System.out.println(result.totalCoin);
System.out.println("��ü�Ÿ�: " + result.totalDistance);
System.out.println("Ž��������: " + result.sections.length);
//System.out.println("hashCode: " + result.hashCode());

DecimalFormat df = new DecimalFormat("#,##0");
DecimalFormat df2 = new DecimalFormat("0.000000");		
DecimalFormat df3 = new DecimalFormat("###0");
String allPathPoints = ""; // ��� ��� ��ǥ
String realPathPoints = "";
String allTime = "";
String distance = "";
String onlyDistance = "";
String onlyTime = "";
String guides = "";
for(int secpos=0;secpos<result.sections.length;secpos++) {
	String pathPoints = "";
	System.out.println("========= ���� " + (secpos+1) + " ===========");
	System.out.println("�����: " + result.sections[secpos]._pointStart);
	System.out.println("������: " + result.sections[secpos]._pointGoal);
	distance = "�����Ÿ�: " + df.format(result.sections[secpos]._distance) + " m";
	onlyDistance = df3.format(result.sections[secpos]._distance);
	System.out.println("");
	System.out.println("�����Ÿ�: " + df.format(result.sections[secpos]._distance) + " m");
	
	int dueTime = result.sections[secpos]._travelTime;
	
	allTime = "a";
			if(dueTime/3600 > 0){
				allTime = "����ð�: " + dueTime/3600 + "�ð� " + (dueTime%3600)/60 + "�� " + ((dueTime%3600)%60)%60 + "��";
			}else{
				if((dueTime%3600)/60 != 0){
					allTime = "����ð�: " + (dueTime%3600)/60 + "�� " + ((dueTime%3600)%60)%60 + "��";
				}else{
					allTime = "����ð�: " + ((dueTime%3600)%60)%60 + "��";
				}
			}
	onlyTime = ""+dueTime+"";
	System.out.println(allTime);
	////////

	//////////
	
	// ��� �ȳ� ����
	for(int i=0;i<result.sections[secpos]._guide.length;i++) {
		System.out.println("guide[" + i + "] = [" + result.sections[secpos]._guide[i] + "]");
		guides += result.sections[secpos]._guide[i]+",";
	}
	
	
	for (int j = 0; j < result.sections[secpos]._points.length; j++) {
		pathPoints += df2.format(result.sections[secpos]._points[j].x) + "," + df2.format(result.sections[secpos]._points[j].y) + ",";
		
		//allPathPoints += pathPoints;
	}
	
	pathPoints = (pathPoints+",").replace(",,", "");
	//realPathPoints += pathPoints;f
	realPathPoints = pathPoints;
	/*
	end = System.currentTimeMillis();
	resultTime = end-start;
	System.out.println("���� ��� Ž�� �ð� : " + resultTime);
	*/
	//System.out.println("��� ��ǥ : " + pathPoints);
}
//System.out.println("\n" + "��� ��� ��ǥ : " + allPathPoints);

System.out.println("");
System.out.println("���Ž�� ����");

System.out.println(realPathPoints);


%>
[
{
"startText": "<%=startText %>", "arriveText":"<%=arriveText %>", "distance":"<%=distance %>", "resultTime":"<%=resultTime %>",
"searchtype":"<%=searchType %>", "realpath":"<%=realPathPoints %>", "allTime":"<%=allTime %>","onlyDistance":"<%=onlyDistance %>",
"onlyTime": "<%=onlyTime %>", "guides" : "<%=guides %>", "checkType" : "<%=checkType %>"
}
]
